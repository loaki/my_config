#!/bin/bash

display=""
sleep_time=5

if xrandr | grep "HDMI-1 connected"; then
    display="HDMI-1"
elif xrandr | grep "DP-3 connected"; then
    display="DP-3"
fi

primary_display() {
    sleep $sleep_time
    i3-msg "focus output $1"
    i3-msg "workspace 1"
    i3-msg "move workspace to output $1"
    i3-msg "exec firefox"
    i3-msg "layout tabbed"
    sleep $sleep_time
    i3-msg "workspace 2"
    i3-msg "move workspace to output $1"
    i3-msg "exec kitty"
    sleep $sleep_time
    i3-msg "workspace 8"
    i3-msg "exec keepassxc"
}

secondary_display() {
    sleep $sleep_time
    i3-msg "focus output $1"
    i3-msg "workspace 9"
    i3-msg "exec kitty"
    sleep $sleep_time
    i3-msg "exec element-desktop"
    sleep $sleep_time
    i3-msg "focus left"
    i3-msg "split v"
    i3-msg "exec kitty -e spotify_player"
    sleep $sleep_time
    i3-msg "focus right"
    i3-msg "resize grow width 10 px or 10 ppt"
}

if [ "$display" == "HDMI-1" ]; then
    primary_display "eDP-1"
    secondary_display "HDMI-1"
elif [ "$display" == "DP-3" ]; then
    primary_display "DP-3"
    secondary_display "eDP-1"
else
    primary_display "eDP-1"
fi
