#!/bin/bash

# ============================================================
# Script: 01_file_info.sh
# Purpose: Display detailed information about a file
# Usage: bash 01_file_info.sh /path/to/file
# ============================================================

# Check if a file path was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a file path"
    echo "Usage: bash $0 /path/to/file"
    exit 1
fi

# Store the file path in a variable
FILE="$1"

# Check if the file exists
if [ ! -e "$FILE" ]; then
    echo "Error: File '$FILE' does not exist"
    exit 1
fi

# Print file information header
echo "======================================"
echo "FILE INFORMATION"
echo "======================================"

# 1. File path (absolute path)
echo "File Path: $(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"

# 2. File name
echo "File Name: $(basename "$FILE")"

# 3. Check if it's a file or directory
if [ -f "$FILE" ]; then
    echo "Type: Regular File"
elif [ -d "$FILE" ]; then
    echo "Type: Directory"
elif [ -L "$FILE" ]; then
    echo "Type: Symbolic Link"
else
    echo "Type: Special File"
fi

# 4. File size (in bytes and human-readable format)
if [ -f "$FILE" ]; then
    SIZE_BYTES=$(stat -f%z "$FILE" 2>/dev/null || stat -c%s "$FILE" 2>/dev/null)
    echo "File Size: $SIZE_BYTES bytes"
    
    # Convert to human-readable format
    if [ "$SIZE_BYTES" -gt 1073741824 ]; then
        SIZE_HUMAN=$(echo "scale=2; $SIZE_BYTES / 1073741824" | bc)" GB"
    elif [ "$SIZE_BYTES" -gt 1048576 ]; then
        SIZE_HUMAN=$(echo "scale=2; $SIZE_BYTES / 1048576" | bc)" MB"
    elif [ "$SIZE_BYTES" -gt 1024 ]; then
        SIZE_HUMAN=$(echo "scale=2; $SIZE_BYTES / 1024" | bc)" KB"
    else
        SIZE_HUMAN="$SIZE_BYTES bytes"
    fi
    echo "File Size (Readable): $SIZE_HUMAN"
fi

# 5. File permissions
echo "Permissions: $(ls -l "$FILE" | awk '{print $1}')"

# 6. Owner and group
echo "Owner: $(ls -l "$FILE" | awk '{print $3}')" 
echo "Group: $(ls -l "$FILE" | awk '{print $4}')"

# 7. Last modified date
echo "Last Modified: $(ls -l "$FILE" | awk '{print $6, $7, $8}')"

# 8. Last accessed date
echo "Last Accessed: $(stat -f '%Sa' "$FILE" 2>/dev/null || stat -c '%x' "$FILE" 2>/dev/null | cut -d' ' -f1,2)"

# 9. For text files, show line count
if [ -f "$FILE" ] && file "$FILE" | grep -q "text"; then
    LINE_COUNT=$(wc -l < "$FILE")
    echo "Lines of Text: $LINE_COUNT"
    
    # Show word count
    WORD_COUNT=$(wc -w < "$FILE")
    echo "Words: $WORD_COUNT"
    
    # Show character count
    CHAR_COUNT=$(wc -c < "$FILE")
    echo "Characters: $CHAR_COUNT"
fi

# 10. Directory specific information
if [ -d "$FILE" ]; then
    echo "Number of Items: $(ls -1 "$FILE" | wc -l)"
    echo "Directory Size: $(du -sh "$FILE" | awk '{print $1}')"
fi

echo "======================================"
echo "End of File Information"
echo "======================================"
