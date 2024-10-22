#!/bin/sh

COMMAND="google-drive-ocamlfuse"

if command -v $COMMAND > /dev/null 2>&1; then
    mkdir -p ~/GoogleDrive
    ERR_MSG=$($COMMAND ~/GoogleDrive 2>&1 >/dev/null)
    if [ $? -ne 0 ]; then
        notify-send "Error running $COMMAND" "$ERR_MSG"
    fi
fi