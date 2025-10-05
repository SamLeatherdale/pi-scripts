#!/usr/bin/env bash
# resolution.sh
#
# Purpose: ensure the physical display gets the preferred resolution when the
# session starts. The script prefers Wayland (wlr-randr) and falls back to
# X11/xrandr when necessary. It is intended to be run at session login via an
# XDG autostart .desktop file or invoked manually.
#
# Notes about firmware changes applied earlier to /boot/firmware/config.txt:
# - We added a forced custom HDMI mode to the firmware so the kernel sees it
#   at boot. The block added looked like:
#
#   ### Added by set-resolution script: force 2560x720@60
#   hdmi_force_hotplug=1
#   hdmi_group=2
#   hdmi_mode=87
#   hdmi_cvt=2560 720 60 1 0 0 0
#   hdmi_drive=2
#
# - We also commented-out `disable_fw_kms_setup=1` so the firmware-provided
#   mode is propagated into the kernel DRM/VC4 driver.
#
# create the autostart directory and .desktop file for the user 'pi':
#   mkdir -p /home/pi/.config/autostart
# symlink this script
# ln -s /home/pi/pi-scripts/set-resolution.desktop /home/pi/.config/autostart/set-resolution.desktop
#
# This script will log to /tmp/resolution.log for quick debugging.

LOG=/tmp/resolution.log
echo "[$(date --iso-8601=seconds)] resolution script start" >"$LOG"

DESIRED_WLR="2560x720"
DESIRED_X="2560x720_60.00"

set -e

# Helper: run a command and log stdout/stderr
runlog() {
	echo "[$(date --iso-8601=seconds)] $ $*" >>"$LOG"
	"$@" >>"$LOG" 2>&1 || return 1
}

# Detect Wayland runtime socket
WLR_SOCKET="$(ls -1 /run/user/1000/wayland-* 2>/dev/null | head -n1 || true)"
if [ -n "$WLR_SOCKET" ]; then
	export XDG_RUNTIME_DIR=/run/user/1000
	export WAYLAND_DISPLAY="$(basename "$WLR_SOCKET")"
	echo "[$(date --iso-8601=seconds)] Wayland runtime detected: $WAYLAND_DISPLAY" >>"$LOG"

	if command -v wlr-randr >/dev/null 2>&1; then
		# List outputs and try to set the desired mode only when needed
		mapfile -t outputs < <(wlr-randr 2>/dev/null | awk '/^[A-Z0-9-]+/ {print $1}')
		for out in "${outputs[@]}"; do
			# Read current mode from wlr-randr output block
			cur=$(wlr-randr "$out" 2>/dev/null | awk '/current/ {print $2; exit}') || true
			if [ "$cur" = "$DESIRED_WLR" ]; then
				echo "[$(date --iso-8601=seconds)] $out already at $DESIRED_WLR" >>"$LOG"
				continue
			fi
			# Attempt to set the mode only if available
			if wlr-randr "$out" "$DESIRED_WLR" >>"$LOG" 2>&1; then
				echo "[$(date --iso-8601=seconds)] set $out -> $DESIRED_WLR" >>"$LOG"
				exit 0
			else
				echo "[$(date --iso-8601=seconds)] $out does not accept $DESIRED_WLR" >>"$LOG"
			fi
		done
	fi
fi

# Xwayland/xrandr fallback
if [ -S /run/user/1000/wayland-0 ] || [ -n "$DISPLAY" ] || pgrep -u 1000 Xwayland >/dev/null 2>&1; then
	XAUTH="${XAUTHORITY:-/home/pi/.Xauthority}"
	export DISPLAY="${DISPLAY:-:0}"
	export XAUTHORITY="$XAUTH"
	echo "[$(date --iso-8601=seconds)] Trying X fallback (DISPLAY=$DISPLAY XAUTHORITY=$XAUTH)" >>"$LOG"

	if command -v xrandr >/dev/null 2>&1; then
		xout="$(xrandr --query | awk '/ connected/ {print $1; exit}')" || true
		if [ -n "$xout" ]; then
			# create mode if not present
			if ! xrandr --query | grep -q "$DESIRED_X"; then
				runlog xrandr --newmode "$DESIRED_X" 149.68 2560 2688 2952 3344 720 721 724 746 -HSync +Vsync || true
				runlog xrandr --addmode "$xout" "$DESIRED_X" || true
			fi
			runlog xrandr --output "$xout" --mode "$DESIRED_X" || true
			echo "[$(date --iso-8601=seconds)] Applied X mode on $xout" >>"$LOG"
			cat "$LOG"
			exit 0
		fi
	fi
fi

echo "[$(date --iso-8601=seconds)] Nothing done (no suitable output or mode not available)" >>"$LOG"
cat "$LOG"
exit 0

