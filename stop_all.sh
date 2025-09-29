#!/bin/bash
#
# Stop All Services - Dashboard + Auto-Save
# Cleanly shutdown the Claude Code CEO environment
#

echo "🛑 Stopping Claude Code CEO Services..."
echo ""

# Stop auto-save
if pgrep -f "auto_save.sh" > /dev/null; then
    echo "📦 Stopping Auto-Save service..."
    pkill -f "auto_save.sh"
    echo "✅ Auto-save stopped"
else
    echo "ℹ️  Auto-save not running"
fi

echo ""

# Stop dashboard
if lsof -ti:3000 > /dev/null; then
    echo "🌐 Stopping Dashboard..."
    pkill -f "python.*server.py"
    sleep 1
    if ! lsof -ti:3000 > /dev/null; then
        echo "✅ Dashboard stopped"
    else
        echo "⚠️  Force killing dashboard..."
        kill -9 $(lsof -ti:3000)
        echo "✅ Dashboard force stopped"
    fi
else
    echo "ℹ️  Dashboard not running"
fi

echo ""
echo "✅ All services stopped"
echo ""