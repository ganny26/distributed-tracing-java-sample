#!/bin/bash

set -ox pipefail
cd /vagrant || exit

cd discovery-server
sudo docker stop discovery-service || true
sudo docker rm discovery-service || true
mvn clean install -Dmaven.test.skip
docker build -t discovery-service .
docker run -d --name discovery-service --network host -p 8761:8761 discovery-service
cd -

cd user-service || exit
sudo docker stop user-service || true
sudo docker rm user-service || true
mvn clean install -Dmaven.test.skip
sudo docker build -t user-service .
sudo docker run -d --network host --name user-service user-service
cd -

cd order-service || exit
sudo docker stop order-service || true
sudo docker rm order-service || true
mvn clean install -Dmaven.test.skip
sudo docker build -t order-service .
sudo docker run -d --network host --name order-service order-service
cd -

cd payment-service || exit
sudo docker stop payment-service || true
sudo docker rm payment-service || true
mvn clean install -Dmaven.test.skip
sudo docker build -t payment-service .
sudo docker run -d --network host --name payment-service payment-service
cd -

sudo npm install -g serve
serve -l 9090 ui > /dev/null 2>&1
