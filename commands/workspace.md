---
title: Workspace Management
description: Manage isolated task workspaces using natural language commands
user-invocable: true
args:
  - name: command
    description: What you want to do (e.g., "create workspace for task 1769a4", "open", "list")
    type: string
    required: true
---

You are managing task workspaces using the Workspace system with natural language processing.

## User Command: {{command}}

## Your Task:

1. **Load Workspace Configuration**: 
   - Read workspace paths from `~/.claude/workspace-path.txt` which contains:
     - `WORKSPACE_DIR=<framework-path>`
     - `WORKSPACE_DATA_DIR=<data-path>`
   - If config file doesn't exist, inform user to run bootstrap script first
   - Use `WORKSPACE_DATA_DIR/workspace/` for all workspace operations

2. **Parse Natural Language Command**: 
   - Analyze the user's command to determine intent and extract information
   - Common intent patterns:
     - **Create**: "create", "make", "new", "setup" → Create new workspace for task
     - **Open/Switch**: "open", "switch", "work on", "access", "go to" → Switch to workspace
     - **TODO Integration**: "work on first todo", "let's work on the second todo" → Switch to workspace for specific TODO
     - **Status**: "report status", "where did I leave off", "what's next" → Show progress summary
     - **List**: "list", "show", "see", "view" → Display workspaces
     - **Clean**: "clean", "remove", "delete", "archive" → Clean up workspace
     - **Help**: "help", "manual", "guide" → Show help information

3. **Extract Workspace Information**:
   - **Task ID**: Extract from TODO ID format (6-char alphanumeric like "1769a4")
   - **TODO reference**: "first todo", "second task", "the auth bug" → Resolve from recent /todo list
   - **Task position**: "task 1", "first task", "second todo" → Position from TODO list
   - **Task description**: Partial matches against task titles
   - **Action context**: Additional details about what to do with the workspace

4. **Handle TODO Reference Resolution**:
   - For TODO-based references, read `WORKSPACE_DATA_DIR/todo/active.md` to resolve task IDs
   - For positional references ("first todo"), maintain context of recent `/todo list` results
   - If reference unclear, show active tasks and ask which
   - If multiple matches, ask for clarification

5. **Session Context Management**:
   - **Current Workspace Tracking**: Remember which workspace is currently active
   - **TODO List Context**: Cache recent TODO list for positional references
   - **Context Switching**: Update internal state when switching workspaces
   - **Auto-Update Target**: Know which PROGRESS.md file to update based on current workspace

6. **Execute Operation**:

   - **OPEN/SWITCH**: Switch to existing workspace or create if needed
     - Parse task reference (ID, position, or description)
     - Resolve to task ID using TODO list or active.md
     - If workspace doesn't exist, auto-create with TODO context
     - Read workspace CLAUDE.md to set auto-update rules
     - Set session context to this workspace
     - Show workspace switch confirmation with basic status

   - **STATUS/REPORT**: Show current workspace progress
     - Read PROGRESS.md from current workspace
     - Display formatted progress summary
     - Show recent accomplishments, next actions, blockers
     - If new workspace, show getting started guidance
     - Include task context and workspace information

   - **AUTO-CREATE**: Create workspace when switching to non-existent one
     - Read TODO details from active.md using task ID
     - Create directory: `WORKSPACE_DATA_DIR/workspace/{task-id}/`
     - Generate initial files from TODO context:
       - `CLAUDE.md` - Auto-update rules and workspace context
       - `PROGRESS.md` - Initial progress based on TODO
       - `README.md` - Workspace overview with task details
       - `docs/`, `logs/`, `scratch/` directories
     - Show workspace creation confirmation

   - **LIST**: Display all workspaces
     - Show workspace folders with task context
     - Include task title, priority, and workspace status
     - Sort by task priority, then creation date
     - Format: "1769a4: [P0] Fix critical auth bug (3 files, last updated: 2 days ago)"

   - **INFO**: Show workspace details
     - Display workspace folder structure
     - Show linked task information
     - List recent files and activity
     - Show disk usage

   - **CLEAN**: Clean up workspace
     - Archive completed task workspaces
     - Remove empty or unused workspaces
     - Ask for confirmation before deletion

   - **HELP**: Display natural language usage guide

