---
title: Visual Dashboard
description: Real-time workspace visualization and monitoring
user-invocable: true
args:
  - name: command
    description: Visual command (start, stop, status, open)
    type: string
    required: false
---

You are managing workspace visualization using the Visual module with natural language processing.

## User Command: {{command}}

## Core Tasks:

1. **Load Configuration**: Read workspace paths from `~/.claude/workspace-path.txt`
2. **Parse Intent**: Analyze command for: start, stop, status, open, default
3. **Execute**: Perform operation and provide clear feedback

## Intent Patterns:
- **Start**: "start", "begin", "launch", "run" → Start visualization server
- **Stop**: "stop", "end", "kill", "shutdown" → Stop visualization server  
- **Status**: "status", "check", "info" → Show server status
- **Open**: "open", "view", "show", "browser" → Open dashboard in browser
- **Default**: No args or "visual" → Quick start + open browser

## Operations:

### START
- Check if server running on port 3000
- Install dependencies if needed: `cd WORKSPACE_DIR/modules/visual && npm install`
- Start server: `node server.js --port 3000 --background`
- Show access URL and instructions

### STOP
- Find and kill server process: `pkill -f "node.*visual.*server.js"`
- Confirm shutdown

### STATUS
- Check port 3000 for running server
- Display process info, uptime, connections
- Show access URL if available

### OPEN
- Verify server running first
- Open browser: `open http://localhost:3000` (macOS)
- Show manual URL if browser fails

### DEFAULT
- Auto-start server if not running
- Open browser automatically
- Display dashboard URL

## Error Handling:
- No config → "Run bootstrap script first"
- Port conflict → Suggest different port or stop process
- Dependencies → Auto-install with progress
- Start failure → Show error and troubleshooting
- Browser failure → Show manual URL

## File Paths:
- Config: `~/.claude/workspace-path.txt`
- Server: `WORKSPACE_DIR/modules/visual/server.js`
- Dependencies: `WORKSPACE_DIR/modules/visual/package.json`

ARGUMENTS: {{command}}