# NOTE: Users must mount the Spring config file to /config/application.yml.

FROM openjdk:11-jre

ENV APP_HOME /app/bin

COPY ./target/discovery-server-*.jar ${APP_HOME}/discovery-server.jar
COPY ./scripts/start.sh ${APP_HOME}/

WORKDIR ${APP_HOME}
ENV PORT 8761
EXPOSE 8761
ENTRYPOINT [ "bash","./start.sh" ]
