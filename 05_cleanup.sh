#!/bin/bash

# ============================================================
# Script: 05_cleanup.sh
# Purpose: Clean up directories and manage file space
# Usage: bash 05_cleanup.sh /path/to/directory
# ============================================================

# Check if a directory path was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a directory path"
    echo "Usage: bash $0 /path/to/directory"
    exit 1
fi

TARGET_DIR="$1"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

echo "======================================"
echo "DIRECTORY CLEANUP UTILITY"
echo "======================================"
echo "Target Directory: $TARGET_DIR"
echo ""

# Get initial directory size
INITIAL_SIZE=$(du -sh "$TARGET_DIR" | awk '{print $1}')
echo "Initial Directory Size: $INITIAL_SIZE"
echo ""

echo "======================================"
echo "ANALYSIS"
echo "======================================"
echo ""

# 1. Find and report empty files
echo "1. Empty Files:"
echo "   Searching for empty files..."
EMPTY_FILES=$(find "$TARGET_DIR" -type f -size 0 2>/dev/null | wc -l)
if [ $EMPTY_FILES -gt 0 ]; then
    echo "   Found $EMPTY_FILES empty file(s)"
    echo "   Details:"
    find "$TARGET_DIR" -type f -size 0 2>/dev/null | head -10 | while read file; do
        echo "   - $file"
    done
    if [ $EMPTY_FILES -gt 10 ]; then
        echo "   ... and $((EMPTY_FILES - 10)) more"
    fi
else
    echo "   No empty files found"
fi
echo ""

# 2. Find and report empty directories
echo "2. Empty Directories:"
echo "   Searching for empty directories..."
EMPTY_DIRS=$(find "$TARGET_DIR" -type d -empty 2>/dev/null | wc -l)
if [ $EMPTY_DIRS -gt 0 ]; then
    echo "   Found $EMPTY_DIRS empty director(ies)"
    echo "   Details:"
    find "$TARGET_DIR" -type d -empty 2>/dev/null | head -10 | while read dir; do
        echo "   - $dir"
    done
    if [ $EMPTY_DIRS -gt 10 ]; then
        echo "   ... and $((EMPTY_DIRS - 10)) more"
    fi
else
    echo "   No empty directories found"
fi
echo ""

# 3. Find large files
echo "3. Large Files (> 10MB):"
echo "   Searching for large files..."
LARGE_FILES=$(find "$TARGET_DIR" -type f -size +10M 2>/dev/null | wc -l)
if [ $LARGE_FILES -gt 0 ]; then
    echo "   Found $LARGE_FILES large file(s)"
    echo "   Details:"
    find "$TARGET_DIR" -type f -size +10M -exec du -h {} \; 2>/dev/null | sort -rh | head -10 | while read line; do
        echo "   $line"
    done
    if [ $LARGE_FILES -gt 10 ]; then
        echo "   ... and $((LARGE_FILES - 10)) more"
    fi
else
    echo "   No large files found"
fi
echo ""

# 4. Find temporary files (common patterns)
echo "4. Temporary Files:"
echo "   Searching for temporary files..."
TEMP_FILES=$(find "$TARGET_DIR" -type f \( -name "*.tmp" -o -name "*.temp" -o -name "*.bak" \) 2>/dev/null | wc -l)
if [ $TEMP_FILES -gt 0 ]; then
    echo "   Found $TEMP_FILES temporary file(s)"
    echo "   Details:"
    find "$TARGET_DIR" -type f \( -name "*.tmp" -o -name "*.temp" -o -name "*.bak" \) 2>/dev/null | head -10 | while read file; do
        echo "   - $file"
    done
    if [ $TEMP_FILES -gt 10 ]; then
        echo "   ... and $((TEMP_FILES - 10)) more"
    fi
else
    echo "   No temporary files found"
fi
echo ""

# 5. Find duplicate filenames (potential duplicates by content)
echo "5. Files by Type:"
echo "   Analyzing file types..."
echo "   Common file types found:"
find "$TARGET_DIR" -type f 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | while read count ext; do
    echo "   .$ext : $count files"
done
echo ""

echo "======================================"
echo "SUMMARY"
echo "======================================"
echo "Empty Files: $EMPTY_FILES"
echo "Empty Directories: $EMPTY_DIRS"
echo "Large Files (>10MB): $LARGE_FILES"
echo "Temporary Files: $TEMP_FILES"
echo ""

echo "Recommendations:"
echo "1. Remove empty files: find $TARGET_DIR -type f -size 0 -delete"
echo "2. Remove empty dirs: find $TARGET_DIR -type d -empty -delete"
echo "3. Remove temp files: find $TARGET_DIR -type f -name '*.tmp' -delete"
echo ""

echo "======================================"
echo "MANUAL CLEANUP OPTION"
echo "======================================"
read -p "Do you want to remove empty files? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    REMOVED=$(find "$TARGET_DIR" -type f -size 0 -delete -print 2>/dev/null | wc -l)
    echo "✓ Removed $REMOVED empty file(s)"
fi

echo ""
read -p "Do you want to remove empty directories? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    REMOVED=$(find "$TARGET_DIR" -type d -empty -delete -print 2>/dev/null | wc -l)
    echo "✓ Removed $REMOVED empty director(ies)"
fi

echo ""
echo "======================================"
echo "FINAL REPORT"
echo "======================================"
FINAL_SIZE=$(du -sh "$TARGET_DIR" | awk '{print $1}')
echo "Initial Size: $INITIAL_SIZE"
echo "Final Size: $FINAL_SIZE"
echo ""
echo "Cleanup complete!"
echo "======================================"
