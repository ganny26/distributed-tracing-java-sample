FROM openjdk:11-jre

ENV APP_HOME /app/bin

COPY ./build/payment-service-*.jar ${APP_HOME}/payment-service.jar
COPY ./scripts/start.sh ${APP_HOME}/
COPY ./agents/*.jar ${APP_HOME}/agents/
COPY ./in.txt ${APP_HOME}/in.txt

WORKDIR ${APP_HOME}
ENV PORT 8083
EXPOSE 8083
ENTRYPOINT [ "bash","./start.sh" ]