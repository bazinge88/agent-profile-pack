#!/bin/bash
set -euo pipefail

AGENT_DIR="${HOME}/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
BACKUP_DIR="${AGENT_DIR}/backups/agent-profile-pack-$(date +%Y%m%d_%H%M%S)"

echo "[agent-profile-pack] Installing..."

mkdir -p "${BACKUP_DIR}"

# 1. Memory layer
echo "  [1/5] Installing memory layer..."
[ -f "${AGENT_DIR}/CLAUDE.md" ] && cp "${AGENT_DIR}/CLAUDE.md" "${BACKUP_DIR}/"
cp "${SCRIPT_DIR}/memory-layer/CLAUDE.md" "${AGENT_DIR}/CLAUDE.md"
mkdir -p "${AGENT_DIR}/rules"
cp "${SCRIPT_DIR}/memory-layer/rules/comet-phase-guard.md" "${AGENT_DIR}/rules/"

# 2. Skills — copy all into ~/.claude/skills/
echo "  [2/5] Installing skills..."
mkdir -p "${AGENT_DIR}/skills"
for skill_dir in "${SCRIPT_DIR}"/skills/*/; do
  skill_name="$(basename "${skill_dir}")"
  # Skip non-skill subdirs
  case "$skill_name" in openspec|commands|reference|scripts) continue;; esac
  if [ -d "${AGENT_DIR}/skills/${skill_name}" ]; then
    cp "${BACKUP_DIR}" 2>/dev/null || true
  fi
  cp -R "${skill_dir}" "${AGENT_DIR}/skills/${skill_name}" 2>/dev/null && echo "    skill: ${skill_name}" || echo "    skip: ${skill_name}"
done

# Comet sub-skills (comet-open, comet-build, etc.)
for comet_skill in open design build verify archive hotfix tweak; do
  src="${SCRIPT_DIR}/skills/comet-${comet_skill}"
  [ -d "$src" ] && cp -R "$src" "${AGENT_DIR}/skills/comet-${comet_skill}" 2>/dev/null && echo "    sub-skill: comet-${comet_skill}"
done

# OpenSpec skills (top level)
for odir in "${SCRIPT_DIR}"/skills/openspec-*/; do
  [ -d "$odir" ] && cp -R "$odir" "${AGENT_DIR}/skills/$(basename "$odir")" 2>/dev/null && echo "    openspec: $(basename "$odir")"
done

# Other top-level skills (brainstorming, docx, pptx, xlsx, etc.)
for s in brainstorming dispatching-parallel-agents docx pptx xlsx pdf-converter web-access pua teach grill-me neat-freak; do
  src="${SCRIPT_DIR}/skills/${s}"
  [ -d "$src" ] && cp -R "$src" "${AGENT_DIR}/skills/${s}" 2>/dev/null && echo "    skill: ${s}"
done

# 3. Plugins — enable in settings.json
echo "  [3/5] Enabling plugins..."
SETTINGS="${AGENT_DIR}/settings.json"
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "${BACKUP_DIR}/" 2>/dev/null || true
fi
# Inject enabledPlugins if not present
python3 -c "
import json, sys
path = '$SETTINGS'
try:
  with open(path) as f: cfg = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
  cfg = {}
cfg.setdefault('enabledPlugins', {})
cfg['enabledPlugins'].setdefault('caveman@caveman', True)
cfg['enabledPlugins'].setdefault('planning-with-files@planning-with-files', True)
with open(path, 'w') as f: json.dump(cfg, f, indent=2)
print('  plugins enabled: caveman, planning-with-files')
" 2>/dev/null || echo "  warning: could not update settings.json"

# 4. Comet hook guard
echo "  [4/5] Configuring hooks..."
LOCAL_SETTINGS="${AGENT_DIR}/settings.local.json"
python3 -c "
import json, sys
path = '$LOCAL_SETTINGS'
try:
  with open(path) as f: cfg = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
  cfg = {}
cfg.setdefault('hooks', {})
cfg['hooks']['PreToolUse'] = 'bash ${AGENT_DIR}/skills/comet/scripts/comet-hook-guard.sh'
with open(path, 'w') as f: json.dump(cfg, f, indent=2)
print('  hook configured: comet-hook-guard')
" 2>/dev/null || echo "  warning: could not set hook"

# 5. MCP config reference
echo "  [5/5] MCP note..."
echo "  headroom, codegraph MCP servers are environment-provided."
echo "  See mcp/README.md for configuration."

echo ""
echo "✓ Installation complete!"
echo "  Backup at: ${BACKUP_DIR}"
echo ""
echo "Capabilities enabled:"
echo "  - Memory layer (CLAUDE.md + rules)"
echo "  - Comet workflow (comet + 6 phases + 2 presets)"
echo "  - OpenSpec change management (11 skills)"
echo "  - AnySearch (cross-platform search)"
echo "  - Plugins: caveman, planning-with-files"
echo "  - Hook guard (phase enforcement)"
