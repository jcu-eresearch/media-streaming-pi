#!/bin/sh

mplayer \
    -fs \
    -noborder \
    -cache 64000 \
    -framedrop \
    -nocorrect-pts \
    -fixed-vo \
    -really-quiet \
    -loop 0 \
    -playlist /home/pi/.media_playlist > /dev/null 2>&1
