#!/bin/bash
# Cowrie Honeypot Setup Script (Docker Version)
# Author: Honeypot Security Team
# Date: September 2025

set -e

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# Pull Cowrie Docker image
if ! docker image inspect cowrie/cowrie:latest &> /dev/null; then
    echo "Pulling Cowrie Docker image..."
    docker pull cowrie/cowrie:latest
fi

# Create Cowrie data directory
mkdir -p ~/cowrie-docker-data

# Run Cowrie container
# Expose SSH (2222) and Telnet (2323) ports
# Mount persistent data volume

docker run -d \
  --name cowrie \
  -p 2222:2222 \
  -p 2323:2323 \
  -v ~/cowrie-docker-data:/cowrie/cowrie-docker-data \
  cowrie/cowrie:latest

echo "Cowrie honeypot is running in Docker!"
echo "SSH honeypot: port 2222 | Telnet honeypot: port 2323"
echo "Cowrie data directory: ~/cowrie-docker-data"
