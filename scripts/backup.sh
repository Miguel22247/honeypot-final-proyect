#!/bin/bash

# Cowrie backup script
# Author: Miguel Pacheco y Rolando Quiroz
COWRIE_DIR="/home/cowrie/cowrie"
BACKUP_DIR="/home/cowrie/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "Creating backup: cowrie_backup_$DATE.tar.gz"

tar -czf "$BACKUP_DIR/cowrie_backup_$DATE.tar.gz" \
    -C "$COWRIE_DIR" \
    var/log/cowrie/ \
    var/lib/cowrie/downloads/ \
    etc/cowrie.cfg \
    etc/userdb.txt

echo "Backup completed: $BACKUP_DIR/cowrie_backup_$DATE.tar.gz"

# Keep only last 7 backups
find "$BACKUP_DIR" -name "cowrie_backup_*.tar.gz" -type f -mtime +7 -delete
