FROM openjdk:11-jre

ENV APP_HOME /app/bin

COPY ./target/user-service-*.jar ${APP_HOME}/user-service.jar
COPY ./scripts/start.sh ${APP_HOME}/
COPY ./agents/*.jar ${APP_HOME}/agents/

WORKDIR ${APP_HOME}
ENV PORT 8081
EXPOSE 8081
ENTRYPOINT [ "bash","./start.sh" ]
