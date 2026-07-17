#!/bin/bash

# ============================================================
# Script: 02_dir_structure.sh
# Purpose: Display directory structure in a visual format
# Usage: bash 02_dir_structure.sh /path/to/directory
# ============================================================

# Check if a directory path was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a directory path"
    echo "Usage: bash $0 /path/to/directory"
    exit 1
fi

DIR="$1"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist"
    exit 1
fi

echo "======================================"
echo "DIRECTORY STRUCTURE"
echo "======================================"
echo "Root Directory: $DIR"
echo ""

# Function to recursively display directory tree
# This function uses indentation to show hierarchy
display_tree() {
    local dir="$1"
    local prefix="$2"
    local is_last=$3
    
    # Count items in directory
    local items=("$dir"/*)
    local total_items=0
    
    # Count only existing items
    for item in "${items[@]}"; do
        if [ -e "$item" ]; then
            ((total_items++))
        fi
    done
    
    # Also count hidden files (except . and ..)
    for item in "$dir"/.[!.]*; do
        if [ -e "$item" ]; then
            ((total_items++))
        fi
    done
    
    local count=0
    
    # Display regular files and directories
    for item in "$dir"/* "$dir"/.[!.]*; do
        if [ -e "$item" ]; then
            ((count++))
            local name=$(basename "$item")
            local is_dir=0
            
            # Check if it's the last item
            if [ $count -eq $total_items ]; then
                is_last=1
            else
                is_last=0
            fi
            
            # Determine the branch character
            if [ $is_last -eq 1 ]; then
                local branch="└── "
                local extension="    "
            else
                local branch="├── "
                local extension="│   "
            fi
            
            # Check if item is a directory
            if [ -d "$item" ]; then
                is_dir=1
                echo "${prefix}${branch}📁 $name/"
                
                # Recursively display subdirectory
                if [ $is_last -eq 1 ]; then
                    display_tree "$item" "${prefix}${extension}" 1
                else
                    display_tree "$item" "${prefix}${extension}" 0
                fi
            else
                echo "${prefix}${branch}📄 $name"
            fi
        fi
    done
}

# Display the tree starting from the given directory
echo "📁 $(basename "$DIR")/"
display_tree "$DIR" ""

echo ""
echo "======================================"
echo "DIRECTORY STATISTICS"
echo "======================================"

# Count total files and directories
FILE_COUNT=$(find "$DIR" -type f 2>/dev/null | wc -l)
DIR_COUNT=$(find "$DIR" -type d 2>/dev/null | wc -l)
TOTAL_SIZE=$(du -sh "$DIR" 2>/dev/null | awk '{print $1}')

echo "Total Files: $FILE_COUNT"
echo "Total Directories: $DIR_COUNT"
echo "Total Size: $TOTAL_SIZE"

echo ""
echo "======================================"
echo "End of Directory Structure"
echo "======================================"
