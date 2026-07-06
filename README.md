# Agent Profile Pack

Cross-platform Claude Code agent profile. Clone, run install, get everything.

Other agents: **read this file first.** It inventories all capabilities, files, and auto-config steps.

---

## Quick Facts

| Attribute | Value |
|-----------|-------|
| Skills | 31 (8 comet + 11 openspec + 12 standalone) + 14 plugin-contributed |
| Files | ~200+ (SKILL.md + scripts + references + docs) |
| Plugins | caveman (6 skills), planning-with-files (8 skills) |
| MCP Servers | codegraph, headroom (env-provided) |
| Platforms | macOS, Linux, Windows 11 |
| License | MIT |

---

## File Tree

```
agent-profile-pack/
├── README.md                       ← Agent-facing inventory (this file)
├── manifest.json                   ← Machine-readable capability matrix
├── LICENSE (MIT)
├── .gitignore
├── install.sh                      ← POSIX auto-installer
├── install.ps1                     ← Windows auto-installer
│
├── memory-layer/
│   ├── README.md                   ← Memory system documentation
│   ├── CLAUDE.md                   ← Core agent instructions (drop-in)
│   └── rules/
│       └── comet-phase-guard.md    ← Phase enforcement guardrails
│
├── skills/
│   ├── README.md                   ← Skill catalog with activation triggers
│   │
│   ├── comet/                      ★ WORKFLOW ENGINE ★
│   │   ├── SKILL.md                ← Router/dispatcher
│   │   ├── scripts/                ← 7 shell scripts (guard, state, handoff, etc.)
│   │   └── reference/              ← 8 docs (decision points, auto-transition, etc.)
│   │
│   ├── comet-open/                 ← Phase: open
│   ├── comet-design/               ← Phase: design
│   ├── comet-build/                ← Phase: build
│   ├── comet-verify/               ← Phase: verify
│   ├── comet-archive/              ← Phase: archive
│   ├── comet-hotfix/               ← Preset: hotfix (skip design)
│   ├── comet-tweak/                ← Preset: tweak (lightweight)
│   │
│   ├── openspec-new-change/       ← Step-by-step change creation
│   ├── openspec-propose/          ← One-shot proposal + artifacts
│   ├── openspec-explore/          ← Explore mode (thinking partner)
│   ├── openspec-ff-change/        ← Fast-forward artifact generation
│   ├── openspec-continue-change/  ← Next artifact
│   ├── openspec-apply-change/     ← Execute implementation tasks
│   ├── openspec-verify-change/    ← Validate implementation
│   ├── openspec-archive-change/   ← Finalize and archive
│   ├── openspec-bulk-archive-change/ ← Batch archive
│   ├── openspec-sync-specs/       ← Sync delta specs
│   ├── openspec-onboard/          ← Guided walkthrough for new users
│   │
│   └── anysearch/                  ★ SEARCH ★
│       ├── SKILL.md                ← Unified search instructions
│       └── scripts/                ← Python, JS, PowerShell, Bash clients
│
├── plugins/
│   └── README.md                   ← Plugin system documentation
│
├── mcp/
│   └── README.md                   ← MCP server configuration guide
│
└── config/
    ├── README.md                   ← Settings system documentation
    └── settings.json               ← Cross-platform config template
```

---

## Installation (Auto-Config)

Clone and run. That's it.

### macOS / Linux
```bash
git clone https://github.com/bazinge88/agent-profile-pack
cd agent-profile-pack && chmod +x install.sh && ./install.sh
```

### Windows 11 (Admin PowerShell)
```powershell
.\install.ps1
```

### What install.sh Does

| Step | Action |
|------|--------|
| 1. Memory layer | Copy `CLAUDE.md` + `rules/comet-phase-guard.md` → `~/.claude/` |
| 2. Skills | Copy all skill directories → `~/.claude/skills/` |
| 3. Plugins | Enable `caveman@caveman`, `planning-with-files@planning-with-files` in `settings.json` |
| 4. Hooks | Set `PreToolUse` → comet-hook-guard in `settings.local.json` |
| 5. MCP | Print configuration reference |

### After Install — What's Ready

- `/comet` — Staged dev workflow (open → design → build → verify → archive)
- `/comet-hotfix` — Quick bug fixes
- `/comet-tweak` — Small config/docs changes
- `/openspec-new-change` | `/openspec-propose` — Change management
- `anysearch` — Web search via skill
- `caveman` — Compressed communication (use `/caveman`)
- `planning-with-files` — File-based task planning (use `/plan`)
- **Phase guard** auto-enforces workflow stage rules
- **CLAUDE.md** encodes engineering principles globally

---

## Capability Inventory

### 1. Workflow Engine (Comet)

Staged feature development with state machine guard.

```
open → design → build → verify → archive
```

**Artifact chain:** `openspec/changes/<name>/`
```
├── .comet.yaml         ← Phase + workflow + metadata
├── proposal.md         ← What and why
├── design.md           ← How (Design Doc for full workflow)
├── tasks.md            ← Implementation checklist
└── spec/               ← Delta specs
```

**Guard rules (always active via hook):**

| Phase | Can Write Source? | Can Create Artifacts? |
|-------|------------------|----------------------|
| open | No | Yes (proposal/design/tasks) |
| design | No | Yes (Design Doc, brainstorm) |
| build | Yes | Yes |
| verify | No | No (only test/validate) |
| archive | No | No (only archive ops) |

**Presets:**
- `comet-hotfix`: Skip design, direct open→build→verify→archive
- `comet-tweak`: Skip design + full plan, lightweight path

