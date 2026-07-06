# MCP (Model Context Protocol) — How It Works

MCP servers are independent processes that expose tools to the agent. They run alongside the agent, providing specialized capabilities: file system access, database queries, web APIs, code analysis, etc.

## How MCP Servers Are Configured

In `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["path/to/server/index.js"],
      "env": {
        "API_KEY": "env-var-name"
      }
    }
  }
}
```

Each server is a process. The agent starts it on demand, sends JSON-RPC requests, and receives tool results.

## Why mcp.json May Be Empty

MCP tools can come from multiple sources:

| Source | Config Location | Example |
|--------|----------------|---------|
| `mcp.json` | `~/.claude/mcp.json` | User-added servers |
| Desktop app | Claude Desktop settings | Desktop-only servers |
| Project config | `<project>/.claude/mcp.json` | Per-project servers |
| Environment | CLI-injected | headroom, codegraph |

In some setups, MCP servers like **headroom** and **codegraph** are injected by the environment (CLI harness), not via `mcp.json`. That's why `mcp.json` may be empty while MCP tools still appear in the skill list.

## Available MCP Tool Types

| Server | Tools | Purpose |
|--------|-------|---------|
| **codegraph** | `codegraph_explore` | Codebase symbol search + source retrieval |
| **headroom** | `headroom_compress`, `headroom_retrieve`, `headroom_stats` | Context window compression |
| *Add your own* | Custom tools | Database, web APIs, file system, etc. |

## Adding an MCP Server

1. Find or build an MCP server (many open-source on GitHub)
2. Add entry to `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "uvx",
      "args": ["mcp-server-name"],
      "env": {}
    }
  }
}
```

3. Restart agent. Tools appear automatically in the tool list.

## Cross-Platform Notes

| Aspect | macOS / Linux | Windows 11 |
|--------|---------------|------------|
| Command | `"command": "node"` | `"command": "node.exe"` |
| Args | `/path/to/server.js` | `C:\path\to\server.js` |
| Python | `python3` | `python` or `py` |
| UVX | `uvx` | `uvx` (cross-platform) |

## Security

MCP servers have full access to their args and env. Only run servers you trust. Consider:
- Scoping env vars to minimum necessary
- Using read-only servers where possible
- Running in containerized environments for untrusted servers

## In This Pack

This pack does not ship MCP servers. It documents the pattern so you can:
- Understand how MCP tools appear in your environment
- Add your own MCP servers for databases, APIs, or custom integrations
- Adapt configurations across platforms
