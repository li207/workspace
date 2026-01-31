#!/bin/bash
# Sync both framework and data repos

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"

echo "📁 Syncing workspace..."

# Sync framework repo
cd "$WORKSPACE_DIR"
if [ -d ".git" ]; then
    echo "→ Framework repo"
    git add -A
    git diff --cached --quiet || git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
    git push 2>/dev/null || echo "  (no remote or push failed)"
else
    echo "  ⚠️ Framework repo not initialized"
fi

# Sync workspace-data repo
if [ -d "$WORKSPACE_DIR/workspace-data/.git" ]; then
    echo "→ Workplace-data repo"
    cd "$WORKSPACE_DIR/workspace-data"
    git add -A
    git diff --cached --quiet || git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
    git push 2>/dev/null || echo "  (no remote or push failed)"
else
    echo "  ⚠️ Workplace-data repo not initialized"
fi

echo "✅ Done"
