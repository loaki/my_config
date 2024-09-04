#!/bin/sh

alpha="dd"
bg="#2c2c2e"
fg="#9f9f9f"
hi="#efef8f"
ac="#a0afa0"
tx="#040404"
ia="#8f8f8f"
be="#8faf9f"
yw="#ccdc90"
gn="#88b090"
rd="#e89393"

i3lock \
    --insidever-color=$bg$alpha \
    --insidewrong-color=$bg$alpha \
    --inside-color=$bg$alpha \
    --ringver-color=$gn$alpha \
    --ringwrong-color=$rd$alpha \
    --ring-color=$fg$alpha \
    --line-uses-ring \
    --keyhl-color=$gn$alpha \
    --bshl-color=$rd$alpha \
    --separator-color=$fg$alpha \
    --verif-color=$ac \
    --wrong-color=$rd \
    --modif-color=$ac \
    --layout-color=$ac \
    --date-color=$ac \
    --time-color=$ac \
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
