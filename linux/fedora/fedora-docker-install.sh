#!/bin/bash

# Docker Installation Script for Fedora
# Run this script with sudo

echo "Starting Docker installation on Fedora..."

# Update the system
dnf update -y

dnf remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine


# Install required packages
dnf install -y dnf-plugins-core

# Add Docker repository
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
systemctl start docker
systemctl enable docker.service
systemctl enable containerd.service

# Add current user to docker group (to run docker without sudo)
groupadd docker
usermod -aG docker $USER
newgrp docker



echo "Docker installation completed."
echo "Please log out and log back in for group changes to take effect."
echo "You can verify the installation by running: docker --version"
