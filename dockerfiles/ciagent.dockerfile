ARG JENKINS_IMG=jenkins/agent:jdk17

FROM $JENKINS_IMG

ARG MAVEN_VERSION=3.9.4
ARG LIQUIBASE_VERSION=4.26.0
ARG GRADLE_VERSION=8.3
ARG DEPENDENCYCHECK_VERSION=9.2.0
ARG NODEJS_VERSION=20
ARG NVM_VERSION=0.39.7
ARG NVD_API_KEY= # get one from https://nvd.nist.gov/developers/request-an-api-key

ENV TOOLS_HOME=/home/jenkins/tools

COPY --chown=jenkins:jenkins ../setup/jenkins /home/jenkins/setup

USER root

RUN apt-get update \
  && apt-get install -y lsb-release apt-utils sudo zip unzip \
  python3 python3-pip python3-venv python3-build twine \
  && curl -fsSL https://get.docker.com | sh \
  && mkdir -p $TOOLS_HOME && chown jenkins:jenkins $TOOLS_HOME

RUN usermod -aG docker jenkins

USER jenkins

RUN echo "Downloading Maven $MAVEN_VERSION" \
  && curl -LO https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && echo "Unpacking..." \
  && tar -xf apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && echo "Installing..." \
  && mv apache-maven-$MAVEN_VERSION $TOOLS_HOME/ \
  && echo "Cleaning up..." \
  && rm -f apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && mkdir -p /home/jenkins/.m2 \
  && cp /home/jenkins/setup/maven-settings.xml /home/jenkins/.m2/settings.xml

RUN echo "Downloading Liquibase $LIQUIBASE_VERSION" \
  && curl -LO https://github.com/liquibase/liquibase/releases/download/v$LIQUIBASE_VERSION/liquibase-$LIQUIBASE_VERSION.tar.gz \
  && mkdir liquibase-$LIQUIBASE_VERSION \
  && echo "Unpacking..." \
  && tar -xf liquibase-$LIQUIBASE_VERSION.tar.gz -C ./liquibase-$LIQUIBASE_VERSION \
  && echo "Installing..." \
  && mv liquibase-$LIQUIBASE_VERSION $TOOLS_HOME/ \
  && echo "Cleaning up..." \
  && rm -f liquibase-$LIQUIBASE_VERSION.tar.gz 

RUN echo "Downloading Gradle $GRADLE_VERSION" \
  && curl -LO https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
  && echo "Unpacking..." \
  && unzip -q gradle-$GRADLE_VERSION-bin.zip \
  && echo "Installing..." \
  && mv gradle-$GRADLE_VERSION $TOOLS_HOME/ \
  && echo "Cleaning up..." \
  && rm -f gradle-$GRADLE_VERSION-bin.zip 
  
RUN echo "Downloading Dependency Check $DEPENDENCYCHECK_VERSION" \
  && curl -LO https://github.com/jeremylong/DependencyCheck/releases/download/v$DEPENDENCYCHECK_VERSION/dependency-check-$DEPENDENCYCHECK_VERSION-release.zip \
  && echo "Unpacking..." \
  && unzip -q dependency-check-$DEPENDENCYCHECK_VERSION-release.zip \
  && echo "Installing..." \
  && mv dependency-check $TOOLS_HOME/ \
  && echo "Updating vulnerabilities database..." \
  && $TOOLS_HOME/dependency-check/bin/dependency-check.sh --updateonly --nvdApiKey $NVD_API_KEY \
  && echo "Cleaning up..." \
  && rm -f dependency-check-$DEPENDENCYCHECK_VERSION-release.zip

RUN echo "Installing NVM $NVM_VERSION" \
  && mkdir -p $TOOLS_HOME/nvm && export NVM_DIR=$TOOLS_HOME/nvm \
  && curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash

RUN echo "Installing NodeJS $NODEJS_VERSION" \
  && export NVM_DIR=$TOOLS_HOME/nvm \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
  && nvm install $NODEJS_VERSION

RUN echo "Installing Snyk code scan" \
  && curl https://static.snyk.io/cli/latest/snyk-linux -o snyk \
  && chmod +x ./snyk \
  && mv ./snyk $TOOLS_HOME/

COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/bin/trivy
RUN echo "Updating Trivy DB..." && trivy fs /tmp

COPY --from=zricethezav/gitleaks:latest /usr/bin/gitleaks /usr/bin/gitleaks
