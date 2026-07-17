#!/usr/bin/env python3

"""
==========================================================
Digital Clock - Multi Timezone (Python Version)

Purpose: Display current time in multiple timezones
Usage: python3 timezone_clock.py
==========================================================
"""

import os
import sys
import time
from datetime import datetime
from zoneinfo import ZoneInfo

# ANSI color codes for terminal output
class Colors:
    RESET = '\033[0m'
    BOLD = '\033[1m'
    DIM = '\033[2m'
    
    # Foreground colors
    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'
    
    # Background colors
    BG_BLACK = '\033[40m'
    BG_RED = '\033[41m'
    BG_GREEN = '\033[42m'
    BG_YELLOW = '\033[43m'
    BG_BLUE = '\033[44m'
    BG_MAGENTA = '\033[45m'
    BG_CYAN = '\033[46m'
    BG_WHITE = '\033[47m'


# Popular timezones with friendly names
POPULAR_TIMEZONES = {
    '1': ('UTC', 'Coordinated Universal Time'),
    '2': ('America/New_York', 'New York (EST/EDT)'),
    '3': ('America/Chicago', 'Chicago (CST/CDT)'),
    '4': ('America/Denver', 'Denver (MST/MDT)'),
    '5': ('America/Los_Angeles', 'Los Angeles (PST/PDT)'),
    '6': ('Europe/London', 'London (GMT/BST)'),
    '7': ('Europe/Paris', 'Paris (CET/CEST)'),
    '8': ('Europe/Berlin', 'Berlin (CET/CEST)'),
    '9': ('Asia/Tokyo', 'Tokyo (JST)'),
    '10': ('Asia/Shanghai', 'Shanghai (CST)'),
    '11': ('Asia/Kolkata', 'India (IST)'),
    '12': ('Asia/Dubai', 'Dubai (GST)'),
    '13': ('Asia/Singapore', 'Singapore (SGT)'),
    '14': ('Asia/Hong_Kong', 'Hong Kong (HKT)'),
    '15': ('Australia/Sydney', 'Sydney (AEST/AEDT)'),
    '16': ('Australia/Melbourne', 'Melbourne (AEST/AEDT)'),
    '17': ('Pacific/Auckland', 'Auckland (NZST/NZDT)'),
    '18': ('Africa/Cairo', 'Cairo (EET)'),
    '19': ('Africa/Johannesburg', 'Johannesburg (SAST)'),
    '20': ('Brazil/Sao_Paulo', 'São Paulo (BRT)'),
}


def clear_screen():
    """
    Clear the terminal screen
    """
    os.system('clear' if os.name != 'nt' else 'cls')


def print_header():
    """
    Print application header
    """
    print(f"{Colors.CYAN}{Colors.BOLD}")
    print("╔═════════════════════════════════════════════╗")
    print("║         🌍 Global Digital Clock 🌍          ║")
    print("║     Real-time display across timezones      ║")
    print("╚═════════════════════════════════════════════╝")
    print(f"{Colors.RESET}\n")


def display_timezone_menu():
    """
    Display popular timezones menu
    """
    print(f"{Colors.YELLOW}{Colors.BOLD}Available Timezones:{Colors.RESET}\n")
    
    for key, (tz, name) in POPULAR_TIMEZONES.items():
        print(f"  {Colors.BOLD}{key:2}{Colors.RESET}. {name}")
    
    print(f"\n  {Colors.BOLD}21{Colors.RESET}. Enter custom timezone")
    print(f"  {Colors.BOLD}0{Colors.RESET}.  Done adding timezones\n")


def get_timezone_input():
    """
    Get timezone selection from user
    
    Returns:
        str: Selected timezone or None
    """
    while True:
        choice = input("Select timezone (1-21): ").strip()
        
        if choice == '0':
            return None
        
        if choice in POPULAR_TIMEZONES:
            return POPULAR_TIMEZONES[choice][0]
        
        if choice == '21':
            custom_tz = input("Enter timezone (e.g., Asia/Kolkata): ").strip()
            # Validate timezone
            try:
                ZoneInfo(custom_tz)
                return custom_tz
            except Exception:
                print(f"{Colors.RED}Invalid timezone. Try again.{Colors.RESET}")
                continue
        
        print(f"{Colors.RED}Invalid choice. Please try again.{Colors.RESET}")


def get_time_in_timezone(timezone_name, use_24hour=True):
    """
    Get current time in a specific timezone
    
    Args:
        timezone_name (str): IANA timezone identifier
        use_24hour (bool): Use 24-hour format
    
    Returns:
        dict: Time information
    """
    try:
        tz = ZoneInfo(timezone_name)
        now = datetime.now(tz)
        
        if use_24hour:
            time_str = now.strftime('%H:%M:%S')
        else:
            time_str = now.strftime('%I:%M:%S %p')
        
        date_str = now.strftime('%m/%d/%Y')
        day_name = now.strftime('%A')
        
        return {
            'timezone': timezone_name,
            'time': time_str,
            'date': date_str,
            'day': day_name,
            'hour': now.hour,
            'minute': now.minute,
            'second': now.second
        }
    except Exception as e:
        return None


