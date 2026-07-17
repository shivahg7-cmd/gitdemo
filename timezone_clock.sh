#!/bin/bash

# ============================================================
# Script: timezone_clock.sh
# Purpose: Display current time in different timezones
# Usage: bash timezone_clock.sh UTC "America/New_York"
# ============================================================

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Default timezones if none provided
if [ $# -eq 0 ]; then
    TIMEZONES=("UTC" "America/New_York" "Asia/Tokyo")
else
    TIMEZONES=("$@")
fi

# ============================================================
# Function: Display Header
# ============================================================
print_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔═════════════════════════════════════════════╗"
    echo "║         🌍 Global Digital Clock 🌍          ║"
    echo "║     Real-time display across timezones      ║"
    echo "╚═════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ============================================================
# Function: Get friendly timezone name
# ============================================================
get_friendly_name() {
    case "$1" in
        "UTC") echo "UTC" ;;
        "GMT") echo "GMT" ;;
        "America/New_York") echo "New York" ;;
        "America/Chicago") echo "Chicago" ;;
        "America/Denver") echo "Denver" ;;
        "America/Los_Angeles") echo "Los Angeles" ;;
        "Europe/London") echo "London" ;;
        "Europe/Paris") echo "Paris" ;;
        "Europe/Berlin") echo "Berlin" ;;
        "Asia/Tokyo") echo "Tokyo" ;;
        "Asia/Shanghai") echo "Shanghai" ;;
        "Asia/Kolkata") echo "India" ;;
        "Asia/Dubai") echo "Dubai" ;;
        "Asia/Singapore") echo "Singapore" ;;
        "Asia/Hong_Kong") echo "Hong Kong" ;;
        "Australia/Sydney") echo "Sydney" ;;
        "Australia/Melbourne") echo "Melbourne" ;;
        "Pacific/Auckland") echo "Auckland" ;;
        "Africa/Cairo") echo "Cairo" ;;
        "Africa/Johannesburg") echo "Johannesburg" ;;
        "Brazil/Sao_Paulo") echo "São Paulo" ;;
        "Canada/Pacific") echo "Canada (Pacific)" ;;
        *) echo "$1" ;;
    esac
}

# ============================================================
# Function: Get color based on region
# ============================================================
get_color() {
    case "$1" in
        *"America"*) echo "$YELLOW" ;;
        *"Europe"*) echo "$GREEN" ;;
        *"Asia"*) echo "$MAGENTA" ;;
        *"Australia"*) echo "$BLUE" ;;
        *"Africa"*) echo "$CYAN" ;;
        *) echo "$CYAN" ;;
    esac
}

# ============================================================
# Function: Display clock card for a timezone
# ============================================================
display_clock() {
    local timezone="$1"
    local color=$(get_color "$timezone")
    local friendly=$(get_friendly_name "$timezone")
    
    # Get time in timezone
    local time=$(TZ="$timezone" date '+%H:%M:%S')
    local date=$(TZ="$timezone" date '+%m/%d/%Y')
    local day=$(TZ="$timezone" date '+%A')
    
    # Display card
    echo -e "${color}${BOLD}┌─────────────────────────┐${NC}"
    printf "${color}${BOLD}│${NC} %-23s ${color}${BOLD}│${NC}\n" "$friendly"
    printf "${color}${BOLD}│${NC} %-23s ${color}${BOLD}│${NC}\n" "$time"
    printf "${color}${BOLD}│${NC} %-23s ${color}${BOLD}│${NC}\n" "$date"
    printf "${color}${BOLD}│${NC} %-23s ${color}${BOLD}│${NC}\n" "$day"
    echo -e "${color}${BOLD}└─────────────────────────┘${NC}"
}

# ============================================================
# Function: Display all timezone clocks
# ============================================================
display_all_clocks() {
    print_header
    
    # Display all clocks
    local count=0
    for timezone in "${TIMEZONES[@]}"; do
        # Check if timezone is valid
        if ! TZ="$timezone" date &>/dev/null; then
            echo -e "${RED}Error: Invalid timezone '$timezone'${NC}"
            continue
        fi
        
        display_clock "$timezone"
        
        # Add spacing
        if [ $(( (count + 1) % 2 )) -eq 0 ]; then
            echo ""
        fi
        
        ((count++))
    done
    
    # Footer
    echo -e "${CYAN}Timezones displayed: ${#TIMEZONES[@]}${NC}"
    echo -e "${CYAN}${BOLD}Press Ctrl+C to exit${NC}"
}

# ============================================================
# Function: Display usage information
# ============================================================
show_usage() {
    echo "Usage: bash timezone_clock.sh [timezone1] [timezone2] ..."
    echo ""
    echo "Examples:"
    echo "  bash timezone_clock.sh UTC                    # Single timezone"
    echo "  bash timezone_clock.sh UTC America/New_York   # Multiple timezones"
    echo "  bash timezone_clock.sh                        # Default timezones"
    echo ""
    echo "Supported Timezone Formats (IANA):"
    echo "  UTC, GMT"
    echo "  America/New_York, America/Chicago, America/Denver, America/Los_Angeles"
    echo "  Europe/London, Europe/Paris, Europe/Berlin"
    echo "  Asia/Tokyo, Asia/Shanghai, Asia/Kolkata, Asia/Dubai, Asia/Singapore"
    echo "  Australia/Sydney, Australia/Melbourne"
    echo "  Pacific/Auckland"
    echo "  Africa/Cairo, Africa/Johannesburg"
    echo "  Brazil/Sao_Paulo, Canada/Pacific"
    echo ""
    echo "For a complete list of timezones, run: timedatectl list-timezones"
}

# ============================================================
# Main Script
# ============================================================

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

# Validate timezones
for tz in "${TIMEZONES[@]}"; do
    if ! TZ="$tz" date &>/dev/null; then
        echo -e "${RED}Error: Invalid timezone '$tz'${NC}"
        echo "Run 'bash $0 --help' for usage information"
        exit 1
    fi
done

# Main loop - update every second
while true; do
    display_all_clocks
    sleep 1
done
