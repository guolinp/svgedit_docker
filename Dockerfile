FROM tomcat:9-jre8

#ENVIRONMENT VARIABLES CONFIGURATION
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp
ENV JRE_HOME /usr
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar

RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/webapps/ROOT

ADD https://github.com/SVG-Edit/svgedit/archive/v4.2.0.tar.gz /svgedit.tar.gz
RUN tar -zxvf /svgedit.tar.gz && \
    rm -rf /svgedit.tar.gz && \
    mv svgedit-* /usr/local/tomcat/webapps/ROOT/svgedit

# disable all file logging
ADD logging.properties /usr/local/tomcat/conf/logging.properties
ADD index.html /usr/local/tomcat/webapps/ROOT/index.html
RUN sed -i -e 's/Valve/Disabled/' /usr/local/tomcat/conf/server.xml

# add our scripts
ADD scripts /scripts
RUN chmod -R +x /scripts

# run
WORKDIR $CATALINA_HOME
EXPOSE 8080

CMD ["/scripts/start.sh"]
