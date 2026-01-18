FROM alpine:3.19

RUN apk add --no-cache icecast ffmpeg bash

COPY icecast.xml /etc/icecast.xml
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
