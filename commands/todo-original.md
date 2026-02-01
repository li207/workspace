---
title: TODO Management
description: Manage tasks using natural language commands
user-invocable: true
args:
  - name: command
    description: What you want to do (e.g., "create task", "list", "mark done")
    type: string
    required: true
---

You are managing tasks using the Workspace TODO system with natural language processing.

## User Command: {{command}}

## Your Task:

1. **Load Workspace Configuration**: 
   - Read workspace paths from `~/.claude/workspace-path.txt` which contains:
     - `WORKSPACE_DIR=<framework-path>`
     - `WORKSPACE_DATA_DIR=<data-path>`
   - If config file doesn't exist, inform user to run bootstrap script first
   - Use `WORKSPACE_DATA_DIR/todo/` for all TODO operations

2. **Parse Natural Language Command**: 
   - Analyze the user's command to determine intent and extract information
   - Common intent patterns:
     - **Create/Add**: "create", "add", "new", "make" → Create new task
     - **List/Show**: "list", "show", "view", "see" → Display tasks  
     - **Complete**: "done", "complete", "finish", "mark as done" → Mark task complete
     - **Update**: "change", "update", "modify", "edit" → Modify existing task
     - **Review**: "review", "summary", "status" → Show task overview
     - **Help**: "help", "manual", "guide" → Show help information

3. **Extract Task Information**:
   - **Task description**: Clean, organized, actionable title
   - **Priority**: p0/urgent/critical, p1/high, p2/medium/normal, p3/low/minor
   - **Due date**: tomorrow, friday, "feb 15", "2026-02-15", "in 3 days", "next monday"
   - **Tags**: work, personal, health, code, etc.
   - **Context**: Additional details, links, requirements, POCs

4. **Handle Ambiguity**:
   - If multiple interpretations possible, ask for clarification
   - If date is ambiguous ("friday" - this week or next?), ask which
   - If task reference unclear ("first task" but multiple high-priority), ask which
   - Show what you understood and confirm before proceeding

5. **Execute Operation**:

   - **CREATE**: Add new task to `active.md`
     - Generate unique 6-character random ID
     - Organize title for clarity and actionability
     - Extract context for separate field
     - Parse priority, due date, tags from natural language
     - Format: `- [ ] <clean-title> #id:<random-id>`
     - Include: priority, created, due (if specified), tags (if specified), context (if provided)
   
   - **LIST**: Display numbered active tasks from `active.md`
     - Number tasks: "1. Fix authentication bug #abc123"
     - Sort: overdue first (⚠️), then by due date, then priority, then creation date
     - Show: task number, priority indicator, title, due date, ID
     - Format: "1. ⚠️ [P0] Submit quarterly report (due: 3 days ago) #abc123"
   
   - **COMPLETE**: Mark task as done
     - Parse task reference: "first task", "task 2", "the auth bug", or ID
     - If ambiguous reference, show options and ask for clarification
     - Mark complete and move to archive with completion date
   
   - **UPDATE**: Modify existing task
     - Parse what to change: priority, due date, title, context, tags
     - Parse which task: by number, description, or ID
     - Update the specified fields
   
   - **REVIEW**: Show task summary
     - Total tasks by priority
     - Overdue tasks (⚠️)
     - Due this week
     - Oldest tasks without due dates
   
   - **HELP**: Display natural language usage guide

6. **Data Format**: Use the enhanced Workspace TODO format with context:
   ```markdown
   - [ ] Clean, actionable task title #id:abc123
     - priority: p2
     - created: 2026-01-31
     - due: 2026-02-15
     - tags: [work, urgent]
     - context: Additional requirements, links to docs, POC details, technical notes
   ```

7. **Error Handling**: 
   - If no workspace found: Inform user and suggest running bootstrap script
   - If task not found: Show numbered task list to help user identify the right one
   - If command is ambiguous: Ask for clarification with specific options
   - If date is unclear: Ask which specific date is meant
   - If no active tasks: Suggest creating a new task

## Special Case: Help Command

If the user asks for help, display this comprehensive manual:

---

# 📋 TODO Natural Language Guide

An intelligent task management system that understands natural language commands.

## Quick Start
```bash
/todo create bug fix task, high priority, due tomorrow
/todo list
/todo mark first task as done
/todo review
```

## Operations

### ✨ **Natural Language Commands**

