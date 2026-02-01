# Workspace Natural Language Examples

## Creating Workspaces

### By Task ID
```bash
/workspace create workspace for task 1769a4
/workspace make new workspace for 1769a4  
/workspace setup folder for task 1769a4
```

### By Task Reference
```bash
/workspace create workspace for first task
/workspace make folder for the auth bug
/workspace setup workspace for critical bug
```

### With Specific Purpose
```bash
/workspace create docs workspace for API task
/workspace setup debug environment for bug 1769a4
/workspace make research folder for investigation
```

## Switching to Workspaces

### By Task ID
```bash
/workspace open 1769a4
/workspace switch to 1769a4
/workspace access 1769a4
```

### By TODO Reference
```bash
/workspace work on first todo
/workspace let's work on the second todo
/workspace switch to the auth bug
```

### By Task Description  
```bash
/workspace work on the critical auth bug
/workspace switch to API documentation task
/workspace access the security audit workspace
```

## Progress & Status

### Status Checking
```bash
/workspace report status
/workspace where did I leave off
/workspace what's next
/workspace show progress
```

### Manual Updates
```bash
/workspace summarize
/workspace let's remember this
/workspace checkpoint
/workspace update progress
```

## Listing Workspaces

### Basic Listing
```bash
/workspace list
/workspace show all workspaces
/workspace what workspaces do I have
```

### Filtered Views
```bash
/workspace show active workspaces
/workspace list workspaces for P0 tasks
/workspace display recent workspaces
```

## Managing Workspaces

### Cleanup Operations
```bash
/workspace clean completed workspaces
/workspace remove unused workspaces
/workspace archive old workspaces
```

### Information Queries
```bash
/workspace info 1769a4
/workspace status of auth bug workspace
/workspace details for first task workspace
```

## Common Workflows

### Bug Investigation
```bash
/workspace create debug workspace for bug 1769a4
# Auto-creates: logs/ for error traces, docs/ for analysis
```

### Feature Development
```bash
/workspace setup dev environment for feature 176984
# Auto-creates: docs/ for specs, scratch/ for prototypes
```

### Research Task
```bash
/workspace make research folder for investigation task
# Auto-creates: docs/ for findings, scratch/ for experiments
```