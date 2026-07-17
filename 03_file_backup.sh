#!/bin/bash

# ============================================================
# Script: 03_file_backup.sh
# Purpose: Create timestamped backups of files and directories
# Usage: bash 03_file_backup.sh /path/to/file
# ============================================================

# Check if a file path was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a file or directory path to backup"
    echo "Usage: bash $0 /path/to/file"
    exit 1
fi

SOURCE="$1"
BACKUP_DIR="./backups"

# Check if the source exists
if [ ! -e "$SOURCE" ]; then
    echo "Error: Source '$SOURCE' does not exist"
    exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Created backup directory: $BACKUP_DIR"
fi

echo "======================================"
echo "FILE BACKUP UTILITY"
echo "======================================"
echo "Source: $SOURCE"
echo ""

# Generate timestamp (YYYY-MM-DD_HH-MM-SS)
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# Get the base name of the source
BASENAME=$(basename "$SOURCE")

# Create backup filename with timestamp
BACKUP_NAME="${BASENAME}_backup_${TIMESTAMP}"

if [ -f "$SOURCE" ]; then
    # It's a file - copy it
    BACKUP_FILE="$BACKUP_DIR/$BACKUP_NAME"
    
    echo "Backing up file..."
    cp "$SOURCE" "$BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        # Get file sizes
        ORIGINAL_SIZE=$(du -h "$SOURCE" | awk '{print $1}')
        BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')
        
        echo "✓ Backup successful!"
        echo "Backup Location: $BACKUP_FILE"
        echo "Original Size: $ORIGINAL_SIZE"
        echo "Backup Size: $BACKUP_SIZE"
    else
        echo "✗ Error: Backup failed"
        exit 1
    fi
    
elif [ -d "$SOURCE" ]; then
    # It's a directory - create a tar archive
    BACKUP_FILE="$BACKUP_DIR/${BACKUP_NAME}.tar.gz"
    
    echo "Backing up directory..."
    tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE")" "$BASENAME"
    
    if [ $? -eq 0 ]; then
        # Get directory and backup sizes
        ORIGINAL_SIZE=$(du -sh "$SOURCE" | awk '{print $1}')
        BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')
        
        echo "✓ Backup successful!"
        echo "Backup Location: $BACKUP_FILE"
        echo "Original Size: $ORIGINAL_SIZE"
        echo "Backup Size: $BACKUP_SIZE"
    else
        echo "✗ Error: Backup failed"
        exit 1
    fi
fi

echo ""
echo "======================================"
echo "BACKUP VERIFICATION"
echo "======================================"

# Verify backup integrity
if [ -f "$BACKUP_FILE" ]; then
    if file "$BACKUP_FILE" | grep -q "gzip"; then
        # It's a tar.gz archive - verify it
        if tar -tzf "$BACKUP_FILE" > /dev/null 2>&1; then
            echo "✓ Archive integrity verified"
        else
            echo "✗ Warning: Archive may be corrupted"
        fi
    else
        # It's a regular file - check if it exists and has content
        if [ -s "$BACKUP_FILE" ]; then
            echo "✓ Backup file verified"
        else
            echo "✗ Warning: Backup file is empty"
        fi
    fi
fi

echo ""
echo "======================================"
echo "RECENT BACKUPS"
echo "======================================"

# List the 5 most recent backups
echo "Last 5 backups:"
ls -lt "$BACKUP_DIR" | head -6 | tail -5 | awk '{print $6, $7, $8, $9}'

echo ""
echo "======================================"
echo "End of Backup"
echo "======================================"
