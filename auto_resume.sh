#!/bin/bash
echo "=== Ubuntu Auto-Resume Script (Smart Sleep Version) ==="

# 1. Capture coordinates
echo -e "\n[Step 1] Move your mouse to the chatbox."
echo "Capturing location in 5 seconds..."
for i in {5..1}; do echo "$i..."; sleep 1; done

eval $(xdotool getmouselocation --shell)
echo "Location saved! (X: $X, Y: $Y)"

# 2. Set the message to send
echo -e "\n[Step 2] Enter the text to type when the script resumes:"
read -r RESUME_TEXT

# 3. Set time
echo -e "\n[Step 3] Enter activation time (e.g., 00:44 or 0.44):"
read RAW_TIME

# Replace any period with a colon (changes 0.44 to 0:44)
TARGET_TIME=$(echo "$RAW_TIME" | tr '.' ':')

# Use the 'date' command to validate the time format automatically
if ! date -d "$TARGET_TIME" >/dev/null 2>&1; then
    echo "Invalid time format. Please run again and use HH:MM."
    exit 1
fi

# 4. Calculate exact sleep duration
TARGET_SEC=$(date -d "$TARGET_TIME" +%s)
CURRENT_SEC=$(date +%s)

# If the target time is earlier than the current time, it must be for tomorrow
if [ "$TARGET_SEC" -le "$CURRENT_SEC" ]; then
    TARGET_SEC=$(date -d "tomorrow $TARGET_TIME" +%s)
fi

SLEEP_DURATION=$((TARGET_SEC - CURRENT_SEC))
HOURS=$((SLEEP_DURATION / 3600))
MINUTES=$(( (SLEEP_DURATION % 3600) / 60 ))

echo -e "\nScript will activate in $HOURS hours and $MINUTES minutes. Going to sleep..."

# Sleep for the exact calculated seconds
sleep $SLEEP_DURATION

# 5. Execute actions
echo -e "\nTime reached! Executing sequence..."
xdotool mousemove $X $Y click 1
sleep 0.5
xdotool type -- "$RESUME_TEXT"
xdotool key Return

echo "Task completed."
