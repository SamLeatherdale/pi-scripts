#!/bin/bash
xrandr --newmode "2560x720_60.00"  149.68  2560 2688 2952 3344  720 721 724 746  -HSync +Vsync
xrandr --addmode HDMI-2 "2560x720_60.00"
xrandr --output HDMI-2 --mode "2560x720_60.00"
