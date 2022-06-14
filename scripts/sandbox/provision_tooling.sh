#!/bin/bash

set -e

export KAFKA_TOPIC_NAME_OTEL=hermes_otel
export KAFKA_VERSION=kafka_2.13-3.1.0
export SPARK_RELEASE=spark-3.2.1-bin-hadoop3.2
export ELASTIC_RELEASE=7.17.2
export PROMETHEUS_VERSION=2.35.0
export HOST_ARCH=linux-arm64
export HOST_ADDR=$(hostname --all-ip-address|cut -d ' ' -f1)
export JAVA8_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export HOST_ADDR

# Note we use nerdctl in the sandbox
alias docker='sudo nerdctl'


# Install Java 11
sudo yum -y install java-11-openjdk

# Install kafka as root in /opt
cd ${HOME} || exit 1

# Check if kafka already in home dir
if [ ! -d kafka ]; then
  echo "Installing kafka in $(pwd)/kafka ..."
  wget https://dlcdn.apache.org/kafka/3.1.0/${KAFKA_VERSION}.tgz
  tar -zxvf kafka_*
  rm -rf *.tgz
  mv ${KAFKA_VERSION} kafka

  tee -a kafka/config/server.properties <<EOF
advertised.listeners=PLAINTEXT://${HOST_ADDR}:9092
listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
EOF
else
  echo "Kafka already installed in $(pwd)/kafka."
fi

# TODO create standard kafka config
echo "Starting kafka..."
cd kafka || exit 1
${HOME}/kafka/bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
${HOME}/kafka/bin/kafka-server-start.sh -daemon config/server.properties
${HOME}/kafka/bin/kafka-topics.sh --create --topic hermes_otel --bootstrap-server localhost:9092 --if-not-exists

echo "Starting Jaeger containers (collector)..."

docker run --name jaeger-collector \
  -d \
  --network=host \
  -e KAFKA_PRODUCER_BROKERS=${HOST_ADDR}:9092 \
  -e KAFKA_PRODUCER_TOPIC=${KAFKA_TOPIC_NAME_OTEL} \
  -e SPAN_STORAGE_TYPE=kafka \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/jaeger-collector:1.33

docker run --name jaeger-agent \
  -d \
  --network=host \
  --name jaeger-agent \
  -p6831:6831/udp \
  -p6832:6832/udp \
  -p5778:5778/tcp \
  -p5775:5775/udp \
  jaegertracing/jaeger-agent:1.33 \
  --reporter.grpc.host-port=${HOST_ADDR}:14250

echo "Setting up elasticsearch..."
# TODO has to be changed systemwide (/etc/sysctl.conf)
sudo sysctl -w vm.max_map_count=262144
export ELASTIC_RELEASE=7.17.2
# TODO enable TLS Certificates etc.
docker run --name elastic-01 \
 -d \
 --network=host \
 -e "xpack.security.http.ssl.enabled=false" \
 -e "xpack.security.enabled=false" \
 -e "discovery.type=single-node" \
 -p 9200:9200 \
 -p 9300:9300 \
 docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_RELEASE}

printf 'Good morning to elasticsearch...'
while ! curl --silent --fail http://localhost:9200 | grep -q 'You Know, for Search'; do
    printf '.'
    sleep 1
done


echo "Starting jaeger ingester and query UI(attached to Kafka)"
docker run --name jaeger-ingester \
  -d \
  --network=host \
  -e SPAN_STORAGE_TYPE=elasticsearch \
  -e ES_SERVER_URLS=http://${HOST_ADDR}:9200 \
  -e LOG_LEVEL=info \
  -e INGESTER_PARALLELISM=1000 \
  -e INGESTER_DEADLOCKINTERVAL=0ms \
  -e SPAN_STORAGE_TYPE=elasticsearch \
  -e KAFKA_CONSUMER_BROKERS=${HOST_ADDR}:9092 \
  -e KAFKA_CONSUMER_TOPIC=${KAFKA_TOPIC_NAME_OTEL} \
  jaegertracing/jaeger-ingester


docker run --name jaeger-query \
  -d \
  --network=host \
  -p 16686:16686 \
  -p 16687:16687 \
  -e SPAN_STORAGE_TYPE=elasticsearch \
  -e ES_SERVER_URLS=http://${HOST_ADDR}:9200 \
  jaegertracing/jaeger-query:1.33

echo "Starting Kibana..."
docker run --name kibana-01 \
  -d \
  --network=host \
  -e ELASTICSEARCH_HOSTS=http://${HOST_ADDR}:9200 \
  -p 5601:5601 \
  docker.elastic.co/kibana/kibana:${ELASTIC_RELEASE}


