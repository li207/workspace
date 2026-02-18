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
    echo "→ Workspace-data repo"
    cd "$WORKSPACE_DIR/workspace-data"
    git add -A
    git diff --cached --quiet || git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
    git push 2>/dev/null || echo "  (no remote or push failed)"
else
    echo "  ⚠️ Workspace-data repo not initialized"
fi

# Sync wiki-data repo (if git is configured)
WIKI_DIR=""
if [ -f "$HOME/.claude/workspace-path.txt" ]; then
    WIKI_DIR=$(grep '^WIKI_DIR=' "$HOME/.claude/workspace-path.txt" | cut -d= -f2-)
fi
if [ -n "$WIKI_DIR" ] && [ -d "$WIKI_DIR/.git" ]; then
    echo "→ Wiki repo"
    cd "$WIKI_DIR"
    git add -A
    git diff --cached --quiet || git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
    git push 2>/dev/null || echo "  (no remote or push failed)"
else
    echo "  ℹ️  Wiki repo not git-initialized (skipping sync)"
fi

echo "✅ Done"
