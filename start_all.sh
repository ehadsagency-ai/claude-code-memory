#!/bin/bash
#
# Start All Services - Dashboard + Auto-Save
# Launch the complete Claude Code CEO environment
#

MEMORY_DIR="$HOME/.claude/global_memory"

echo "🚀 Starting Claude Code CEO Services..."
echo ""

# Check if auto-save is already running
if pgrep -f "auto_save.sh" > /dev/null; then
    echo "✅ Auto-save already running (PID: $(pgrep -f 'auto_save.sh'))"
else
    echo "📦 Starting Auto-Save service (every 2 minutes)..."
    nohup "$MEMORY_DIR/sync_scripts/auto_save.sh" > /tmp/auto_save.log 2>&1 &
    AUTO_SAVE_PID=$!
    echo "✅ Auto-save started (PID: $AUTO_SAVE_PID)"
fi

echo ""

# Check if dashboard is already running
if lsof -ti:3000 > /dev/null; then
    echo "✅ Dashboard already running on port 3000 (PID: $(lsof -ti:3000))"
else
    echo "🌐 Starting Dashboard on http://localhost:3000..."
    cd "$MEMORY_DIR/ui" || exit 1

    # Activate venv and start Flask
    source venv/bin/activate
    nohup python server.py > /tmp/dashboard.log 2>&1 &
    DASHBOARD_PID=$!
    sleep 2

    if lsof -ti:3000 > /dev/null; then
        echo "✅ Dashboard started (PID: $(lsof -ti:3000))"
    else
        echo "❌ Dashboard failed to start - check /tmp/dashboard.log"
        exit 1
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Claude Code CEO Services Running!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Dashboard:  http://localhost:3000"
echo "💾 Auto-save:  Every 2 minutes to GitHub"
echo "📝 Logs:"
echo "   - Dashboard: /tmp/dashboard.log"
echo "   - Auto-save: /tmp/auto_save.log"
echo ""
echo "🛑 To stop services:"
echo "   pkill -f 'auto_save.sh'"
echo "   pkill -f 'python.*server.py'"
echo ""
echo "👀 Monitor logs:"
echo "   tail -f /tmp/auto_save.log"
echo "   tail -f /tmp/dashboard.log"
echo ""