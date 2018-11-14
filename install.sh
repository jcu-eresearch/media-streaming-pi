#!/bin/sh

sudo apt update
sudo apt upgrade -y

# Prevent display from sleeping
sudo tee -a /etc/xdg/lxsession/LXDE-pi/autostart > /dev/null << EOL
@xset s noblank
@xset s off
@xset -dpms
EOL
sudo tee -a /etc/lightdm/lightdm.conf > /dev/null << EOL
[Seat:*]
xserver-command=X -s 0 -dpms
EOL

# Set desktop background
DISPLAY=:0 pcmanfm --set-wallpaper="/home/pi/media-streaming-pi/img/coral-trout-and-buddy.jpg"

# Install mplayer for media playback
sudo apt install -y mplayer

# Create file for media playlist; default to Orpheus Island camera
echo 'https://streamvdr-cns01.jcu.edu.au:1935/eResearch/UnderwaterCam.stream/playlist.m3u8' > /home/pi/.media_playlist

# Set up systemd to run/restart the media stream
sudo cp -f media-autoplay.service /etc/systemd/system/
sudo systemctl daemon reload
sudo systemctl enable media-autoplay
sudo systemctl start media-autoplay
