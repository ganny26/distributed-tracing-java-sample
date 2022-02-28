#!/bin/bash

[ -z "$JAVA_XMS" ] && JAVA_XMS=512m
[ -z "$JAVA_XMX" ] && JAVA_XMX=512m

set -e

 JAVA_OPTS="${JAVA_OPTS} \
   -Xms${JAVA_XMS} \
   -Xmx${JAVA_XMX} \
   -Dapplication.name=order-service-java \
   -Dotel.metrics.exporter=none \
   -Dotel.traces.exporter=otlp \
   -Dotel.resource.attributes=service.name=order-service-java \
   -Dotel.exporter.otlp.traces.endpoint=http://localhost:4317 \
   -Dotel.service.name=order-service-java \
   -Dotel.javaagent.debug=false \
   -javaagent:../agents/opentelemetry-javaagent.jar"



exec java ${JAVA_OPTS} \
  -jar "../target/order-service-0.0.1-SNAPSHOT.jar" \
