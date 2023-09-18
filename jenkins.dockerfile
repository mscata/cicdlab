FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install -y lsb-release \
  && curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg \
  && echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
  && apt-get update && apt-get install -y docker-ce-cli \
  && curl -LO https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz \
  && tar -xvf apache-maven-3.9.4-bin.tar.gz && mv apache-maven-3.9.4 /opt/ && rm -f apache-maven-3.9.4-bin.tar.gz \
  && curl -LO https://github.com/liquibase/liquibase/releases/latest/download/liquibase-4.23.2.tar.gz \
  && mkdir liquibase-4.23.2 && tar -xvf liquibase-4.23.2.tar.gz -C ./liquibase-4.23.2 \
  && mv liquibase-4.23.2 /opt/ && rm -f liquibase-4.23.2.tar.gz \
  && curl -LO https://services.gradle.org/distributions/gradle-8.3-bin.zip \
  && unzip gradle-8.3-bin.zip && mv gradle-8.3 /opt/ && rm -f gradle-8.3-bin.zip \
  && curl -LO https://github.com/jeremylong/DependencyCheck/releases/download/v8.4.0/dependency-check-8.4.0-release.zip \
  && unzip dependency-check-8.4.0-release.zip && mv dependency-check /opt/ && rm -f dependency-check-8.4.0-release.zip

USER jenkins

COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
