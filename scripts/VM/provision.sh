#!/bin/bash

set -ox pipefail
cd /vagrant || exit

# Create file to encrypt
python3 fill_file.py

sudo yum -y install vim git wget

# Install docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker./

# Install Java 11
sudo yum -y install java-11-openjdk

sudo systemctl start docker
sudo docker network create -d bridge hermes


# set up db container
sudo yum install -y postgresql
sudo docker run --name postgres --network=hermes -e POSTGRES_PASSWORD=admin -p 5432:5432 -d docker.io/library/postgres:latest

until [ "$(sudo docker inspect -f {{.State.Running}} postgres)" == "true" ]; do
    sleep 1;
    echo "."
done;

# Install maven
sudo yum -y install maven
sudo yum -y install npm