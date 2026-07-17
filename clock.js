// ============================================================
// Digital Clock - Multi Timezone JavaScript
// ============================================================

// Store active timezones
let activeTimezones = ['UTC', 'America/New_York', 'Asia/Tokyo'];
let is24HourFormat = true;

// Initialize the clock on page load
document.addEventListener('DOMContentLoaded', function() {
    updateAllClocks();
    // Update clock every 1000ms (1 second)
    setInterval(updateAllClocks, 1000);
    
    // Handle format toggle
    document.getElementById('formatToggle').addEventListener('change', function() {
        is24HourFormat = this.checked;
    });
    
    // Render initial clocks
    renderClocks();
});

/**
 * Get current time in a specific timezone
 * @param {string} timezone - IANA timezone identifier
 * @returns {object} Object with time components
 */
function getTimeInTimezone(timezone) {
    const now = new Date();
    
    try {
        // Get time string in specific timezone using Intl API
        const formatter = new Intl.DateTimeFormat('en-US', {
            timeZone: timezone,
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: true
        });
        
        const parts = formatter.formatToParts(now);
        const result = {};
        
        parts.forEach(part => {
            result[part.type] = part.value;
        });
        
        return {
            timezone: timezone,
            date: `${result.month}/${result.day}/${result.year}`,
            hour: result.hour,
            minute: result.minute,
            second: result.second,
            period: result.dayPeriod,
            fullDate: new Date(now.toLocaleString('en-US', { timeZone: timezone }))
        };
    } catch (error) {
        console.error(`Invalid timezone: ${timezone}`);
        return null;
    }
}

/**
 * Format time based on user preference (12/24 hour)
 * @param {object} timeData - Time data object
 * @returns {string} Formatted time string
 */
function formatTime(timeData) {
    if (!timeData) return 'Invalid';
    
    const hour = parseInt(timeData.hour);
    const minute = timeData.minute;
    const second = timeData.second;
    
    if (is24HourFormat) {
        // Convert to 24-hour format
        let hour24 = hour;
        if (timeData.period === 'PM' && hour !== 12) {
            hour24 = hour + 12;
        } else if (timeData.period === 'AM' && hour === 12) {
            hour24 = 0;
        }
        
        return `${String(hour24).padStart(2, '0')}:${minute}:${second}`;
    } else {
        // 12-hour format
        return `${timeData.hour}:${minute}:${second} ${timeData.period}`;
    }
}

/**
 * Get timezone display name (friendly name)
 * @param {string} timezone - IANA timezone identifier
 * @returns {string} Friendly timezone name
 */
function getTimezoneDisplayName(timezone) {
    const names = {
        'UTC': 'UTC',
        'GMT': 'GMT',
        'Europe/London': 'London',
        'Europe/Paris': 'Paris',
        'Europe/Berlin': 'Berlin',
        'America/New_York': 'New York',
        'America/Chicago': 'Chicago',
        'America/Denver': 'Denver',
        'America/Los_Angeles': 'Los Angeles',
        'Asia/Tokyo': 'Tokyo',
        'Asia/Shanghai': 'Shanghai',
        'Asia/Kolkata': 'India',
        'Asia/Dubai': 'Dubai',
        'Asia/Singapore': 'Singapore',
        'Asia/Hong_Kong': 'Hong Kong',
        'Australia/Sydney': 'Sydney',
        'Australia/Melbourne': 'Melbourne',
        'Pacific/Auckland': 'Auckland',
        'Africa/Cairo': 'Cairo',
        'Africa/Johannesburg': 'Johannesburg',
        'Brazil/Sao_Paulo': 'São Paulo',
        'Canada/Pacific': 'Canada (Pacific)'
    };
    
    return names[timezone] || timezone;
}

/**
 * Update all clock displays
 */
function updateAllClocks() {
    const container = document.getElementById('clocksContainer');
    const cards = container.querySelectorAll('.clock-card');
    
    cards.forEach(card => {
        const timezone = card.dataset.timezone;
        const timeData = getTimeInTimezone(timezone);
        
        if (timeData) {
            const clockDisplay = card.querySelector('.digital-clock');
            const dateDisplay = card.querySelector('.date-display');
            
            clockDisplay.textContent = formatTime(timeData);
            dateDisplay.textContent = timeData.date;
        }
    });
}

/**
 * Render all clock cards
 */
function renderClocks() {
    const container = document.getElementById('clocksContainer');
    
    if (activeTimezones.length === 0) {
        container.innerHTML = '<div class="empty-state"><p>No timezones selected. Add one to get started!</p></div>';
        return;
    }
    
    container.innerHTML = activeTimezones.map(timezone => {
        const displayName = getTimezoneDisplayName(timezone);
        const timeData = getTimeInTimezone(timezone);
        
        if (!timeData) return '';
        
        return `
            <div class="clock-card" data-timezone="${timezone}">
                <button class="remove-btn" onclick="removeTimezone('${timezone}')" title="Remove">×</button>
                <div class="timezone-name">${displayName}</div>
                <div class="digital-clock">${formatTime(timeData)}</div>
                <div class="date-display">${timeData.date}</div>
            </div>
        `;
    }).join('');
}

/**
 * Add a new timezone to the display
 */
function addTimezone() {
    const select = document.getElementById('timezoneSelect');
    const timezone = select.value;
    
    if (!timezone) {
        alert('Please select a timezone');
        return;
    }
    
    if (activeTimezones.includes(timezone)) {
        alert('This timezone is already displayed');
        return;
    }
    
    if (activeTimezones.length >= 12) {
        alert('Maximum 12 timezones can be displayed');
        return;
    }
    
    // Test if timezone is valid
    const timeData = getTimeInTimezone(timezone);
    if (!timeData) {
        alert('Invalid timezone');
        return;
    }
    
    activeTimezones.push(timezone);
    select.value = '';
    renderClocks();
    updateAllClocks();
}

/**
 * Remove a timezone from the display
 * @param {string} timezone - IANA timezone identifier
 */
function removeTimezone(timezone) {
    activeTimezones = activeTimezones.filter(tz => tz !== timezone);
    renderClocks();
}
