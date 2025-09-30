#!/bin/bash
# GitHub sync script for Claude Code global memory
# Manages bidirectional sync between local and GitHub

MEMORY_DIR="$HOME/.claude/global_memory"
SCRIPT_DIR="$MEMORY_DIR/sync_scripts"
LOG_FILE="$SCRIPT_DIR/github_sync.log"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to log with timestamp
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Change to global memory directory
cd "$MEMORY_DIR" || exit 1

# Function: Pull latest changes from GitHub
pull_from_github() {
    log "${BLUE}📥 Pulling latest changes from GitHub...${NC}"

    git fetch origin main >> "$LOG_FILE" 2>&1

    # Check if there are remote changes
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ "$LOCAL" = "$REMOTE" ]; then
        log "${GREEN}✅ Already up to date${NC}"
        return 0
    else
        log "${YELLOW}⬇️  Remote changes detected, pulling...${NC}"
        git pull origin main >> "$LOG_FILE" 2>&1

        if [ $? -eq 0 ]; then
            log "${GREEN}✅ Pulled successfully${NC}"
            return 0
        else
            log "${RED}❌ Failed to pull${NC}"
            return 1
        fi
    fi
}

# Function: Push local changes to GitHub
push_to_github() {
    log "${BLUE}📤 Pushing local changes to GitHub...${NC}"

    # Check if there are local changes
    if [[ -z $(git status --porcelain) ]]; then
        log "${GREEN}✅ No local changes to push${NC}"
        return 0
    fi

    # Add all changes
    git add .

    # Get list of changed files
    CHANGED_FILES=$(git diff --cached --name-only | wc -l | tr -d ' ')

    # Create commit message
    COMMIT_MSG="🔄 Auto-sync: $CHANGED_FILES file(s) updated

Auto-synced by Claude Code global memory system
$(date '+%Y-%m-%d %H:%M:%S')

Changed files:
$(git diff --cached --name-only | head -10)
"

    # Commit
    git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        log "${GREEN}✅ Committed locally${NC}"

        # Push
        git push origin main >> "$LOG_FILE" 2>&1

        if [ $? -eq 0 ]; then
            log "${GREEN}✅ Pushed to GitHub successfully${NC}"
            return 0
        else
            log "${RED}❌ Failed to push to GitHub${NC}"
            return 1
        fi
    else
        log "${YELLOW}⚠️  Nothing to commit${NC}"
        return 0
    fi
}

# Function: Full bidirectional sync
full_sync() {
    log "${BLUE}🔄 Starting full bidirectional sync...${NC}"

    # First pull to get latest changes
    pull_from_github

    # Then push local changes
    push_to_github

    log "${GREEN}✅ Full sync completed${NC}"
}

# Function: Show status
show_status() {
    log "${BLUE}📊 Git Status:${NC}"
    git status --short

    log "\n${BLUE}📝 Recent commits (local):${NC}"
    git log --oneline --graph -5

    log "\n${BLUE}🌐 Remote status:${NC}"
    git remote -v
}

# Main script logic
case "$1" in
    pull)
        pull_from_github
        ;;
    push)
        push_to_github
        ;;
    sync)
        full_sync
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 {pull|push|sync|status}"
        echo ""
        echo "Commands:"
        echo "  pull   - Pull latest changes from GitHub"
        echo "  push   - Push local changes to GitHub"
        echo "  sync   - Full bidirectional sync (pull then push)"
        echo "  status - Show current Git status"
        exit 1
        ;;
esac
