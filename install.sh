#!/bin/sh

sudo apt update
sudo apt upgrade -y

# Set up automatic updates
sudo apt install -y unattended-upgrades

# Compile hardware accelerated mpv
# As at Nov 2018, mplayer and mpv in Raspbian Stretch currently lack
# hardware acceleration for the Pi. omxplayer works, but it struggles
# with HLS feeds. It also lacks detailed playback options like playlists
# or detailed control of display/playback.

#autoconf/autotools (for libass)
#sudo apt-get install -y gperf bison flex automake texinfo help2man ncurses-dev mercurial cmake cmake-curses-gui checkinstall 

sudo apt install -y \
    make \
    automake \
    autoconf \
    checkinstall \
    libtool-bin \
    git \
    yasm \
    texinfo \
    xdotool \
    libvdpau-dev \
    libasound2-dev \
    libpulse-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libjpeg-dev \
    libx264-dev \
    libmp3lame-dev \
    libtheora-dev \
    libvorbis-dev \
    libgnutls28-dev \
    gnutls-dev \
    libgl1-mesa-dev \
    libgles2-mesa-dev \
    libsmbclient-dev \
    libbluray-dev \
    libdvdread-dev \
    libdvdnav-dev \
    libluajit-5.1-dev \
    libv4l-dev \
    libcdio-cdda-dev \
    libcdio-paranoia-dev \
    libomxil-bellagio-dev \
    libsdl2-dev \
    libva-dev \
    libxcb-shm0-dev

# Manually get the AAC codec; it isn't available in Raspbian's repos
wget http://http.us.debian.org/debian/pool/non-free/f/fdk-aac/libfdk-aac-dev_0.1.4-2+b1_armhf.deb
wget http://http.us.debian.org/debian/pool/non-free/f/fdk-aac/libfdk-aac1_0.1.4-2+b1_armhf.deb
sudo dpkg -i *.deb
rm libfdk-aac*.deb

git clone https://github.com/mpv-player/mpv-build.git ~/mpv-build
cd ~/mpv-build
echo --enable-mmal >> ffmpeg_options
echo --enable-libx264 >> ffmpeg_options
echo --enable-libmp3lame >> ffmpeg_options
echo --enable-nonfree >> ffmpeg_options
echo --enable-libfdk-aac >> ffmpeg_options
./use-mpv-release
./update
LIBRARY_PATH=/opt/vc/lib ./rebuild -j4
sudo ./install

# Link config for mpv
ln -s $PWD/mpv.conf $HOME/.config/mpv/

# Install latest youtube-dl (package manager version is broken)
sudo pip install -U youtube-dl

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

# Create file for media playlist; default to Orpheus Island camera
echo 'https://jcu.io/video/orpheus-island-pioneer-bay-underwater' > /home/pi/.media_playlist

# Set up systemd to run/restart the media stream
sudo cp -f media-autoplay.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable media-autoplay
sudo systemctl start media-autoplay

# Install user's crontab from the file
# Restart the stream every morning in case of overnight freeze
crontab -u pi pi.crontab
