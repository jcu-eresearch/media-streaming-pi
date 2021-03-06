# Auto-media streaming via Raspberry Pi

## Features

* Builds a hardware-accelerated version of `mpv` media player
  for the Raspberry Pi
* Auto-plays media streams or files via `mpv` on boot
* Plays a custom text-based playlist of files or video streams or any other
  sources
* Auto-loops on finishing playback
* Auto-resumes media streams on network or other failure
* Provides `systemd` service for controlling media playback remotely
* Customises the desktop background
* Prevents the display from sleeping

## Install

```bash
git clone https://github.com/jcu-eresearch/media-streaming-pi.git
cd media-streaming-pi
./install.sh
```

See how to set media sources below.

This has been tested with a Raspberry Pi 3 Model B Plus running Raspbian but
should work on all models; your performance may suffer on earlier models
depending on what videos you are playing back.

## Usage

Under the hood, this configuration uses
[mpv](https://mpv.io/manual/master/) and will play back
any file, URL or source that it can on a Raspberry Pi.  We are primarily using
this to playback media streams on HLS/RTSP but playing back file-based content
should work just as well (including YouTube).  The best playback results from
having content fit your display size; in other words, make
your content fit your display (eg 1080p) and it needs to be a format that is
compatible with Pi hardware acceleration (eg
[MMAL](https://github.com/techyian/MMALSharp/wiki/What-is-MMAL%3F)).

The media stream will start playing automatically after desktop login or
installation and will restart automatically if the media ends or dies for any
reason.  For media streams, this means it will automatically attempt to resume
on network failure and for file locations, it will.

### Setting a source

By default, we use a known good stream (the Orpheus Island underwater camera)
but it's easy to set your own playback sources.

To configure which source to play back automatically, add
`mpv`-compatible locations to this text file, one source per line:

    /home/pi/.media_playlist

The sources will be played back in order.  Valid sources include file
locations (eg `/home/pi/big-buck-bunny.mp4`, camera streams like
`rtsp://camera1.example.com/feed`, web locations like
`https://example.com/big-buck-bunny.mp4` and so on).  If playing back a file,
ensure the file is actually present on the Pi's filesystem.

### Customising options

To configure options on how `mpv` plays back media, consult the man
page above and then edit the script at `playback.sh`, ensuring that the
command remains running in the foreground as the last line.

### Starting and stopping

If you want to use the Raspberry Pi temporarily without having the media
playing, you can control the playback via `systemctl`.

To stop the playback, stop the service:

    sudo systemctl stop media-autoplay

To start it again, do the following:

    sudo systemctl start media-autoplay

If you are interactively using a keyboard and mouse with the Pi and need to
get to a terminal, use Ctrl+Alt+F1 to switch to to a different TTY, login and
then issue the relevant command and switch back to the X Server TTY with
Ctrl+Alt+F7.  Alternatively, you can SSH in over the network and stop the
service that way.

## Backups

If you want to backup the whole microSD card image, you can do the following:

    hdiutil create -srcdevice /dev/rdisk2 -format ULMO media-stream-pi.dmg

where `/dev/rdisk2` is the raw disk device on your macOS terminal as obtained
from the output of the command `diskutil list`.
