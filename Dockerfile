FROM alpine:3.21.2

RUN apk add dante-server
RUN apk add openconnect

COPY sockd.conf /etc/
COPY connect.sh /usr/bin
