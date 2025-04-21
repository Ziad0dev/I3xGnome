FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/n3ros/i3-gnome-fork"
LABEL org.opencontainers.image.description="i3 window manager with GNOME integration"
LABEL org.opencontainers.image.licenses="MIT"

# Install dependencies
RUN apt-get update && apt-get install -y \
    i3 \
    gnome-session \
    gnome-settings-daemon \
    dbus-x11 \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy i3-gnome files
COPY . /tmp/i3-gnome-build/

# Install i3-gnome
RUN cd /tmp/i3-gnome-build && \
    make install && \
    rm -rf /tmp/i3-gnome-build

# Set entrypoint
ENTRYPOINT ["/usr/bin/gnome-session-i3"] 