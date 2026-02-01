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

You are managing task workspaces using the Workspace system with natural language processing.

## User Command: {{command}}

## Core Tasks:

1. **Load Configuration**: Read workspace paths from `~/.claude/workspace-path.txt`
2. **Parse Intent**: Analyze command for: create, open, status, list, clean, help
3. **Extract Info**: Task ID, TODO reference, workspace reference, action context
4. **Execute**: Perform operation and respond clearly

## Intent Patterns:
- **Create**: "create", "make", "new", "setup" + workspace description
- **Open/Switch**: "open", "switch", "work on", "access", "go to" + reference
- **Status**: "status", "report", "where did I leave off", "what's next"
- **List**: "list", "show", "see", "view" + optional filters
- **Clean**: "clean", "remove", "delete", "archive" + scope
- **Help**: "help", "manual", "guide"

## Operations:

### CREATE
- Parse task reference (ID, position, description)
- Create directory: `WORKSPACE_DATA_DIR/workspace/{task-id}/`
- Generate files: README.md, CLAUDE.md, PROGRESS.md, docs/, logs/, scratch/
- Link to TODO task if ID provided

### OPEN/SWITCH  
- Parse task reference to resolve task ID
- Switch to existing workspace or auto-create if needed
- Read CLAUDE.md for workspace context
- Show workspace status confirmation

### STATUS/REPORT
- Read PROGRESS.md from current/specified workspace
- Display progress summary, accomplishments, next actions, blockers
- Include task context and workspace information

### LIST
- Show all workspace directories with task context
- Include task title, priority, workspace status, file counts
- Sort by task priority, then creation date

### CLEAN
- Archive completed task workspaces
- Remove empty/unused workspaces
- Ask confirmation before deletion

### HELP
Load full help: Use Task tool to read `modules/workspace/README.md`

## Workspace Templates:

### CLAUDE.md
```markdown
# Claude Context - Task {id}: {title}
## Current Workspace Context
- Task ID: {id}
- Progress File: ./PROGRESS.md
- Active Since: {timestamp}
## Task Context
{context from TODO}
```

### PROGRESS.md
```markdown
# Progress: {title}
**Status:** Getting Started
## 🎯 Current Focus
Starting work on: {title}
## ✅ Recent Accomplishments  
- Workspace created and initialized
## 🚧 Next Actions
1. Understand the problem
2. Plan approach
3. Begin work
```

## Error Handling:
- No config → "Run bootstrap script first"
- Task not found → Show current tasks for clarification
- Workspace not found → Auto-create with TODO context
- Ambiguous reference → Ask for clarification

## File Paths:
- Config: `~/.claude/workspace-path.txt`
- Workspaces: `WORKSPACE_DATA_DIR/workspace/{task-id}/`
- TODO Integration: `WORKSPACE_DATA_DIR/todo/active.md`

ARGUMENTS: {{command}}