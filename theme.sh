#!/bin/sh

# Define the folder
IMAGE_DIR="$HOME/code/pywal"

# Find all image files (jpg, png, webp) and pick one randomly
RANDOM_IMAGE=$(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

feh --bg-scale "$WALLPAPER"

wal -i "$RANDOM_IMAGE"

# Read colors from Pywal's JSON file
WAL_COLORS="$HOME/.cache/wal/colors.json"

# Extract colors
BG=$(jq -r '.special.background' "$WAL_COLORS")
FG=$(jq -r '.special.foreground' "$WAL_COLORS")
BORDER=$(jq -r '.colors.color4' "$WAL_COLORS")

# Apply to DWM dynamically
xsetroot -solid "$BG"

# Apply Colors to DWM via Xresources
echo "dwm.normbgcolor: $BG" > ~/.Xresources
echo "dwm.normfgcolor: $FG" >> ~/.Xresources
echo "dwm.normbordercolor: $BORDER" >> ~/.Xresources

xrdb -merge ~/.Xresources

# Update bar colors (if using DWMblocks or a status bar)
echo -e "%{B$BG}%{F$FG}" > /tmp/dwm_status

# Optional: Reload bar by signaling DWMblocks or any custom bar
killall -SIGUSR1 dwmblocks 2>/dev/null
