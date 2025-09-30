#!/bin/bash
# Install cron job for automatic GitHub sync

SCRIPT_DIR="$HOME/.claude/global_memory/sync_scripts"
SYNC_SCRIPT="$SCRIPT_DIR/github_sync.sh"
CRON_LOG="$SCRIPT_DIR/cron.log"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔧 Installing Claude Code Auto-Sync Cron Job${NC}"
echo ""

# Check if sync script exists
if [ ! -f "$SYNC_SCRIPT" ]; then
    echo -e "${RED}❌ Sync script not found: $SYNC_SCRIPT${NC}"
    exit 1
fi

# Create cron job entry
CRON_ENTRY="0 * * * * $SYNC_SCRIPT sync >> $CRON_LOG 2>&1"

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "claude.*global_memory"; then
    echo -e "${YELLOW}⚠️  Cron job already exists${NC}"
    echo "Current cron jobs:"
    crontab -l | grep claude
    echo ""
    read -p "Replace existing cron job? (y/n) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled${NC}"
        exit 0
    fi
    
    # Remove old cron job
    crontab -l | grep -v "claude.*global_memory" | crontab -
fi

# Add new cron job
(crontab -l 2>/dev/null; echo "# Claude Code Global Memory - Auto-sync every hour"; echo "$CRON_ENTRY") | crontab -

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Cron job installed successfully${NC}"
    echo ""
    echo "Configuration:"
    echo "  - Frequency: Every hour (at minute 0)"
    echo "  - Script: $SYNC_SCRIPT sync"
    echo "  - Log: $CRON_LOG"
    echo ""
    echo "Current crontab:"
    crontab -l | grep -A 1 "Claude Code"
    echo ""
    echo -e "${GREEN}✅ Auto-sync is now active!${NC}"
else
    echo -e "${RED}❌ Failed to install cron job${NC}"
    exit 1
fi
