#!/usr/bin/env sh

pkill polybar && sleep 1
polybar -c ~/.config/i3/polybar/config.ini &
