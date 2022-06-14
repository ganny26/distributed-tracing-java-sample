#!/bin/bash

[ -z "$JAVA_XMS" ] && JAVA_XMS=512m
[ -z "$JAVA_XMX" ] && JAVA_XMX=512m

set -e

 JAVA_OPTS="${JAVA_OPTS} \
   -Xms${JAVA_XMS} \
   -Xmx${JAVA_XMX} \
   -Dotel.service.name=payment-service-java \
   -Dotel.traces.exporter=jaeger \
   -Dotel.exporter.jaeger.endpoint=http://some-place-over-the-rainbow:14250 \
   -javaagent:/app/bin/agents/opentelemetry-javaagent.jar"



exec java ${JAVA_OPTS} \
  -jar "/app/bin/payment-service.jar" \
