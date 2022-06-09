#!/bin/bash

set -ox pipefail
cd /vagrant || exit

cd user-service
mvn clean install -Dmaven.test.skip
sh ./scripts/start.sh
cd -

cd user-service
mvn clean install -Dmaven.test.skip
sh ./scripts/start.sh
cd -

cd order-service
mvn clean install -Dmaven.test.skip
sh ./scripts/start.sh
cd -

cd payment-service
mvn clean install -Dmaven.test.skip
sh ./scripts/start.sh
cd -

sudo npm install -g serve
serve -l 9090 ui
