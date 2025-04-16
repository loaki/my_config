#!/usr/bin/env sh

pkill polybar && sleep 1
polybar -c ~/.config/polybar/config.ini &
