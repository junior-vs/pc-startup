#!/bin/bash

echo "Starting Fedora system update..."

# Refresh the package lists
echo "Refreshing package lists..."
dnf check-update

# Update all packages
echo "Updating all packages..."
dnf -y update

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"


dnf -y groupinstall "Development Tools"

dnf install -y \
		git \
    	curl \
    	vim \
    	unzip \
    	p7zip \
    	p7zip-plugins \
    	unrar \
    	snapd \
		podman \
		nodejs \
        neovim \
		elixir \
		erlang

ln -s /var/lib/snapd/snap /snap
# or code-insiders
snap install --classic code 
# or code-insiders
snap install kubectl --classic


