#!/usr/bin/env bash

set -e

echo "🔄 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "📦 Instalando pacotes básicos..."
sudo apt install -y 
curl wget git unzip zip build-essential 
ca-certificates gnupg lsb-release software-properties-common

echo "✅ Sistema pronto"