#TODO investigate service do not use sentenforce
sudo setenforce 0

## Data processing stuff with pyspark
echo "Installing pyspark..."
sudo dnf -y install python3-devel python3-pip
sudo pip3 install -U virtualenv  # system-wide install
sudo pip3 install jupyterlab # system-wide install


echo "Installing Jupyter (as daemon)... "
sudo tee -a /lib/systemd/system/jupyter.service <<EOF
# service name:     jupyter.service
# path:             /lib/systemd/system/jupyter.service

[Unit]
Description=Jupyter Notebook Server

[Service]
Type=simple
PIDFile=/run/jupyter.pid

ExecStart=/usr/bin/env jupyter lab --ip=0.0.0.0 --LabApp.token=''

User=vagrant
Group=vagrant
WorkingDirectory=/vagrant/data
Restart=always
RestartSec=10
#KillMode=mixed

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl enable jupyter.service
sudo systemctl daemon-reload
sudo systemctl restart jupyter.service


# Download spark
echo "Installing spark..."
cd /home/vagrant || exit 1

wget https://dlcdn.apache.org/spark/spark-3.2.1/${SPARK_RELEASE}.tgz
tar xvf ${SPARK_RELEASE}.tgz
rm -rf ${SPARK_RELEASE}.tgz
mv ${SPARK_RELEASE} spark
cd spark || exit 1

sudo tee -a /home/vagrant/.bash_profile <<EOF
export SPARK_HOME=$(pwd)
export PYTHONPATH=$(ZIPS=("$SPARK_HOME"/python/lib/*.zip); IFS=:; echo "${ZIPS[*]}"):$PYTHONPATH
EOF
source /home/vagrant/.bash_profile

# Install scala and spylon kernel (for jupyter)
# Note that the version of spark/scala are very specific in order to work with elasticsearch
wget https://downloads.lightbend.com/scala/2.12.15/scala-2.12.15.rpm
sudo yum -y install scala-2.12.15.rpm
pip3 install toree
jupyter toree install --user --kernel_name toree --spark_home=/home/vagrant/spark/


# Install prometheus as daemon
echo "Installing prometheus..."
cd ${HOME}
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${HOST_ARCH}.tar.gz
tar -xvzf prometheus-${PROMETHEUS_VERSION}.${HOST_ARCH}.tar.gz
sudo ln -s prometheus-${PROMETHEUS_VERSION}.${HOST_ARCH} ${HOME}/prometheus

sudo tee -a /lib/systemd/system/prometheus.service <<EOF
# service name:     node_exporter.service
# path:             /lib/systemd/system/prometheus.service

[Unit]
Description=Prometheus server

[Service]
Type=simple
PIDFile=/run/prometheus

ExecStart=${HOME}/prometheus/prometheus \
--config.file ${HOME}/prometheus.yml

User=vagrant
Group=vagrant
WorkingDirectory=/home/vagrant
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

tee -a ${HOME}/prometheus.yml <<EOF
scrape_configs:
  - job_name: "Node Exporter"
    static_configs:
      - targets: ["localhost:9100"]
remote_write:
    - url: "localhost:9200/write"
    - tls_config:
        insecure_skip_verify: true
EOF

sudo systemctl daemon-reload
sudo systemctl start prometheus


# Set up metricbeat (for exporting prom metrics to ES)
sudo tee -a ${HOME}/metricbeat.docker.yml <<EOF
metricbeat.config:
  modules:
    path: \${path.config}/modules.d/*.yml
    # Reload module configs as they change:
    reload.enabled: true

metricbeat.modules:
  - module: prometheus
    metricsets: [ "remote_write" ]
    host: "localhost"
    port: "9200"

processors:
  - add_cloud_metadata: ~

output.elasticsearch:
  hosts: 'localhost:9200'
EOF

sudo docker run -d \
--name=metricbeat \
--user=root \
--network="host" \
--volume="${HOME}/metricbeat.docker.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
--volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
--volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
--volume="/proc:/hostfs/proc:ro" \
--volume="/:/hostfs:ro" \
docker.elastic.co/beats/metricbeat:7.17.2 metricbeat -e \
-E output.elasticsearch.hosts=["localhost:9200"]


#https://www.elastic.co/guide/en/beats/metricbeat/current/running-on-docker.html

# Run grafana
sudo docker run -d -p 3000:3000 grafana/grafana-enterprise



