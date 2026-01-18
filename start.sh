#!/bin/bash
set -e

# start icecast in background
icecast -c /etc/icecast.xml &
sleep 2

# feed Ketnet into icecast as MP3
# (re-encode to constant MP3 because many embedded players behave better)
while true; do
  echo "Starting ffmpeg source -> icecast..."
  ffmpeg -hide_banner -loglevel warning \
    -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
    -i "http://icecast.vrtcdn.be/ketnetradio.aac" \
    -vn -c:a libmp3lame -b:a 128k -ar 44100 -ac 2 \
    -content_type audio/mpeg \
    -f mp3 "icecast://source:sourcepass@127.0.0.1:8080/ketnet.mp3" || true
  echo "ffmpeg exited; restarting in 2s..."
  sleep 2
done
