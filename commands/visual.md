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

Manage visualization server. Config: `~/.claude/workspace-path.txt` → WORKSPACE_DIR

## Command: {{command}}

**Intents:** start/launch | stop/kill | status/check | open/view | (default: start + open)

## Operations

**START** → Check port 3000, install deps if needed (`cd WORKSPACE_DIR/modules/visual && npm install`), run `node server.js --port 3000 --background`

**STOP** → `pkill -f "node.*visual.*server.js"`

**STATUS** → Check port 3000, show process info and URL

**OPEN** → Verify server running, `open http://localhost:3000`

**DEFAULT** → Auto-start if needed, open browser, show URL

## Paths
- Server: `WORKSPACE_DIR/modules/visual/server.js`

**Errors:** No config → run bootstrap | Port conflict → suggest stop | Browser fail → show manual URL
