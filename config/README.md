# Configuration — How Settings Work

Two-tier config:

```
~/.claude/
├── settings.json          ← Version-controlled, syncable
└── settings.local.json    ← User-local, gitignored
```

## settings.json

Stores model routing, environment, and enabled plugins.

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:8787",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-4-6[1M]"
  },
  "model": "sonnet",
  "enabledPlugins": {
    "caveman@caveman": true,
    "planning-with-files@planning-with-files": true
  }
}
```

**Key fields:**
- `env.*` — Environment variables injected into agent session
- `model` — Default model (`sonnet`, `opus`, `haiku`, `fable`)
- `enabledPlugins` — Market plugins to activate

## settings.local.json

Stores permissions and hooks. User-local — contains no secrets, just convenience rules.

```json
{
  "permissions": {
    "allow": [
      "Bash(pnpm *)",
      "PowerShell(winget install *)",
      "WebSearch"
    ]
  },
  "hooks": {
    "PreToolUse": "bash /path/to/guard.sh"
  },
  "dangerouslySkipPermissions": false
}
```

**Permission patterns:**
- `Bash(<glob>)` — Allow matching shell commands
- `PowerShell(<glob>)` — Allow matching PowerShell commands (Win11)
- `Read(<glob>)` — Allow reading matching file paths
- `WebSearch` — Allow web search
- `WebFetch(domain:example.com)` — Allow fetching from specific domains
- `Workflow(<name>)` — Allow named workflow

**Hooks:** PreToolUse fires before each tool call. Use for guardrails.

## Cross-Platform Notes

- `settings.json` is identical on all platforms
- `settings.local.json` permissions differ by OS:
  - macOS: `Bash(brew *)`, `Bash(osascript *)`, `Bash(sw_vers)`
  - Linux: `Bash(apt *)`, `Bash(systemctl *)`
  - Win11: `PowerShell(winget *)`, `PowerShell(Get-Process *)`
- Hook command changes:
  - Unix: `"bash /path/to/script.sh"`
  - Win11: `"pwsh -File \"/path/to/script.ps1\""`
