#!/bin/bash

apt-get update -y
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

#Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Docker's official APT repository
add-apt-repository \
   "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"

#Install Docker and Docker Compose
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

#Start Docker
systemctl start docker
systemctl enable docker

echo "Docker and Docker Compose installed successfully."
