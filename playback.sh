#!/bin/sh

mpv \
    --rpi-background=yes \
    --rpi-osd=no \
    --no-osc \
    --no-border \
    --no-window-dragging \
    --fullscreen \
    --fs-screen=all \
    --ontop \
    --really-quiet \
    --loop-playlist \
    --playlist /home/pi/.media_playlist > /dev/null 2>&1
