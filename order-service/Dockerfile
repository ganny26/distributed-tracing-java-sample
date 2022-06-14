FROM openjdk:11-jre

ENV APP_HOME /app/bin

COPY ./target/order-service-*.jar ${APP_HOME}/order-service.jar
COPY ./scripts/start.sh ${APP_HOME}/
COPY ./agents/*.jar ${APP_HOME}/agents/
COPY ./in.txt ${APP_HOME}/in.txt

WORKDIR ${APP_HOME}
ENV PORT 8082
EXPOSE 8082
ENTRYPOINT [ "bash","./start.sh" ]