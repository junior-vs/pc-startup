#!/usr/bin/env bash

set -e

echo "🔍 Instalando ferramentas modernas..."

sudo apt install -y 
bat 
fd-find 
ripgrep 
fzf 
htop 
jq

# alias para fd (ubuntu usa fdfind)

echo "alias fd=fdfind" >> ~/.zshrc

echo "✅ CLI tools instaladas"
