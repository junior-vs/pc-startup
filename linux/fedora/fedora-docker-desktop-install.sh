#!/bin/bash

# Docker Desktop Installation Script for Fedora
# Run this script with sudo

echo "Starting Docker Desktop installation on Fedora..."

# Determine system architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        DOCKER_ARCH="x86_64"
        ;;
    aarch64)
        DOCKER_ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# URL for the latest Docker Desktop RPM
DOCKER_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-4.25.0-x86_64.rpm"

# Download Docker Desktop RPM
echo "Downloading Docker Desktop..."
wget $DOCKER_URL -O docker-desktop.rpm

if [ $? -ne 0 ]; then
    echo "Failed to download Docker Desktop. Please check your internet connection and try again."
    exit 1
fi

# Install Docker Desktop
echo "Installing Docker Desktop..."
dnf install -y ./docker-desktop.rpm

if [ $? -ne 0 ]; then
    echo "Failed to install Docker Desktop. Please check the error messages above."
    exit 1
fi

# Clean up downloaded file
rm docker-desktop.rpm

echo "Docker Desktop installation completed."
echo "You may need to log out and log back in for the installation to take full effect."
echo "To start Docker Desktop, search for it in your applications menu or run: systemctl --user start docker-desktop"
