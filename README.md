# Digital Clock - Multiple Time Zones

A comprehensive digital clock project that displays the current time in different time zones. Includes web-based, Python, and Bash implementations.

## Project Overview

This project demonstrates how to work with time zones and display real-time updates across multiple implementations.

## Features

✨ **Multi-timezone support**
- Display time in multiple time zones simultaneously
- Easy timezone switching
- 12-hour and 24-hour format options
- Automatic updates every second

## Project Structure

```
digital-clock/
├── README.md                 # This file
├── index.html               # Web-based clock (HTML/CSS/JavaScript)
├── style.css                # Styling for web clock
├── clock.js                 # JavaScript functionality
├── timezone_clock.py        # Python timezone utility
└── timezone_clock.sh        # Bash timezone utility
```

## 1. Web-Based Digital Clock

### Files:
- `index.html` - Main HTML structure
- `style.css` - Styling and animations
- `clock.js` - JavaScript clock logic

### Usage:
Simply open `index.html` in your web browser.

### Features:
- Real-time clock updates
- Multiple timezone support
- Toggle between 12-hour and 24-hour format
- Add/remove timezones dynamically
- Beautiful animated design
- Responsive layout

### Supported Timezones:
- UTC (Coordinated Universal Time)
- EST (Eastern Standard Time)
- CST (Central Standard Time)
- MST (Mountain Standard Time)
- PST (Pacific Standard Time)
- GMT (Greenwich Mean Time)
- IST (Indian Standard Time)
- JST (Japan Standard Time)
- AEST (Australian Eastern Standard Time)
- And many more...

## 2. Python Timezone Clock

### File: `timezone_clock.py`

### Usage:
```bash
python3 timezone_clock.py
```

### Features:
- Command-line timezone clock
- Interactive timezone selection
- Real-time updates
- Color-coded output (if terminal supports it)
- Display multiple timezones
- Easy customization

### Example:
```bash
# Run the clock
python3 timezone_clock.py

# Follow the prompts to add timezones
```

## 3. Bash Timezone Clock

### File: `timezone_clock.sh`

### Usage:
```bash
bash timezone_clock.sh
```

### Features:
- Shell script implementation
- Pure bash - no external dependencies required
- Real-time updates
- Multiple timezone support
- Easy to modify and extend

### Examples:
```bash
# Display time in specific timezone
bash timezone_clock.sh UTC
bash timezone_clock.sh "Asia/Kolkata"

# Display multiple timezones
bash timezone_clock.sh UTC "America/New_York" "Europe/London"
```

## Installation & Setup

### For Web Clock:
1. Extract all files to a directory
2. Open `index.html` in your web browser
3. No server required!

### For Python Clock:
```bash
# Make sure Python 3 is installed
python3 --version

# Run the script
python3 timezone_clock.py
```

### For Bash Clock:
```bash
# Make the script executable
chmod +x timezone_clock.sh

# Run the script
bash timezone_clock.sh UTC
```

## Learning Concepts

This project teaches:

### JavaScript/Web:
- Date and Time handling in JavaScript
- Intl API for timezone support
- DOM manipulation
- CSS animations and styling
- Event handling

### Python:
- `datetime` and `pytz` modules
- Timezone handling
- String formatting
- Interactive user input
- Terminal color codes

### Bash:
- `date` command with timezone options
- Environment variables
- Command-line argument parsing
- String manipulation
- Loops and conditionals

## Common Timezone Abbreviations

| Zone | UTC Offset | Example |
|------|------------|----------|
| UTC | UTC+0 | Coordinated Universal Time |
| GMT | UTC+0 | Greenwich Mean Time |
| EST | UTC-5 | Eastern Standard Time |
| CST | UTC-6 | Central Standard Time |
| MST | UTC-7 | Mountain Standard Time |
| PST | UTC-8 | Pacific Standard Time |
| IST | UTC+5:30 | Indian Standard Time |
| JST | UTC+9 | Japan Standard Time |
| AEST | UTC+10 | Australian Eastern Standard Time |
| NZST | UTC+12 | New Zealand Standard Time |

## IANA Timezone Format

For more precise timezone specification, use IANA format:
- `America/New_York`
- `Europe/London`
- `Asia/Tokyo`
- `Asia/Kolkata`
- `Australia/Sydney`
- `Pacific/Auckland`

## Tips for Learning

1. **Start with the web clock** - Easiest to visualize and understand
2. **Explore the JavaScript** - Learn how browsers handle timezones
3. **Try the Python version** - Understand timezone libraries
4. **Study the Bash script** - Learn shell scripting basics
5. **Modify and experiment** - Add new timezones, change formats, etc.

## Troubleshooting

### Web Clock not updating:
- Check browser console (F12) for errors
- Ensure JavaScript is enabled
- Try refreshing the page

### Python script errors:
- Ensure Python 3 is installed: `python3 --version`
- Install required modules: `pip3 install pytz`
- Check timezone spelling

### Bash script issues:
- Make sure the script is executable: `chmod +x timezone_clock.sh`
- Use correct timezone format (IANA format preferred)
- Check if `date` command supports timezone options on your system

## Browser Compatibility

The web clock works on:
- Chrome/Chromium (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers

## Future Enhancements

Potential additions:
- Alarm functionality
- Stopwatch/Timer
- World map with timezone visualization
- Custom timezone selection UI
- Sound notifications
- Dark mode
- Local storage for saved timezones

## License

Open source - Feel free to use, modify, and distribute for learning purposes.

---

**Happy Coding!** ⏰🌍
