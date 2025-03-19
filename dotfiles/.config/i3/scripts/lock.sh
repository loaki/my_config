#!/bin/sh


alpha="dd"
bg="#24273a"
fg="#cad3f5"
primary="#363b4e"
black="#363a4f"
red="#E78284"
green="#A6D189"
yellow="#E5C890"
blue="#8CAAEE"
magenta="#F4B8E4"
cyan="#81C8BE"
white="#B5BFE2"


i3lock \
    --insidever-color=$bg$alpha \
    --insidewrong-color=$bg$alpha \
    --inside-color=$bg$alpha \
    --ringver-color=$green$alpha \
    --ringwrong-color=$red$alpha \
    --ring-color=$primary$alpha \
    --line-uses-ring \
    --keyhl-color=$green$alpha \
    --bshl-color=$red$alpha \
    --separator-color=$primary$alpha \
    --verif-color=$green \
    --wrong-color=$red \
    --modif-color=$green \
    --layout-color=$white \
    --date-color=$white \
    --time-color=$white \
    --blur 1 \
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
