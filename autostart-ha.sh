#!/usr/bin/env zsh
#
# Home Assistant Chromium Autostart Script
#
# This script automatically opens Chromium in fullscreen mode to display
# the Home Assistant dashboard. It includes a delay for HA to start up
# and clears any crash flags from previous sessions.
#
# Desktop Autostart Setup:
# This script is configured to run at desktop login via the autostart-ha.desktop
# file in this directory, which is symlinked to ~/.config/autostart/
# 
# To create the symlink manually:
# ln -sf /home/pi/pi-scripts/autostart-ha.desktop ~/.config/autostart/autostart-ha.desktop
#
# Debug log location: /tmp/autostart-ha.log
#

LOG=/tmp/autostart-ha.log
echo "[$(date --iso-8601=seconds)] autostart-ha script start" > "$LOG"
echo "[$(date --iso-8601=seconds)] Environment:" >> "$LOG"
echo "  DISPLAY=$DISPLAY" >> "$LOG"
echo "  XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP" >> "$LOG"
echo "  WAYLAND_DISPLAY=$WAYLAND_DISPLAY" >> "$LOG"
echo "  USER=$(whoami)" >> "$LOG"
echo "  PWD=$(pwd)" >> "$LOG"

echo "[$(date --iso-8601=seconds)] Waiting 10 seconds for HA to start..." >> "$LOG"
sleep 10 # Wait for HA to start

echo "[$(date --iso-8601=seconds)] Clearing crashed flag" >> "$LOG"
# Clear crashed flag
# https://superuser.com/questions/1343290/disable-chrome-session-restore-popup
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/g' \
    "/home/pi/.config/chromium/Default/Preferences" 2>> "$LOG"

echo "[$(date --iso-8601=seconds)] Starting chromium-browser" >> "$LOG"
# Open browser
/usr/bin/chromium --profile-directory=Default --start-fullscreen --password-store=basic https://homeboard.samleatherdale.com >> "$LOG" 2>&1 &

echo "[$(date --iso-8601=seconds)] Chromium launched with PID $!" >> "$LOG"
echo "[$(date --iso-8601=seconds)] autostart-ha script complete" >> "$LOG"
