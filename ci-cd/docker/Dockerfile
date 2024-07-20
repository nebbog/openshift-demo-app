FROM tomcat:9.0.64-jdk8

MAINTAINER Mobinets DevOps "integration@mobinets.com"


RUN addgroup --gid 1000 nep
RUN adduser -u 1000 --gid 1000 --no-create-home nep

RUN chown -R nep $CATALINA_HOME

COPY --chown=nep:nep target/demo-app $CATALINA_HOME/webapps/demo-app
USER nep

EXPOSE 8080

CMD ["catalina.sh", "run"]
