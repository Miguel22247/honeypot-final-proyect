#!/bin/bash
# Cowrie Honeypot Setup Script (Docker Version)
# Author: Miguel Pacheco y Rolando Quiroz
# Date: September 2025

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/messages.sh"


print_status "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    print_status "Docker not found. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    print_status "Docker installed."
else
    print_status "Docker is already installed."
fi

print_status "Pulling Cowrie Docker image..."
if ! sudo docker image inspect cowrie/cowrie:latest &> /dev/null; then
    sudo docker pull cowrie/cowrie:latest
    print_status "Cowrie Docker image pulled."
else
    print_status "Cowrie Docker image already present."
fi

print_status "Creating persistent data directory for Cowrie..."
mkdir -p ~/cowrie-docker-data
print_status "Data directory: ~/cowrie-docker-data"

print_status "Starting Cowrie container..."
sudo docker run -d \
  --name cowrie \
  -p 2222:2222 \
  -p 2323:2323 \
  -v ~/cowrie-docker-data:/cowrie/cowrie-docker-data \
  cowrie/cowrie:latest

show_completion_banner
print_status "SSH honeypot: port 2222 | Telnet honeypot: port 2323"
print_status "Cowrie data directory: ~/cowrie-docker-data"