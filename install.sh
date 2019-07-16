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
echo 'https://jcu.io/video/orpheus-island-pioneer-bay-underwater' > $HOME/.media_playlist

# Set up systemd to run/restart the media stream
sudo cp -f media-autoplay.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable media-autoplay
sudo systemctl start media-autoplay

# Remove automatic popup for updates; it appears over the video
sudo apt remove -y update-manager
