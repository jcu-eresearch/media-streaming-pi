#!/bin/sh

# Sleep for a while to allow GDM's panel to start up
# WARNING: race condition!
sleep 15

# Improve brightness and colour on display
xrandr --output eDP --brightness 1.15 --gamma 1:1:1.2

# Play video
mpv \
    --no-osc \
    --no-border \
    --no-window-dragging \
    --fullscreen \
    --fs-screen=all \
    --ontop \
    --loop-playlist \
    --really-quiet \
    --brightness 0 \
    --contrast -10 \
    --saturation 20 \
    --playlist /home/eresearch/.media_playlist > /dev/null 2>&1
