#!/bin/bash
# Auto-commit script for Claude Code global memory
# This script automatically commits and pushes changes to GitHub

MEMORY_DIR="$HOME/.claude/global_memory"
SCRIPT_DIR="$MEMORY_DIR/sync_scripts"
LOG_FILE="$SCRIPT_DIR/auto_commit.log"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Change to global memory directory
cd "$MEMORY_DIR" || exit 1

# Check if there are changes
if [[ -z $(git status --porcelain) ]]; then
    log "${YELLOW}No changes to commit${NC}"
    exit 0
fi

# Add all changes
git add .

# Create commit message with timestamp and summary
CHANGED_FILES=$(git diff --cached --name-only | wc -l | tr -d ' ')
COMMIT_MSG="🤖 Auto-save: $CHANGED_FILES file(s) updated

Auto-committed by Claude Code global memory system
$(date '+%Y-%m-%d %H:%M:%S')

Changed files:
$(git diff --cached --name-only | head -10)
"

# Commit
git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    log "${GREEN}✅ Committed successfully${NC}"

    # Push to GitHub
    log "Pushing to GitHub..."
    git push origin main >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        log "${GREEN}✅ Pushed to GitHub successfully${NC}"
        exit 0
    else
        log "${RED}❌ Failed to push to GitHub${NC}"
        exit 1
    fi
else
    log "${RED}❌ Failed to commit${NC}"
    exit 1
fi
