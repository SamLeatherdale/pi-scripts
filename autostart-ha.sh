#!/usr/bin/env zsh
sleep 10 # Wait for HA to start
# Clear crashed flag
# https://superuser.com/questions/1343290/disable-chrome-session-restore-popup
sed -i 's/\"exit_type\":\"Crashed\"/\"exit_type\":\"Normal\"/g' \
    "/home/pi/.config/chromium/Default/Preferences"
# Open browser
/usr/bin/chromium-browser --profile-directory=Default --start-fullscreen --password-store=basic https://homeboard.samleatherdale.com
