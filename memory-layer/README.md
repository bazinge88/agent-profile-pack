# Memory Layer — How It Works

The memory layer is a three-tier agent instruction system. Each tier scope and persistence differ.

## Tier 1: Global CLAUDE.md

**File:** `~/.claude/CLAUDE.md`
**Scope:** Every session, every project.
**Purpose:** Universal engineering principles, tool rules, interaction norms.

What it encodes:
- **Role definition**: Autonomous engineering assistant
- **Engineering principles**: Think before coding, simplicity first, surgical changes
- **Tool rules**: Prefer dedicated tools, parallelize calls, search before asking
- **Code quality**: Comment only non-obvious constraints, match existing style
- **Documentation**: Maintain CLAUDE.md for project knowledge, use `.context/` for working docs
- **Autonomy**: Do it don't propose it, finish each round, try before escalating

## Tier 2: Project CLAUDE.md

**File:** `<project-root>/.claude/CLAUDE.md`
**Scope:** Current project only. Overrides global for matching keys.
**Purpose:** Build commands, test patterns, deployment steps, architecture decisions.

When to update:
- Discovered new build command
- Hit a gotcha another agent should avoid
- Made an architectural decision that affects how code is written

## Tier 3: Runtime Rules

**Files:** `~/.claude/rules/*.md`
**Scope:** Always active, every session.
**Purpose:** Guardrails that don't belong in workflow instructions.

Current rules:
- `comet-phase-guard.md` — Prevents writing source code in wrong Comet phase

## Memory System (`~/.claude/projects/*/memory/`)

Persistent cross-session memory. Four types:

| Type | Content | When to Write |
|------|---------|---------------|
| `user` | User role, preferences, knowledge | When learning about the user |
| `feedback` | Corrections and confirmed approaches | After user correction or approval |
| `project` | Ongoing work, goals, deadlines | When learning context behind work |
| `reference` | External system pointers | When learning where to find data |

**File format:**
```markdown
---
name: short-slug
description: One-line summary for relevance matching
metadata:
  type: user|feedback|project|reference
---
Content.
Link related: [[other-memory-name]]
```

**Index:** `MEMORY.md` lists all files with one-line hooks. Kept under 200 lines.

## Installation

Copy files:
```bash
# Global instructions
cp memory-layer/CLAUDE.md ~/.claude/CLAUDE.md

# Rules
mkdir -p ~/.claude/rules
cp memory-layer/rules/*.md ~/.claude/rules/
```

Or use `install.sh` from project root.
