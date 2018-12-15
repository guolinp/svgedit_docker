FROM tomcat:9-jre8

#ENVIRONMENT VARIABLES CONFIGURATION
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp
ENV JRE_HOME /usr
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar


ADD https://github.com/SVG-Edit/svgedit/archive/v4.2.0.tar.gz /svgedit.tar.gz
RUN tar -zxvf /svgedit.tar.gz && mv svgedit-* /svgedit && rm -rf svgedit.tar.gz
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/webapps/ROOT && \
    ln -s /svgedit/editor/svg-editor.html /usr/local/tomcat/webapps/ROOT/index.html

# disable all file logging
ADD logging.properties /usr/local/tomcat/conf/logging.properties
RUN sed -i -e 's/Valve/Disabled/' /usr/local/tomcat/conf/server.xml

# add our scripts
ADD scripts /scripts
RUN chmod -R +x /scripts

# run
WORKDIR $CATALINA_HOME
EXPOSE 8080

CMD ["/scripts/start.sh"]
