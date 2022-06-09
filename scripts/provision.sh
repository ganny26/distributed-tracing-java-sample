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

# set up db container
sudo yum install -y postgresql
sudo docker run --name postgres -e POSTGRES_PASSWORD=admin -p 5432:5432 -d docker.io/library/postgres:latest

until [ "$(sudo docker inspect -f {{.State.Running}} postgres_db)" == "true" ]; do
    sleep 1;
    echo "."
done;



#ADVENTUREWORKS_DIR=/vagrant/misc/adventureworks
#if [ ! -d ADVENTUREWORKS_DIR ]; then
#  cd "/vagrant/misc/" || exit
#  git clone https://github.com/morenoh149/postgresDBSamples.git
#  mv postgresDBSamples/adventureworks adventureworks
#  rm -rf postgresDBSamples
#  cd -
#fi
#
#cd ${ADVENTUREWORKS_DIR} || exit
#DIR="data"
#if [ ! -d "$DIR" ]; then
#  unzip data.zip -d data
#fi
#PGPASSWORD=postgres psql -U postgres -h 0.0.0.0 -p 5432 -c "CREATE DATABASE \"Adventureworks\";"
#PGPASSWORD=postgres psql -U postgres -h 0.0.0.0 -p 5432 -d Adventureworks < ${ADVENTUREWORKS_DIR}/install.sql
#cd - || exit

# Install maven
sudo -y yum install maven
