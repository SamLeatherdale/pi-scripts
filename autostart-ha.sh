#!/usr/bin/env zsh
sleep 10 # Wait for HA to start
export BROWSER_ARGS="--profile-directory=Default --start-fullscreen"
export BROWSER="/usr/bin/chromium-browser"
cd /home/pi/homeboard
npm run start -- --open
