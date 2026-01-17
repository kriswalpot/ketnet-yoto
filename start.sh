#!/bin/bash
set -e

mkdir -p /var/www/hls

# Start ffmpeg in a restart loop so it can't "die quietly"
(
  while true; do
    echo "Starting ffmpeg -> HLS…"
ffmpeg -hide_banner -loglevel warning \
  -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
  -i "http://icecast.vrtcdn.be/ketnetradio.aac" \
  -c:a copy \
  -f hls \
  -hls_time 4 \
  -hls_list_size 8 \
  -hls_flags delete_segments+append_list \
  -hls_segment_filename "/var/www/hls/seg_%05d.ts" \
  /var/www/hls/stream.m3u8

    echo "ffmpeg exited; restarting in 2s…"
    sleep 2
  done
) &

# Run nginx in the foreground (Render expects one foreground process)
nginx -g 'daemon off;'
