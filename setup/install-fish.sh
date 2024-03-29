#!/bin/bash

# From https://gist.github.com/Brandonshire/73098f982d00d13ddf93a8d484160da2

# This is a quick installer
# script I made to build and install the latest version of
# fish on my Raspberry Pi.
#
# Use at your own risk as I have made no effort to make
# this install safe!

set -e

FISH_VERSION="3.3.1"

# Install dependencies
sudo apt-get install build-essential cmake ncurses-dev libncurses5-dev libpcre2-dev gettext

# Create a build directory
mkdir fish-install
cd fish-install

# Download and extract the latest build (could clone from git but that's less stable)
wget https://github.com/fish-shell/fish-shell/releases/download/$FISH_VERSION/fish-$FISH_VERSION.tar.xz
tar -xvf fish-$FISH_VERSION.tar.xz
cd fish-$FISH_VERSION

# Build and install
cmake .
make
sudo make install

# Add to shells
echo /usr/local/bin/fish | sudo tee -a /etc/shells

# Set as user's shell
chsh -s /usr/local/bin/fish

# Delete build directory
cd ../../
rm -rf fish-install