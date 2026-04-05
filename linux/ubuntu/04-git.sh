#!/usr/bin/env bash

set -e

echo "🔧 Instalando Git..."
sudo apt install -y git

echo "🎨 Instalando Git Delta..."
sudo apt install -y git-delta || true

git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"

git config --global delta.navigate true
git config --global delta.light false

echo "✅ Git configurado"
