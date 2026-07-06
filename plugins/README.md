# Plugin System — How It Works

Plugins are reusable packages from marketplaces. Each plugin contributes skills, agents, commands, and config. They install to `~/.claude/plugins/cache/`.

## Plugin Anatomy

```
plugin-name/
├── SKILL.md              ← Optional: contributed skills
├── AGENTS.md             ← Optional: contributed subagents
├── CLAUDE.md             ← Optional: additional instructions
├── commands/             ← Optional: custom slash commands
├── skills/               ← Subdirectory of skills
└── dist/                 ← Compiled assets
```

## How Skills Get Injected

When a plugin is enabled in `settings.json`, its skills appear in the agent's available-skills list. Example:

```json
{
  "enabledPlugins": {
    "caveman@caveman": true,
    "planning-with-files@planning-with-files": true
  }
}
```

This makes the following skills available:
- From caveman: `caveman`, `caveman-commit`, `caveman-review`, `caveman-compress`, `caveman-help`, `caveman-stats`, `cavecrew`
- From planning-with-files: `planning-with-files`, `planning-with-files-zh`, `planning-with-files-ar`, etc.

## Available Plugin Marketplaces

Configured in `~/.claude/plugins/known_marketplaces.json`:

| Marketplace | ID | Source |
|-------------|-----|--------|
| Caveman | `caveman@caveman` | GitHub: `caveman` |
| Planning-with-files | `planning-with-files@planning-with-files` | GitHub: `planning-with-files` |
| Official plugins | `*-lsp@claude-plugins-official` | Anthropic official |

## Installing a Plugin

Via marketplace browser (UI) or config:

```json
{
  "enabledPlugins": {
    "<name>@<marketplace>": true
  }
}
```

The agent resolves, downloads, and caches the plugin on next activation.

## Plugin Types

| Type | What It Provides | Example |
|------|-----------------|---------|
| Skill | New invocable capabilities | `caveman`, `planning-with-files` |
| Agent | Specialized subagent types | `caveman:cavecrew-builder`, `caveman:cavecrew-reviewer` |
| Command | Custom slash commands | `opsx` |
| LSP | Language server | `swift-lsp` |

## Profile Pack & Plugins

This pack does NOT ship plugin binaries. Instead, it:
- Documents the plugin system pattern
- Lists recommended plugins in `manifest.json`
- Provides the `enabledPlugins` config template
- The installer can optionally enable plugins via settings

To add a plugin after installing this pack:
1. Find the plugin in a marketplace
2. Add `"<name>@<marketplace>": true` to `settings.json` under `enabledPlugins`
3. Restart the agent — skills appear automatically
