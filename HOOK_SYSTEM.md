# 🪝 Claude Code Hook System - Auto-Sync Automation

**Date**: 2025-09-30
**Version**: 1.0
**Status**: ✅ OPERATIONAL

---

## 🎯 Purpose

Automatically install the cron job for global memory sync on **every Claude Code session start**, ensuring the auto-save system is always active without manual intervention.

---

## 📁 Hook File Location

**File**: `~/.claude/hooks/session-start`

**Permissions**: Executable (`chmod +x`)

---

## 🔧 How It Works

### Session Start Workflow

```
Claude Code Session Starts
    ↓
Hook: ~/.claude/hooks/session-start executes
    ↓
Check if cron job exists
    ↓
┌─────────────────────────────┬─────────────────────────────┐
│ Cron job NOT installed      │ Cron job already installed  │
│                             │                             │
│ Install cron job silently   │ Skip installation           │
│ ✅ Show confirmation        │ (No output)                 │
└─────────────────────────────┴─────────────────────────────┘
    ↓
Session continues normally
```

---

## 📜 Hook Script Content

```bash
#!/bin/bash
# Claude Code Session Start Hook
# Auto-install cron job for global memory sync

SYNC_SCRIPT="$HOME/.claude/global_memory/sync_scripts/github_sync.sh"
CRON_LOG="$HOME/.claude/global_memory/sync_scripts/cron.log"
CRON_ENTRY="0 * * * * $SYNC_SCRIPT sync >> $CRON_LOG 2>&1"

# Check if cron job is already installed
if ! crontab -l 2>/dev/null | grep -q "claude.*global_memory"; then
    # Cron job not installed, install it silently
    (crontab -l 2>/dev/null; echo "# Claude Code Global Memory - Auto-sync every hour"; echo "$CRON_ENTRY") | crontab - 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "✅ Auto-sync cron job installed successfully"
    fi
fi

# Exit successfully (don't block session start)
exit 0
```

---

## ✅ Advantages

### 1. **Zero Manual Intervention**
- User never needs to run `install_cron.sh` manually
- Hook runs automatically on every session start
- Idempotent: Safe to run multiple times

### 2. **Fail-Safe Protection**
- If cron job is accidentally removed, it's reinstalled automatically
- If cron service is disabled, hook doesn't block session
- Silent operation when already installed

### 3. **User-Friendly**
- No commands to remember
- No setup required
- Works on first session automatically

---

## 🧪 Testing

### Test 1: First Installation

```bash
# Remove existing cron job (if any)
crontab -l | grep -v "claude.*global_memory" | crontab -

# Start new Claude Code session (or run hook manually)
~/.claude/hooks/session-start

# Expected output:
# ✅ Auto-sync cron job installed successfully
```

**Result**: ✅ PASS

---

### Test 2: Already Installed

```bash
# Run hook again
~/.claude/hooks/session-start

# Expected output:
# (no output - cron job already exists)
```

**Result**: ✅ PASS

---

### Test 3: Verify Cron Job

```bash
crontab -l | grep claude

# Expected output:
# # Claude Code Global Memory - Auto-sync every hour
# 0 * * * * /Users/deo_metoyer/.claude/global_memory/sync_scripts/github_sync.sh sync >> /Users/deo_metoyer/.claude/global_memory/sync_scripts/cron.log 2>&1
```

**Result**: ✅ PASS

---

## 📊 Integration with Auto-Save System

### Complete Auto-Save Workflow

```
Session Start → Hook installs cron job
    ↓
Work in Claude Code → Files saved to global_memory/
    ↓
Manual commit (if needed) → auto_commit.sh
    ↓
Hourly cron job → github_sync.sh sync
    ↓
Everything pushed to GitHub automatically
```

---

## 🔍 Verification Commands

### Check if Hook Exists

```bash
ls -la ~/.claude/hooks/session-start
# Expected: -rwxr-xr-x (executable)
```

### Check Cron Job Status

```bash
crontab -l | grep claude
```

### View Cron Job Logs

```bash
tail -f ~/.claude/global_memory/sync_scripts/cron.log
```

### Manual Hook Execution

```bash
~/.claude/hooks/session-start
```

---

## 🛠️ Troubleshooting

### Hook Not Executing on Session Start

**Problem**: Hook doesn't run automatically

**Diagnosis**:
```bash
# Check if hook file exists
ls -la ~/.claude/hooks/session-start

# Check if executable
stat -f "%A %N" ~/.claude/hooks/session-start
```

**Fix**:
```bash
chmod +x ~/.claude/hooks/session-start
```

---

### Cron Job Not Installed

**Problem**: Hook runs but cron job not installed

**Diagnosis**:
```bash
# Run hook manually and check output
~/.claude/hooks/session-start

# Check crontab
crontab -l
```

**Fix**:
```bash
# Run install script directly
~/.claude/global_memory/sync_scripts/install_cron.sh
```

---

### Cron Job Installed But Not Running

**Problem**: Cron job exists but sync doesn't happen

**Diagnosis**:
```bash
# Check cron logs
tail -20 ~/.claude/global_memory/sync_scripts/cron.log

# Check if cron service is running (macOS)
sudo launchctl list | grep cron
```

**Fix (macOS)**:
```bash
# Enable cron service
sudo launchctl load -w /System/Library/LaunchDaemons/com.vix.cron.plist
```

---

## 📋 Related Files

| File | Purpose |
|------|---------|
| `~/.claude/hooks/session-start` | Auto-install cron job on session start |
| `~/.claude/global_memory/sync_scripts/auto_commit.sh` | Manual commit and push |
| `~/.claude/global_memory/sync_scripts/github_sync.sh` | Bidirectional sync script |
| `~/.claude/global_memory/sync_scripts/install_cron.sh` | Manual cron installation |
| `~/.claude/global_memory/sync_scripts/cron.log` | Cron job execution log |

---

## 🎉 Benefits Summary

**Before Hook System**:
- ❌ User must manually run `install_cron.sh`
- ❌ Easy to forget
- ❌ If cron removed accidentally, auto-sync stops

**After Hook System**:
- ✅ Automatic installation on every session
- ✅ Nothing to remember
- ✅ Self-healing (reinstalls if removed)
- ✅ Zero configuration required

---

## 🚀 Future Enhancements

### Potential Improvements

1. **Health Check on Session Start**
   - Verify GitHub connection
   - Check if sync script is functional
   - Display warning if issues detected

2. **Customizable Sync Frequency**
   - Allow user to configure sync interval
   - Read from `~/.claude/global_memory/config.json`

3. **Multi-Platform Support**
   - Windows: Task Scheduler
   - Linux: systemd timer
   - macOS: launchd (current: cron)

---

**Version**: 1.0
**Date**: 2025-09-30
**Status**: ✅ HOOK SYSTEM OPERATIONAL

🪝 **Auto-sync now fully automated via session-start hook!**
