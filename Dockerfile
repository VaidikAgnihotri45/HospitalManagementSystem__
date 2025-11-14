FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openjdk-11-jdk ant wget unzip tomcat9 tomcat9-admin mariadb-server supervisor git && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/app
COPY . /opt/app
RUN if [ -f build.xml ]; then ant -f build.xml || true; fi
RUN set -e; WAR_FILE=$(find /opt/app -maxdepth 3 -type f -name '*.war' | head -n 1 || true); \
    if [ -n "$WAR_FILE" ]; then cp "$WAR_FILE" /var/lib/tomcat9/webapps/ROOT.war; \
    else rm -rf /var/lib/tomcat9/webapps/ROOT; mkdir -p /var/lib/tomcat9/webapps/ROOT; cp -r /opt/app/web/* /var/lib/tomcat9/webapps/ROOT/ || true; fi
COPY hospital.sql /tmp/hospital.sql
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY wait-for-mysql.sh /opt/app/wait-for-mysql.sh
COPY mysql-init.sh /opt/app/mysql-init.sh
RUN chmod +x /opt/app/wait-for-mysql.sh /opt/app/mysql-init.sh
EXPOSE 8080
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
