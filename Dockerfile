FROM alpine

MAINTAINER EgoFelix <docker@egofelix.de>

# Install packages
RUN apk --no-cache add \
    bash \
    openssh

# Install script
COPY unlocker.sh /unlocker.sh

# Entry
ENTRYPOINT /unlocker.sh
