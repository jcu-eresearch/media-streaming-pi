# Auto-media streaming via Raspberry Pi

## Features

* Auto-plays media streams or files via `mplayer` on boot
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

## Usage

Under the hood, this configuration uses
[mplayer](https://mplayerhq.hu/DOCS/man/en/mplayer.1.html) and will play back
any file, URL or source that it can on a Raspberry Pi.  We are primarily using
this to playback media streams on HLS/RTSP but playing back file-based content
should work just as well.  Mplayer's software scaling is slow so we don't
offer scaling of video content to fit your display size; in other words, make
your content fit your display (eg 1080p).

The media stream will start playing automatically after desktop login or
installation and will restart automatically if the media ends or dies for any
reason.  For media streams, this means it will automatically attempt to resume
on network failure and for file locations, it will.

### Setting a source

By default, we use a known good stream (the MARF tank camera) but it's easy to
set your own playback source.

To configure which source to play back automatically, add
mplayer-compatible locations to this text file, one source per line:

    /home/pi/.media_playlist

The sources will be played back in order.  Valid sources include file
locations (eg `/home/pi/big-buck-bunny.mp4`, camera streams like
`rtsp://camera1.example.com/feed`, web locations like
`https://example.com/big-buck-bunny.mp4` and so on).  If playing back a file,
ensure the file is actually present on the Pi's filesystem.

Note that if you play a stream that is never-ending (such as a camera or TV
feed), playlist items after that entry will never be reached as mplayer
treats the looping option we pass it as an instruction to automatically
reconnect to live streams.

### Customising options

To configure options on how mplayer plays back media, consult the man
page above and then edit the script at `playback.sh`, ensuring that the mplayer
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
Ctrl+Alt+F7.  Alternatively, you can SSH in over the network or if you don't
know the password, you can attach a keyboard, hit Escape to kill mplayer and
then quickly start a terminal and run the command above before mplayer is
auto-restarted.
