---
title: Workspace Management
description: Task-specific isolated workspace environments
user-invocable: true
args:
  - name: command
    description: Natural language workspace command
    type: string
    required: false
---

Manage task workspaces. Config: `~/.claude/workspace-path.txt` → WORKSPACE_DATA_DIR

## Command: {{command}}

**Intents:** create/new | open/switch/"work on" | status/report | summarize/update | list/show | clean/archive | help

## Operations

**CREATE** → Parse task ref (ID/position/description), create `workspace/{task-id}/` with: README.md, CLAUDE.md, PROGRESS.md, docs/, logs/, scratch/

**OPEN** → Resolve task ID, switch to workspace (auto-create if needed), read CLAUDE.md for context

**STATUS** → Read PROGRESS.md, show: progress summary, accomplishments, next actions, blockers

**SUMMARIZE/UPDATE** → Use current session context to update PROGRESS.md: add accomplishments, update current focus, revise next actions, note any blockers. Preserve existing content, append new items with timestamps.

**LIST** → Show all workspaces with task title, priority, status, file counts. Sort by priority → created

**CLEAN** → Archive completed workspaces, remove empty ones (confirm before delete)

**HELP** → Read `modules/workspace/README.md` via Task tool

## Generated CLAUDE.md Template
```
# Task: {title} #id:{id}
Priority: {priority} | Created: {date}

## Context
{context from TODO}

## Auto-Update Rule
UPDATE PROGRESS.md at these checkpoints:
- Significant code changes committed
- Major milestone reached
- Blocker encountered or resolved
- Before ending session
Format: Append to relevant section with timestamp [YYYY-MM-DD HH:MM]
```

## Paths
- Workspaces: `WORKSPACE_DATA_DIR/workspace/{task-id}/`
- TODO: `WORKSPACE_DATA_DIR/todo/active.md`

**Errors:** No config → run bootstrap | Task not found → show list | Ambiguous → ask clarification
