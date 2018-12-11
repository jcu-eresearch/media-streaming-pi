#!/bin/sh

# Add PPA for mpv
sudo add-apt-repository ppa:mc3man/mpv-tests

# Update system
sudo apt update
sudo apt upgrade -y

# Install mpv and pip for youtube-dl
sudo apt install -y mpv python-pip

# Install latest youtube-dl (package manager version is broken)
sudo pip install youtube-dl

# Create file for media playlist; default to Orpheus Island camera
echo 'https://streamvdr-cns01.jcu.edu.au:1935/eResearch/UnderwaterCam.stream/playlist.m3u8' > $HOME/.media_playlist

# Set up systemd to run/restart the media stream
sudo cp -f media-autoplay.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable media-autoplay
sudo systemctl start media-autoplay
