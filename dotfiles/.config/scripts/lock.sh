#!/bin/sh


rosewater="#F4DBD6"
flamingo="#F0C6C6"
pink="#F5BDE6"
mauve="#C6A0F6"
red="#ED8796"
maroon="#EE99A0"
peach="#F5A97F"
yellow="#EED49F"
green="#A6DA95"
teal="#8BD5CA"
sky="#91D7E3"
sapphire="#7DC4E4"
blue="#8AADF4"
lavender="#B7BDF8"

text="#CAD3F5"
subtext1="#B8C0E0"
subtext0="#A5ADCB"
overlay2="#939AB7"
overlay1="#8087A2"
overlay0="#6E738D"
surface2="#5B6078"
surface1="#494D64"
surface0="#363A4F"

base="#24273A"
mantle="#1E2030"
crust="#181926"

WALLPAPER=$(cat ~/.fehbg | grep -o "'.*'" | sed "s/'//g")


i3lock \
    --image="$WALLPAPER" \
    --fill \
    --insidever-color=$base$alpha \
    --insidewrong-color=$base$alpha \
    --inside-color=$base$alpha \
    --ringver-color=$green$alpha \
    --ringwrong-color=$red$alpha \
    --ring-color=$surface0$alpha \
    --line-uses-ring \
    --keyhl-color=$mauve$alpha \
    --bshl-color=$red$alpha \
    --separator-color=$surface0$alpha \
    --verif-color=$green \
    --wrong-color=$red \
    --modif-color=$red \
    --layout-color=$text \
    --date-color=$text \
    --time-color=$text \
    --clock \
    --indicator \
    --time-str="%H:%M:%S" \
    --date-str="%A %e %B %Y" \
    --verif-text="Checking..." \
    --wrong-text="Wrong password" \
    --noinput="No Input" \
    --lock-text="Locking..." \
    --lockfailed="Lock Failed" \
    --radius=140 \
    --ring-width=10 \
    --pass-media-keys \
    --pass-screen-keys \
    --pass-volume-keys \
    --keylayout=1 \
    --nofork \
    --pointer=default
