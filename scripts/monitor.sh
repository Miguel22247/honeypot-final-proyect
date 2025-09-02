#!/bin/bash

# Cowrie monitoring script
COWRIE_DIR="/home/cowrie/cowrie"
LOG_FILE="$COWRIE_DIR/var/log/cowrie/cowrie.log"

echo "=== Cowrie Status Report ==="
echo "Date: $(date)"
echo

# Check if Cowrie is running
if systemctl is-active --quiet cowrie; then
    echo "Status: RUNNING ✓"
else
    echo "Status: NOT RUNNING ✗"
fi

# Show recent connections
echo
echo "=== Recent Connections (Last 10) ==="
if [ -f "$LOG_FILE" ]; then
    tail -n 100 "$LOG_FILE" | grep "login attempt" | tail -n 10
else
    echo "No log file found"
fi

# Show connection statistics
echo
echo "=== Connection Statistics (Today) ==="
if [ -f "$LOG_FILE" ]; then
    TODAY=$(date +%Y-%m-%d)
    echo "Total login attempts today: $(grep "$TODAY" "$LOG_FILE" | grep "login attempt" | wc -l)"
    echo "Successful logins today: $(grep "$TODAY" "$LOG_FILE" | grep "login attempt" | grep "succeeded" | wc -l)"
    echo "Failed logins today: $(grep "$TODAY" "$LOG_FILE" | grep "login attempt" | grep "failed" | wc -l)"
fi

# Show top attacking IPs
echo
echo "=== Top Attacking IPs (Today) ==="
if [ -f "$LOG_FILE" ]; then
    TODAY=$(date +%Y-%m-%d)
    grep "$TODAY" "$LOG_FILE" | grep "login attempt" | grep -oP 'from \K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq -c | sort -nr | head -5
fi

# Show disk usage
echo
echo "=== Disk Usage ==="
echo "Log directory: $(du -sh $COWRIE_DIR/var/log/cowrie 2>/dev/null || echo "N/A")"
echo "Downloads directory: $(du -sh $COWRIE_DIR/var/lib/cowrie/downloads 2>/dev/null || echo "N/A")"
