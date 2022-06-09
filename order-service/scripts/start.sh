#!/bin/bash

[ -z "$JAVA_XMS" ] && JAVA_XMS=512m
[ -z "$JAVA_XMX" ] && JAVA_XMX=512m

set -e

 JAVA_OPTS="${JAVA_OPTS} \
   -Xms${JAVA_XMS} \
   -Xmx${JAVA_XMX} \
   -Dotel.service.name=order-service-java \
   -Dotel.traces.exporter=jaeger \
   -Dotel.exporter.jaeger.endpoint=http://localhost:14250 \
   -javaagent:../agents/opentelemetry-javaagent.jar"



exec java ${JAVA_OPTS} \
  -jar "../target/order-service-0.0.1-SNAPSHOT.jar" \
