#!/bin/bash

sudo yum -y install \
            vim


sudo yum -y install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

--env HTTP_PROXY=http://sandboxproxy.am4o.adyen.com:3128 --env HTTPS_PROXY=http://sandboxproxy.am4o.adyen.com:3128