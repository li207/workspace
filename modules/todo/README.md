# TODO Module - Natural Language Task Management

An intelligent task management system that understands natural language commands.

## Overview

The TODO module provides a natural language interface for task management, with smart parsing of priorities, dates, and context. Tasks are stored in human-readable markdown files with rich metadata.

## Quick Start
```bash
/todo create bug fix task, high priority, due tomorrow
/todo list
/todo mark first task as done
/todo review
```

## Natural Language Commands

### ✨ Creating Tasks

**Natural ways to create tasks:**
```bash
# Basic task creation
/todo create bug fix task
/todo add meeting with client
/todo new task: update documentation

# With priority (natural language)
/todo create critical bug fix for auth system
/todo add important client meeting, p1 priority
/todo make new task to review code, p3 priority

# With due dates (flexible)
/todo create report task due tomorrow
/todo add client meeting, friday at 2pm
/todo new task: fix bug, due next monday
/todo create presentation, due feb 15
/todo add task due in 3 days: test deployment

# With context and details
/todo create API integration task, urgent, needs review from team lead and POC testing
/todo add client demo prep, include latest features and performance metrics
/todo new security audit task, reference OWASP guidelines and previous findings
```

### 📋 Viewing Tasks

**Natural ways to see tasks:**
```bash
/todo list
/todo show tasks
/todo see my tasks
/todo what's on my list?
/todo show me what I need to do
```

### ✅ Completing Tasks

**Natural ways to mark tasks done:**
```bash
# By task number (from list)
/todo mark task 1 as done
/todo complete the first task
/todo finish task 2

# By description
/todo mark the auth bug as complete
/todo done with quarterly report

# By ID
/todo complete abc123
/todo done def456
```

### ✏️ Updating Tasks

**Natural ways to modify tasks:**
```bash
# Change priority
/todo make first task p1 priority
/todo change task 2 to p3 priority
/todo urgent: make auth bug task p0 priority

# Change due dates
/todo change first task due date to next monday
/todo move task 2 deadline to friday
/todo extend grocery task to next week
```

### 📊 Reviewing Tasks

**Natural ways to get overview:**
```bash
/todo review
/todo status
/todo summary
/todo what's my current workload?
/todo what's overdue?
/todo show upcoming deadlines
/todo what's due this week?
```

## Priority Levels
- **p0** - Critical, urgent tasks (highest priority)
- **p1** - High priority tasks
- **p2** - Medium priority tasks (default)
- **p3** - Low priority, nice-to-have tasks

## Enhanced Data Format

Tasks are stored with clean titles and detailed context:

```markdown
- [ ] Fix authentication bug #id:abc123
  - priority: p1
  - created: 2026-01-31
  - due: 2026-02-02
  - tags: [security, backend]
  - context: Requires database migration script, coordinate with DevOps team
```

**Completed tasks** are moved to `archive/YYYY-MM-DD.md`:

```markdown
- [x] Fix authentication bug #id:abc123
  - priority: p1
  - created: 2026-01-31
  - due: 2026-02-02
  - completed: 2026-02-01
  - tags: [security, backend]
  - context: Database migration completed successfully, rollback tested in staging
```

## Daily Workflow

1. **Morning:** `/todo review` - See what needs attention
2. **Add tasks:** `/todo add "task"` - Capture new work
3. **Stay focused:** `/todo list` - See active tasks
4. **Complete work:** `/todo done "id"` - Archive finished tasks

## File Organization

| File | Purpose |
|------|---------|
| `active.md` | Tasks currently being worked on |
| `archive/YYYY-MM-DD.md` | Completed tasks, organized by completion date |

## Data Format

### Active Task
```markdown
- [ ] Write comprehensive project proposal #id:a1b2c3
  - priority: p1
  - created: 2026-01-30
  - due: 2026-02-15
  - tags: [work, writing]
  - context: Include budget breakdown, timeline, resource requirements. Reference previous proposals in /docs/proposals. Need approval from PM and stakeholders.
```

### Completed Task
```markdown
- [x] Review pull request #id:d4e5f6
  - priority: p2
  - created: 2026-01-28
  - due: 2026-01-30
  - completed: 2026-01-29
  - tags: [code]
  - context: Focused on security improvements and performance optimizations. All tests passing.
```

## Fields

| Field | Required | Description |
|-------|----------|-------------|
| `#id:` | Yes | Unique 6-char random identifier (in task title) |
| `priority` | No | `p0`, `p1`, `p2`, `p3` (default: p2) |
| `created` | Yes | Creation date in YYYY-MM-DD format |
| `due` | No | Due date in YYYY-MM-DD format |
| `completed` | On completion | Completion date |
| `tags` | No | Array of tags for categorization |
| `context` | No | Additional details, requirements, links, notes |

## Operations

### Add Task
Create a new task using natural language.

**Natural Language Usage:**
- Use simple, conversational commands
- System automatically extracts priority, due dates, and context
- Task titles are cleaned and organized for clarity

**Examples:**
```bash
# Basic task creation
todo create bug fix task
todo add meeting with client
todo new task: update documentation

# With natural priority
todo create critical security fix for login system
todo add important client presentation, p1 priority  
todo make p3 priority task to organize files

# With flexible due dates
todo create report task due tomorrow
todo add client meeting this friday
todo new bug fix due next monday
todo add presentation task, due feb 15th

# With rich context
todo create API integration task, urgent, needs database migration and team review
todo add client demo preparation, include performance metrics and new features overview
todo new security audit, reference OWASP guidelines and document findings in /docs/security

# Complex natural language
todo create authentication system overhaul, critical priority, due end of sprint, requires coordination with DevOps team and security review
```

**What gets organized:**
- **Title**: "create authentication system overhaul" → "Overhaul authentication system"
- **Priority**: "critical", "urgent" → p0; "important" → p1; "low priority" → p3  
- **Due dates**: "tomorrow", "friday", "feb 15th", "end of sprint" → parsed dates
- **Context**: Everything after commas gets extracted to context field
- **Tags**: Auto-detected from context (security, api, etc.)

### List Tasks
Display all active tasks.

**Usage:** `todo list`

**Output format:**
```
## Active Tasks (3 tasks)

1. [P1] Submit quarterly report #id:a1b2c3
2. [P2] Buy groceries for the week #id:d4e5f6
3. [P2] Call dentist to schedule checkup #id:g7h8i9
```

### Complete Task
Mark a task as done and move to archive.

**Usage:** `todo done "<description or id>"`

**Examples:**
```
todo done "a1b2c3"
todo done "Buy groceries"
```

### Review
Show summary of active tasks.

**Usage:** `todo review`

**Output:**
```
## Task Summary
- Total active tasks: 3
- P0 priority: 0
- P1 priority: 1
- P2 priority: 2
- P3 priority: 0

## Oldest Tasks (need attention)
1. [P1] Submit quarterly report (created: 5 days ago) #id:a1b2c3
```

### Help
Display comprehensive command manual with examples.

**Usage:** `todo help`

**Shows:**
- All available operations with examples
- Data format specifications
- Daily workflow tips
- File locations and configuration details

## Daily Workflow

1. **Morning:** Run `todo review` to see active task summary
2. **During day:** Add tasks with `todo add`, complete with `todo done`
3. **Focus:** Work on active tasks, keeping the list manageable

## Archiving

When a task is completed:
1. Add `completed: YYYY-MM-DD` field
2. Change `- [ ]` to `- [x]`
3. Move to `archive/YYYY-MM-DD.md` (based on completion date)
4. Remove from `active.md`
