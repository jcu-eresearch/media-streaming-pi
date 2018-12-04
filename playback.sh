#!/bin/sh

mpv \
    --no-osc \
    --no-border \
    --no-window-dragging \
    --fullscreen \
    --fs-screen=all \
    --ontop \
    --loop-playlist \
    --really-quiet \
    --playlist /home/eresearch/.media_playlist > /dev/null 2>&1
