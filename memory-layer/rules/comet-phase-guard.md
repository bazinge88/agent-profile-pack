# Comet Phase Guard — Always-On Rules

> Prevents phase drift in Comet workflow.
> Active whenever `openspec/changes/<name>/.comet.yaml` exists.

## Phase Awareness (Highest Priority)

Before any operation, read `phase` from `.comet.yaml`.

| Phase | Allowed | Forbidden |
|-------|---------|-----------|
| `open` | Create proposal/design/tasks, run guard | Write source code |
| `design` | Brainstorming, Design Doc, run guard | Write source code |
| `build` | Write source code, tests, execute plan | Skip user confirmation |
| `verify` | Verify, branch handling | Skip failure handling |
| `archive` | Confirm archive, run archive script | Write source code |

## Phase Entry Consistency (Check Before Writing Source)

Before writing any source code, verify `.comet.yaml` is not in an **illegal skip** state:

| Detection | Verdict | Action |
|-----------|---------|--------|
| `phase: build` + `workflow: full` + `design_doc` empty/null | Skipped design | Run `/comet-design` first |
| `phase: build/verify` + proposal/design/tasks missing | Skipped open | Run `/comet-open` first |
| `phase: archive` + `verify_result != pass` | Skipped verify | Run `/comet-verify` first |

**Exceptions:** `workflow: hotfix/tweak` legitimately skips design — `design_doc` null is normal.

## User Confirmation Points

Must wait for user — never auto-approve:

- **open**: requirement clarification done, artifact review
- **design**: brainstorming solution confirmed (before Design Doc)
- **build**: plan-ready pause, isolation/build mode selection
- **verify**: failure handling strategy, branch handling
- **archive**: final confirmation

## Script Execution

Always run guard checks via:
```bash
comet-guard <change-name> <phase> --apply
```

Never manually edit `.comet.yaml`. Use `comet-state set` for field updates.
Never skip phase via `comet-state set <name> phase <value>` (hard-blocked by script).
Use `COMET_FORCE_PHASE=1` escape valve only for fixing corrupted state.

## Context Recovery

If suspecting context compression (summary replaced earlier conversation):

1. Run: `comet-state check <name> <phase> --recover`
2. Follow recovery action output
3. Re-check phase consistency table above
4. If inconsistency found: return to correct phase, do not trust `phase` field

## Phase Exit & Auto-Transition

After `guard --apply` passes:

```bash
comet-state next <change-name>
```

Interpret output:
- `NEXT: auto` → load next phase skill via Skill tool
- `NEXT: manual` → follow HINT, no auto-load
- `NEXT: done` → workflow complete
