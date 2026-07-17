#!/bin/bash

# ============================================================
# Script: 04_file_search.sh
# Purpose: Search for files based on various criteria
# Usage: bash 04_file_search.sh -n filename -d /path/to/search
#        bash 04_file_search.sh -t type -d /path/to/search
#        bash 04_file_search.sh -s size -d /path/to/search
# ============================================================

# Default search directory is current directory
SEARCH_DIR="."
SEARCH_NAME=""
SEARCH_TYPE=""
SEARCH_SIZE=""

# Parse command line arguments
while getopts "n:d:t:s:" opt; do
    case $opt in
        n) SEARCH_NAME="$OPTARG" ;;
        d) SEARCH_DIR="$OPTARG" ;;
        t) SEARCH_TYPE="$OPTARG" ;;
        s) SEARCH_SIZE="$OPTARG" ;;
        *) echo "Invalid option: -$OPTARG"; exit 1 ;;
    esac
done

# Check if search directory exists
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Error: Directory '$SEARCH_DIR' does not exist"
    exit 1
fi

echo "======================================"
echo "FILE SEARCH UTILITY"
echo "======================================"
echo "Search Directory: $SEARCH_DIR"
echo ""

# Search by filename
if [ -n "$SEARCH_NAME" ]; then
    echo "Searching for files matching: $SEARCH_NAME"
    echo "--------------------------------------"
    
    FOUND_COUNT=0
    
    # Use find command to search
    while IFS= read -r file; do
        if [ -z "$file" ]; then
            continue
        fi
        
        ((FOUND_COUNT++))
        
        # Get file information
        FILE_SIZE=$(du -h "$file" 2>/dev/null | awk '{print $1}')
        MOD_DATE=$(ls -l "$file" | awk '{print $6, $7, $8}')
        FILE_TYPE=$(file -b "$file" | cut -d',' -f1)
        
        echo "📄 $file"
        echo "   Size: $FILE_SIZE | Modified: $MOD_DATE | Type: $FILE_TYPE"
    done < <(find "$SEARCH_DIR" -iname "*$SEARCH_NAME*" -type f 2>/dev/null)
    
    echo ""
    echo "Total files found: $FOUND_COUNT"
    echo ""
fi

# Search by file type
if [ -n "$SEARCH_TYPE" ]; then
    echo "Searching for files with type: $SEARCH_TYPE"
    echo "--------------------------------------"
    
    FOUND_COUNT=0
    
    # Convert to lowercase for comparison
    SEARCH_TYPE_LOWER=$(echo "$SEARCH_TYPE" | tr '[:upper:]' '[:lower:]')
    
    while IFS= read -r file; do
        if [ -z "$file" ]; then
            continue
        fi
        
        ((FOUND_COUNT++))
        
        FILE_SIZE=$(du -h "$file" 2>/dev/null | awk '{print $1}')
        MOD_DATE=$(ls -l "$file" | awk '{print $6, $7, $8}')
        
        echo "📄 $file"
        echo "   Size: $FILE_SIZE | Modified: $MOD_DATE"
    done < <(find "$SEARCH_DIR" -type f -name "*.$SEARCH_TYPE_LOWER" 2>/dev/null)
    
    echo ""
    echo "Total files found: $FOUND_COUNT"
    echo ""
fi

# Search by size
if [ -n "$SEARCH_SIZE" ]; then
    echo "Searching for large files (larger than $SEARCH_SIZE)"
    echo "--------------------------------------"
    
    FOUND_COUNT=0
    
    # Find files larger than specified size
    while IFS= read -r file; do
        if [ -z "$file" ]; then
            continue
        fi
        
        ((FOUND_COUNT++))
        
        FILE_SIZE=$(du -h "$file" 2>/dev/null | awk '{print $1}')
        MOD_DATE=$(ls -l "$file" | awk '{print $6, $7, $8}')
        
        echo "📄 $file"
        echo "   Size: $FILE_SIZE | Modified: $MOD_DATE"
    done < <(find "$SEARCH_DIR" -type f -size +${SEARCH_SIZE} 2>/dev/null)
    
    echo ""
    echo "Total files found: $FOUND_COUNT"
    echo ""
fi

# If no search criteria provided, show usage
if [ -z "$SEARCH_NAME" ] && [ -z "$SEARCH_TYPE" ] && [ -z "$SEARCH_SIZE" ]; then
    echo "No search criteria provided"
    echo ""
    echo "Usage:"
    echo "  Search by name:   bash $0 -n filename -d /path/to/search"
    echo "  Search by type:   bash $0 -t extension -d /path/to/search"
    echo "  Search by size:   bash $0 -s size -d /path/to/search"
    echo ""
    echo "Examples:"
    echo "  bash $0 -n 'test' -d ./"
    echo "  bash $0 -t 'txt' -d /home/user"
    echo "  bash $0 -s '10M' -d ./"
    exit 1
fi

echo "======================================"
echo "End of Search"
echo "======================================"
