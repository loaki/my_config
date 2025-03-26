#!/bin/bash

i3-msg "focus output HDMI-1"
i3-msg "workspace 9"
i3-msg "exec kitty -e lazydocker"
sleep 1
i3-msg "exec element-desktop"
sleep 1
i3-msg "focus left"
i3-msg "split v"
i3-msg "exec kitty -e spotify_player"
sleep 1
i3-msg "focus right"
i3-msg "resize grow width 10 px or 10 ppt"

i3-msg "focus output eDP-1"
i3-msg "workspace 1"
i3-msg "exec brave-browser"
sleep 1
i3-msg "workspace 2"
i3-msg "move workspace to output eDP-1"
i3-msg "exec kitty"
sleep 1
i3-msg "workspace 8"
i3-msg "exec keepassxc"