#!/bin/bash


# Path to the log file
log_file="./log.txt"

# Function to get the current battery percentage
get_battery_percentage() {
    # You might need to adjust the command according to your system and battery status file location
    cat /sys/class/power_supply/BAT0/capacity
}


# Get the initial battery percentage
prev_percentage=$(get_battery_percentage)

# Log the Percent when laptop turns on
echo "$(date): Laptop turned on. Current percentage: $prev_percentage%" >> "$log_file"

# Infinite loop to keep checking the battery percentage
while true; do
    # Get the current battery percentage
    current_percentage=$(get_battery_percentage)
    
    # Check if the current percentage is less than the previous percentage
    if [ "$current_percentage" -ne "$prev_percentage" ]; then
        # Log the decrease to the log file
        echo "$(date): Battery percentage changed from $prev_percentage% to $current_percentage%" >> "$log_file"
    fi
    
    # Update the previous percentage for the next iteration
    prev_percentage=$current_percentage
    
    # Sleep for a while before checking again 
    sleep 15
done
