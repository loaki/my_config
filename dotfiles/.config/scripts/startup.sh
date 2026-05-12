#!/bin/bash

display=""
sleep_time=5

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
    i3-msg "exec element-desktop"
}

get_displays() {
    xrandr --query | grep " connected" | awk '{print $1}'
}

get_primary() {
    get_displays | grep -E "eDP|LVDS|PANEL" | head -1
}

get_secondary() {
    local primary=$(get_primary)
    get_displays | grep -v "$primary" | head -1
}

primary_display="$(get_primary)"
secondary_display="$(get_secondary)"

if [ "$secondary_display" == "DP-1" ]; then
    temp="$primary_display"
    primary_display="$secondary_display"
    secondary_display="$temp"
fi

if [ -n "$primary_display" ]; then
    primary_display "$primary_display"
fi

if [ -n "$secondary_display" ]; then
    secondary_display "$secondary_display"
fi