def get_friendly_timezone_name(timezone_name):
    """
    Get friendly display name for timezone
    
    Args:
        timezone_name (str): IANA timezone identifier
    
    Returns:
        str: Friendly name
    """
    for key, (tz, name) in POPULAR_TIMEZONES.items():
        if tz == timezone_name:
            return name.split('(')[0].strip()
    
    return timezone_name


def display_clock_cards(timezones, use_24hour=True):
    """
    Display clock cards for all timezones
    
    Args:
        timezones (list): List of timezone names
        use_24hour (bool): Use 24-hour format
    """
    clear_screen()
    print_header()
    
    # Display format info
    format_str = "24-Hour" if use_24hour else "12-Hour"
    print(f"Format: {Colors.BOLD}{format_str}{Colors.RESET}\n")
    
    if not timezones:
        print(f"{Colors.RED}No timezones selected.{Colors.RESET}")
        return
    
    # Get all timezone data
    all_times = []
    for tz in timezones:
        time_data = get_time_in_timezone(tz, use_24hour)
        if time_data:
            all_times.append(time_data)
    
    if not all_times:
        print(f"{Colors.RED}Error retrieving timezone data.{Colors.RESET}")
        return
    
    # Display in columns
    col_width = 40
    
    # Header
    print(f"{Colors.CYAN}{Colors.BOLD}" + "═" * (col_width * ((len(all_times) + 1) // 2)) + f"{Colors.RESET}")
    
    # Display clocks
    for i, time_data in enumerate(all_times):
        friendly_name = get_friendly_timezone_name(time_data['timezone'])
        
        # Color code different regions
        color = Colors.CYAN
        if 'America' in time_data['timezone']:
            color = Colors.YELLOW
        elif 'Europe' in time_data['timezone']:
            color = Colors.GREEN
        elif 'Asia' in time_data['timezone']:
            color = Colors.MAGENTA
        elif 'Australia' in time_data['timezone']:
            color = Colors.BLUE
        
        card = (
            f"{color}{Colors.BOLD}┌─────────────────────────┐{Colors.RESET}\n"
            f"{color}{Colors.BOLD}│{Colors.RESET} {friendly_name:23} {color}{Colors.BOLD}│{Colors.RESET}\n"
            f"{color}{Colors.BOLD}│{Colors.RESET} {time_data['time']:23} {color}{Colors.BOLD}│{Colors.RESET}\n"
            f"{color}{Colors.BOLD}│{Colors.RESET} {time_data['date']:23} {color}{Colors.BOLD}│{Colors.RESET}\n"
            f"{color}{Colors.BOLD}│{Colors.RESET} {time_data['day']:23} {color}{Colors.BOLD}│{Colors.RESET}\n"
            f"{color}{Colors.BOLD}└─────────────────────────┘{Colors.RESET}"
        )
        
        print(card)
        
        if (i + 1) % 2 == 0:
            print()
    
    print(f"\n{Colors.DIM}Press Ctrl+C to exit{Colors.RESET}")


def format_toggle_prompt():
    """
    Prompt user for time format preference
    
    Returns:
        bool: True for 24-hour, False for 12-hour
    """
    while True:
        choice = input("\nUse 24-hour format? (y/n): ").strip().lower()
        if choice in ['y', 'yes']:
            return True
        elif choice in ['n', 'no']:
            return False
        print(f"{Colors.RED}Invalid choice. Please try again.{Colors.RESET}")


def main():
    """
    Main application loop
    """
    try:
        clear_screen()
        print_header()
        
        # Get user preferences
        use_24hour = format_toggle_prompt()
        
        selected_timezones = []
        
        # Get timezone selections
        print("\n")
        while True:
            display_timezone_menu()
            tz = get_timezone_input()
            
            if tz is None:
                if not selected_timezones:
                    print(f"{Colors.RED}Please select at least one timezone.{Colors.RESET}")
                    continue
                break
            
            if tz not in selected_timezones:
                selected_timezones.append(tz)
                friendly_name = get_friendly_timezone_name(tz)
                print(f"{Colors.GREEN}✓ Added: {friendly_name}{Colors.RESET}\n")
            else:
                print(f"{Colors.YELLOW}Already added this timezone.{Colors.RESET}\n")
        
        # Display clocks continuously
        while True:
            display_clock_cards(selected_timezones, use_24hour)
            time.sleep(1)
    
    except KeyboardInterrupt:
        clear_screen()
        print(f"{Colors.CYAN}Thank you for using Global Digital Clock! 👋{Colors.RESET}")
        sys.exit(0)
    except Exception as e:
        print(f"{Colors.RED}Error: {e}{Colors.RESET}")
        sys.exit(1)


if __name__ == '__main__':
    main()
