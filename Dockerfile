#FROM alpine
FROM egofelix/baseimage:debian

MAINTAINER EgoFelix <docker@egofelix.de>

# Install packages
RUN /root/package.sh openssh-client

# Install script
COPY unlocker.sh /unlocker.sh

# Cleanup
RUN /root/cleanup.sh

# Entry
ENTRYPOINT /unlocker.sh
