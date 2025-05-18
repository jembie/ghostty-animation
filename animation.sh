#!/usr/bin/env bash
# Set your Path to where you store the animation_frames folder
FRAMES_DIR="<YOUR PATH>"
FPS=34
DELAY=$(awk "BEGIN { print 1 / $FPS }")

# Function to restore cursor on exit
cleanup() {
  tput cnorm
  exit 0
}

# Set trap to catch Ctrl+C and other termination signals
trap cleanup INT TERM

tput civis
ROWS=$(tput lines)
COLS=$(tput cols)

while true; do
  find "$FRAMES_DIR" -name '*.txt' | sort | while read -r frame; do
    tput cup 0 0
    # Read only the first $ROWS lines
    head -n "$ROWS" "$frame" \
    | sed 's/\\e/\x1b/g' \
    | while IFS= read -r raw; do
      # Interpret escapes, then cut to $COLS visible chars
      printf '%b\n' "${raw:0:$COLS}"
    done
    sleep "$DELAY"
  done
done