**Scripts:** 7 bash scripts drive the state machine:
- `comet-state.sh` — State CRUD + validation
- `comet-guard.sh` — Phase entry/exit enforcement
- `comet-hook-guard.sh` — PreToolUse hook for out-of-phase block
- `comet-handoff.sh` — Phase transition handoff generation
- `comet-env.sh` — Script locator + environment
- `comet-archive.sh` — Archive routines
- `comet-yaml-validate.sh` — YAML field validation

### 2. Change Management (OpenSpec)

11 skills for structured change management. Lower level than Comet — Comet orchestrates OpenSpec.

| Skill | Command | Action |
|-------|---------|--------|
| openspec-new-change | `/openspec-new-change` | Step-by-step artifact creation |
| openspec-propose | `/openspec-propose` | One-shot all artifacts |
| openspec-explore | `/openspec-explore` | Thinking partner, no artifacts |
| openspec-ff-change | `/openspec-ff-change` | Fast-forward generation |
| openspec-continue-change | `/openspec-continue-change` | Next artifact |
| openspec-apply-change | `/openspec-apply-change` | Execute tasks |
| openspec-verify-change | `/openspec-verify-change` | Validate implementation |
| openspec-archive-change | `/openspec-archive-change` | Finalize |
| openspec-bulk-archive-change | `/openspec-bulk-archive-change` | Batch archive |
| openspec-sync-specs | `/openspec-sync-specs` | Sync delta to main spec |
| openspec-onboard | `/openspec-onboard` | First-time walkthrough |

Also available as `opsx <command>` via slash commands.

### 3. Unified Search (AnySearch)

Cross-platform search skill. 4 language clients: Python (preferred), JavaScript, Bash, PowerShell.

Capabilities:
- General web search
- Vertical search (stocks, academic, legal, health, code)
- Batch parallel search
- URL content extraction

Sites needing login/JS rendering → auto-delegated to browser CDP layer.

### 4. Plugin System

Enabled by default after install:

| Plugin | Source | Contributes |
|--------|--------|-------------|
| **caveman** | `caveman@caveman` | 6 skills + 3 agents + 1 command |
| **planning-with-files** | `planning-with-files@planning-with-files` | 8 skills, multi-language |

Plugin skills appear automatically in the available-skills list. Use `/caveman`, `/plan`, etc.

### 5. Memory Layer

Three-tier agent instruction system:

| Tier | File | Installed To | Scope |
|------|------|-------------|-------|
| Global | `CLAUDE.md` | `~/.claude/CLAUDE.md` | Every session |
| Project | `CLAUDE.md` in repo | `<project>/.claude/CLAUDE.md` | Per-project |
| Rules | `comet-phase-guard.md` | `~/.claude/rules/` | Always active |

**Key engineering principles encoded:**
- Think before coding, simplicity first, surgical changes
- Recommend don't enumerate, search before asking
- Do it don't propose it, finish each round

### 6. MCP Servers

Environment-provided:

| Server | Tools | Purpose |
|--------|-------|---------|
| **codegraph** | `codegraph_explore` | Symbol search + source retrieval |
| **headroom** | `headroom_compress`, `headroom_retrieve`, `headroom_stats` | Context compression |

MCP servers are configured via `~/.claude/mcp.json`. Each is an independent process exposing JSON-RPC tools. Cross-platform.

### 7. Configuration

Two-tier settings:
- `settings.json` — Model routing, env vars, enabled plugins (version-controlled)
- `settings.local.json` — Permissions allowlist, hooks (user-local)

---

## Agent Auto-Configuration

Other agents: to configure yourself from this pack:

1. **Read this file** — understand capability inventory
2. **Clone and install** — `git clone` then `./install.sh` or `.\install.ps1`
3. **After install**, your environment has:
   - `~/.claude/CLAUDE.md` — Engineering principles
   - `~/.claude/rules/comet-phase-guard.md` — Stage guard
   - `~/.claude/skills/comet*` — Workflow engine
   - `~/.claude/skills/openspec-*` — Change management
   - `~/.claude/skills/anysearch/` — Search skill
   - `.claude/settings.json` — Plugins enabled, model configured
   - `.claude/settings.local.json` — Hook active
4. **For platform adaptation:**
   - Windows: use `install.ps1` (PowerShell-based)
   - macOS/Linux: use `install.sh` (bash-based)
   - Scripts in `skills/comet/scripts/` are bash — Windows needs WSL or manual port

### Verification

After install, confirm:
```bash
ls ~/.claude/CLAUDE.md                      # Memory layer
ls ~/.claude/rules/comet-phase-guard.md     # Phase guard
ls ~/.claude/skills/comet/scripts/          # Comet scripts (7 files)
ls ~/.claude/skills/openspec-*/SKILL.md     # OpenSpec (11 skills)
grep caveman ~/.claude/settings.json        # Plugin enabled
grep PreToolUse ~/.claude/settings.local.json # Hook active
```

---

## Cross-Platform Notes

| Aspect | macOS/Linux | Windows 11 |
|--------|-------------|------------|
| Installer | `install.sh` | `install.ps1` |
| Comet scripts | bash (native) | needs WSL or manual port |
| Package manager | brew, apt | winget |
| Hooks | bash guard.sh | pwsh wrapper |
| Permissions | `Bash(...)` | `PowerShell(...)` |

**Comet on Win11:** The 7 bash scripts in `skills/comet/scripts/` won't run natively. Options:
1. Use WSL (recommended)
2. Port scripts to PowerShell (see `adapters/win11/` in future releases)
3. Run Comet workflow via OpenSpec skills (SKILL.md-only, no scripts needed)

---

## License

MIT — use freely, fork proudly.
