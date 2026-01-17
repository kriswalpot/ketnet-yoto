#!/bin/bash
set -e

mkdir -p /var/www/hls

# Start nginx in background
nginx

# Convert Ketnet stream to HLS
# -hls_flags delete_segments keeps storage low
# -hls_time small segments helps devices start quicker
ffmpeg -hide_banner -loglevel warning \
  -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
  -i "http://icecast.vrtcdn.be/ketnetradio.aac" \
  -c:a copy \
  -f hls \
  -hls_time 4 \
  -hls_list_size 8 \
  -hls_flags delete_segments+append_list \
  -hls_segment_filename "/var/www/hls/seg_%05d.aac" \
  /var/www/hls/stream.m3u8