7. **Workspace File Templates**:

   **CLAUDE.md Template:**
   ```markdown
   # Claude Context - Task {task-id}: {task-title}

   ## Workspace Instructions
   - **Auto-update PROGRESS.md** when these checkpoints occur:
     - Key findings: "I found...", "The issue is...", "Root cause..."
     - Solutions proposed: "The solution is...", "We should...", "I recommend..."
     - Decisions made: "Let's go with...", "We decided...", "The approach..."
     - Milestones: "Investigation complete", "Testing done", "Ready for..."
   - **Manual updates** on commands: "summarize", "let's remember this", "checkpoint"

   ## Current Workspace Context  
   - **Task ID:** {task-id}
   - **Progress File:** ./PROGRESS.md
   - **Active Since:** {timestamp}
   - **Current Phase:** Getting Started

   ## Workspace Structure
   - `docs/` - Documentation and specifications
   - `logs/` - Debug logs, error traces, investigation notes  
   - `scratch/` - Temporary files, experiments, drafts
   - `PROGRESS.md` - Auto-updated progress tracking

   ## Task Context
   {context from original TODO task}
   ```

   **PROGRESS.md Template:**
   ```markdown
   # Progress: {task-title}

   **Status:** Getting Started | **Last Updated:** {timestamp}
   **Next Session:** Begin investigation and analysis

   ## 🎯 Current Focus
   Starting work on: {task-title}

   ## ✅ Recent Accomplishments
   - Workspace created and initialized

   ## 🚧 Next Actions
   1. **Understand the problem** - Review task requirements and context
   2. **Plan approach** - Determine investigation or development strategy  
   3. **Begin work** - Start with first concrete step

   ## 🚫 Blockers & Questions
   _(None yet)_

   ## 💡 Key Insights
   _(To be updated as work progresses)_

   ## 📈 Progress Phases
   - [ ] Getting Started ← **You are here**
   - [ ] Investigation/Analysis
   - [ ] Solution Design
   - [ ] Implementation
   - [ ] Testing & Validation

   ## 📄 Task Details
   - **Priority:** {priority}
   - **Due:** {due-date}
   - **Tags:** {tags}  
   - **Created:** {created-date}
   - **Context:** {context}
   ```

8. **Auto-Update Logic**: 
   Based on workspace CLAUDE.md instructions, automatically update PROGRESS.md when detecting:
   - **Key findings**: Conversation contains "I found", "The issue is", "Root cause", "The problem is"
     → Update "Key Insights" section with finding
   - **Proposed solutions**: "The solution is", "We should", "I recommend", "Let's try", "The fix is"  
     → Add to "Next Actions" or create "Proposed Solutions" section
   - **Decisions made**: "Let's go with", "We decided", "The approach will be", "We'll use"
     → Update "Current Focus" and "Recent Accomplishments"
   - **Milestones reached**: "Investigation complete", "Testing done", "Ready for", "Phase complete"
     → Update progress phases and accomplishments
   - **Manual commands**: "summarize", "let's remember this", "checkpoint", "update progress"
     → Comprehensive update of entire PROGRESS.md

9. **Error Handling**: 
   - If no workspace configuration found: Inform user and suggest running bootstrap script
   - If task ID not found in active.md: Show current tasks and ask for clarification  
   - If TODO reference unclear: Display recent TODO list and ask which task
   - If workspace directory doesn't exist: Auto-create with TODO context
   - If PROGRESS.md doesn't exist: Create from template using TODO information
   - If command is ambiguous: Ask for clarification with specific options

## Special Case: Help Command

If the user asks for help, display this comprehensive manual:

---

# 📁 Workspace Natural Language Guide

An intelligent workspace management system for task-specific isolated environments.