#### 🆕 **Creating Tasks**

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

# Everything combined
/todo create authentication bug fix, p1 priority, due tomorrow, needs database migration script and rollback plan
```

**What gets extracted:**
- **Title**: Clean, actionable task name
- **Priority**: p0/critical, p1/high, p2/medium, p3/low
- **Due date**: Smart parsing of dates and times
- **Tags**: Automatically detected (work, personal, etc.)
- **Context**: Additional details, requirements, links

#### 📋 **Viewing Tasks**

**Natural ways to see tasks:**
```bash
# List all tasks
/todo list
/todo show tasks
/todo see my tasks

# Quick status
/todo what's on my list?
/todo show me what I need to do
```

**Example Output:**
```
## Active Tasks (4 tasks)

1. ⚠️ [P0] Submit quarterly report (due: 3 days ago) #abc123 [OVERDUE]
2. [P1] Fix authentication bug (due: tomorrow) #def456
3. [P2] Review code for security issues (due: Feb 10) #ghi789  
4. [P2] Buy groceries for the week #jkl012
```

#### ✅ **Completing Tasks**

**Natural ways to mark tasks done:**
```bash
# By task number (from list)
/todo mark task 1 as done
/todo complete the first task
/todo finish task 2
/todo done with #3

# By description
/todo mark the auth bug as complete
/todo done with quarterly report
/todo finished the grocery shopping

# By ID
/todo complete abc123
/todo done def456
```

#### ✏️ **Updating Tasks**

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

# Update details
/todo add context to task 1: needs approval from manager
/todo update auth bug task, add note about database migration
```

#### 📊 **Reviewing Tasks**

**Natural ways to get overview:**
```bash
# Task summary
/todo review
/todo status
/todo summary
/todo what's my current workload?

# Check deadlines
/todo what's overdue?
/todo show upcoming deadlines
/todo what's due this week?
```

**Example Output:**
```
## Task Summary
- Total active tasks: 4
- P0 priority: 1  
- P1 priority: 1
- P2 priority: 2
- P3 priority: 0

⚠️  ## OVERDUE (1 task)
1. [P0] Submit quarterly report (due: 3 days ago) #abc123

## Due This Week (2 tasks)  
2. [P1] Fix authentication bug (due: tomorrow) #def456
3. [P2] Review code (due: Feb 10) #ghi789

## No Due Date (1 task)
4. [P2] Buy groceries (created: 5 days ago) #jkl012
```

## Enhanced Data Format

Tasks are stored with clean titles and detailed context in `workspace-data/todo/active.md`:

```markdown
- [ ] Fix authentication bug #id:abc123
  - priority: p1
  - created: 2026-01-31
  - due: 2026-02-02
  - tags: [security, backend]
  - context: Requires database migration script, coordinate with DevOps team, test rollback procedure, reference security audit findings in /docs/security-review.md

- [ ] Update API documentation #id:def456
  - priority: p2
  - created: 2026-01-31
  - tags: [documentation, api]
  - context: Include new authentication endpoints, update rate limiting info, add examples for webhook integration
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

## Priority Levels
- **p0** - Critical, urgent tasks (highest priority)
- **p1** - High priority tasks 
- **p2** - Medium priority tasks (default)
- **p3** - Low priority, nice-to-have tasks

## Daily Workflow

1. **Morning:** `/todo review` - See what needs attention
2. **Add tasks:** `/todo add "task"` - Capture new work  
3. **Stay focused:** `/todo list` - See active tasks
4. **Complete work:** `/todo done "id"` - Archive finished tasks

## Tips

- **Task IDs:** Use the 6-character ID for precise task management
- **Organized descriptions:** The system cleans up your task descriptions automatically
- **Tags:** Use tags to categorize tasks (e.g., work, personal, health)
- **Keep it active:** Focus on tasks you're actually working on
- **Archive regularly:** Complete tasks to keep your active list manageable

## File Locations
- **Active tasks:** `workspace-data/todo/active.md`
- **Completed tasks:** `workspace-data/todo/archive/YYYY-MM-DD.md`
- **Configuration:** `~/.claude/workspace-path.txt`

---

For more details, see the module documentation at `modules/todo/README.md`.

---

## Response Format:
- Be concise and action-oriented  
- Show the result of the operation clearly
- For list operations, use clean markdown formatting
- Include helpful context like task counts or next steps