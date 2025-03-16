#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

export MONITORS=($(xrandr --query | grep ' connected ' | awk -F' ' '{print $1}'))

if [[ "${#MONITORS[@]}" -eq 1 ]]; then
    polybar -c ~/.config/polybar/config.ini single > /dev/null 2>&1 &!
elif [[ "${#MONITORS[@]}" -eq 2 ]]; then
    polybar -c ~/.config/polybar/config.ini left > /dev/null 2>&1 &!
    polybar -c ~/.config/polybar/config.ini right > /dev/null 2>&1 &!
fi
