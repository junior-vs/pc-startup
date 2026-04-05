#!/usr/bin/env bash

set -e

echo "🐚 Instalando Zsh..."
sudo apt install -y zsh

echo "✨ Instalando Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "🚀 Instalando Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo 'eval "$(starship init zsh)"' >> ~/.zshrc

chsh -s $(which zsh)

echo "✅ Shell configurado"
