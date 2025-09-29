#!/bin/bash
#
# Auto-Save Script for Claude Code CEO Global Memory
# Automatically commits and pushes changes to GitHub every 2 minutes
#

MEMORY_DIR="$HOME/.claude/global_memory"
LOG_FILE="/tmp/auto_save.log"
INTERVAL=120  # 2 minutes in seconds

echo "🚀 Starting Auto-Save Service (every 2 minutes)" | tee -a "$LOG_FILE"
echo "📁 Monitoring: $MEMORY_DIR" | tee -a "$LOG_FILE"
echo "📊 Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Function to perform auto-save
auto_save() {
    cd "$MEMORY_DIR" || exit 1

    # Check if there are changes
    if [[ -n $(git status --porcelain) ]]; then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$TIMESTAMP] 💾 Changes detected - Auto-saving..." | tee -a "$LOG_FILE"

        # Add all changes
        git add -A

        # Create commit with timestamp
        COMMIT_MSG="Auto-save: $(date '+%Y-%m-%d %H:%M:%S')

Changes:
$(git status --short)

🤖 Automated backup by Claude Code CEO
Co-Authored-By: Claude <noreply@anthropic.com>"

        git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1

        # Push to GitHub
        if git push origin main >> "$LOG_FILE" 2>&1; then
            echo "[$TIMESTAMP] ✅ Auto-save completed successfully" | tee -a "$LOG_FILE"
        else
            echo "[$TIMESTAMP] ❌ Push failed - will retry next cycle" | tee -a "$LOG_FILE"
        fi
    else
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$TIMESTAMP] ℹ️  No changes to save" | tee -a "$LOG_FILE"
    fi
}

# Main loop
while true; do
    auto_save
    sleep $INTERVAL
done