## Quick Start
```bash
/workspace create workspace for task 1769a4
/workspace list
/workspace open 1769a4
/workspace info 1769a4
```

## Operations

### ✨ **Natural Language Commands**

#### 🆕 **Creating Workspaces**

**Natural ways to create workspaces:**
```bash
# By task ID
/workspace create workspace for task 1769a4
/workspace make new workspace for 1769a4
/workspace setup folder for task 1769a4

# By task reference
/workspace create workspace for first task
/workspace make folder for the auth bug
/workspace setup workspace for critical bug

# With specific purpose
/workspace create docs workspace for API task
/workspace setup debug environment for bug 1769a4
```

#### 📂 **Switching to Workspaces**

**Natural ways to switch to workspaces:**
```bash
# By task ID
/workspace open 1769a4
/workspace switch to 1769a4

# By TODO reference (integrates with /todo list)
/workspace work on first todo
/workspace let's work on the second todo  
/workspace switch to the auth bug

# By task description
/workspace work on the critical auth bug
/workspace switch to API documentation task

# Auto-creates workspace if it doesn't exist
```

#### 📊 **Progress & Status**

**Natural ways to check progress:**
```bash
# Current workspace status
/workspace report status
/workspace where did I leave off
/workspace what's next
/workspace show progress

# Update progress manually
/workspace summarize  
/workspace let's remember this
/workspace checkpoint
/workspace update progress
```

#### 📋 **Listing Workspaces**

**Natural ways to see workspaces:**
```bash
# List all workspaces
/workspace list
/workspace show all workspaces
/workspace what workspaces do I have

# Filter by status
/workspace show active workspaces
/workspace list workspaces for P0 tasks
```

#### 🧹 **Managing Workspaces**

**Natural ways to manage workspaces:**
```bash
# Clean up
/workspace clean completed workspaces
/workspace remove unused workspaces
/workspace archive old workspaces

# Get details
/workspace info 1769a4
/workspace status of auth bug workspace
/workspace details for first task workspace
```

## Enhanced Data Format

Workspaces are organized in `workspace-data/workspace/` with this structure:

```
workspace-data/workspace/
├── 1769a4/                    # Task ID folder
│   ├── README.md              # Workspace overview
│   ├── docs/                  # Documentation
│   │   ├── requirements.md
│   │   └── api-spec.md
│   ├── logs/                  # Investigation logs
│   │   ├── debug.log
│   │   └── error-traces.md
│   └── scratch/               # Temporary work
│       ├── notes.md
│       └── experiments/
└── 176984/                    # Another task workspace
    ├── README.md
    ├── docs/
    ├── logs/
    └── scratch/
```

## Integration with TODO System

Workspaces are automatically linked to their corresponding tasks:
- Workspace folder name matches task ID
- README.md includes task details and context
- Can reference workspace from task using folder path

## Common Workflows

**Bug Investigation:**
```bash
/workspace create debug workspace for bug 1769a4
# Creates folder with logs/ for error traces, docs/ for analysis
```

**Feature Development:**
```bash
/workspace setup dev environment for feature 176984  
# Creates folder with docs/ for specs, scratch/ for prototypes
```

**Research Task:**
```bash
/workspace make research folder for investigation task
# Creates folder with docs/ for findings, scratch/ for experiments
```

## Tips

- **Isolated Environments**: Each workspace is completely separate
- **Task Integration**: Workspaces automatically link to their TODO tasks  
- **Flexible Structure**: Add any files or folders you need within the workspace
- **Easy Navigation**: Use task IDs or descriptions to find workspaces
- **Automatic Cleanup**: Archive workspaces when tasks are completed

## File Locations
- **Workspaces:** `workspace-data/workspace/{task-id}/`
- **Task Integration:** Links to `workspace-data/todo/active.md`
- **Configuration:** `~/.claude/workspace-path.txt`

---

## Response Format:
- Be concise and action-oriented  
- Show the result of the operation clearly
- For folder operations, include the full path
- Include helpful next steps or suggestions