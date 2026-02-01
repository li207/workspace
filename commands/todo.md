---
title: TODO Management
description: Natural language task management system
user-invocable: true
args:
  - name: command
    description: Natural language task command
    type: string
    required: false
---

You are managing tasks using the Workspace TODO system with natural language processing.

## User Command: {{command}}

## Core Tasks:

1. **Load Configuration**: Read workspace paths from `~/.claude/workspace-path.txt`
2. **Parse Intent**: Analyze command for: create, list, complete, update, review, help
3. **Extract Data**: Parse task info, priorities (p0-p3), dates, tags, context
4. **Execute**: Perform operation and respond clearly

## Intent Patterns:
- **Create**: "create", "add", "new", "make" + task description
- **List**: "list", "show", "view", "see" + optional filters
- **Complete**: "done", "complete", "finish", "mark" + task reference
- **Update**: "change", "update", "modify", "edit" + task + changes
- **Review**: "review", "summary", "status", "workload"
- **Help**: "help", "manual", "guide", "how"

## Operations:

### CREATE
- Generate 6-char random ID
- Parse: priority (p0/urgent→p0, p1/high→p1, p2/medium→p2, p3/low→p3)
- Parse: dates (tomorrow, friday, "feb 15", "in 3 days")
- Parse: context (everything after main task description)
- Format: `- [ ] <title> #id:<id>` with metadata

### LIST  
- Read `active.md`, sort by overdue → due date → priority → created
- Number tasks, show: priority, title, due date, ID
- Format: "1. [P1] Task title (due: date) #id"

### COMPLETE
- Parse task reference: number, description, or ID
- Move from active.md to archive/YYYY-MM-DD.md with completion date
- Add completion context if task was significant
- **Archive workspace integration**: If workspace exists for task ID, move it to archive
  - Check: `WORKSPACE_DATA_DIR/workspace/{task-id}/`
  - Move to: `WORKSPACE_DATA_DIR/workspace/archive/{task-id}/`
  - Preserve all files and update PROGRESS.md with completion status

### UPDATE
- Parse what to change: priority, due, title, context, tags
- Update specified fields in active.md

### REVIEW
- Count by priority, show overdue, due this week, no dates
- Alert on overdue tasks

### HELP
Load full help: Use Task tool to read `modules/todo/README.md`

## Data Format:
```markdown
- [ ] Task title #id:abc123
  - priority: p2
  - created: YYYY-MM-DD  
  - due: YYYY-MM-DD (if specified)
  - tags: [tag1, tag2] (if specified)
  - context: Additional details (if provided)
```

## Error Handling:
- No config → "Run bootstrap script first"
- No task found → Show numbered list for clarification  
- Ambiguous reference → Ask which task
- No active tasks → Suggest creating one

## File Paths:
- Config: `~/.claude/workspace-path.txt`
- Active: `WORKSPACE_DATA_DIR/todo/active.md`
- Archive: `WORKSPACE_DATA_DIR/todo/archive/YYYY-MM-DD.md`
- Workspace active: `WORKSPACE_DATA_DIR/workspace/{task-id}/`
- Workspace archive: `WORKSPACE_DATA_DIR/workspace/archive/{task-id}/`

ARGUMENTS: {{command}}