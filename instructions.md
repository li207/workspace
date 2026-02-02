# Workspace Framework Reference

Detailed reference for the workspace system. See `CLAUDE.md` for quick overview.

## Directory Structure

```
workspace/                          # Framework (shareable)
├── commands/                       # Global commands → ~/.claude/commands/
│   ├── todo.md
│   ├── visual.md
│   └── workspace.md
├── modules/                        # Module specs
│   ├── todo/README.md
│   ├── visual/README.md
│   └── workspace/README.md
└── workspace-data/                 # Private data (gitignored)
    ├── todo/
    │   ├── active.md
    │   └── archive/
    └── workspace/
        ├── {task-id}/
        └── archive/
```

## Command Details

### /todo
Natural language task management.

**Intents:** create | list | done/complete | update | review | help

**Parsing:**
- Priorities: urgent/critical → p0, high → p1, medium → p2, low → p3
- Dates: tomorrow, friday, "feb 15", "next monday", "in 3 days"
- Context: Everything after main task description

### /workspace
Task-specific isolated environments.

**Intents:** create | open | status | summarize | list | clean | help

**Creates:** README.md, CLAUDE.md, PROGRESS.md, docs/, logs/, scratch/

### /visual
Dashboard visualization server.

**Intents:** start | stop | status | open | (default: start + open)

## Data Formats

### Task (active.md)
```markdown
- [ ] Task title #id:abc123
  - priority: p1
  - created: 2026-01-31
  - due: 2026-02-02
  - tags: [security, backend]
  - context: Requirements and notes
```

### Completed Task (archive/YYYY-MM-DD.md)
```markdown
- [x] Task title #id:abc123
  - priority: p1
  - created: 2026-01-31
  - due: 2026-02-02
  - completed: 2026-02-01
  - tags: [security, backend]
  - context: Implementation notes
```

### Workspace PROGRESS.md
```markdown
# Progress: {task-title}

## Accomplishments
- [YYYY-MM-DD HH:MM] Completed X

## Current Focus
Working on Y

## Next Actions
- [ ] Do Z

## Blockers
None
```

## Extension Pattern

### Adding Commands
1. Create `commands/name.md` with frontmatter and processing logic
2. Run `./bootstrap.sh` to install to `~/.claude/commands/`

### Adding Modules
1. Create `modules/name/README.md` with specs
2. Create `workspace-data/name/` for storage
3. Optional: Create matching command

## ID Generation

6-character alphanumeric: `#id:abc123`
Generated from timestamp + content hash.
