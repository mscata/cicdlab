ARG JENKINS_IMG=jenkins/jenkins:jdk17

FROM $JENKINS_IMG

USER root

RUN apt-get update \
  && apt-get install -y lsb-release apt-utils sudo zip unzip \
  && curl -fsSL https://get.docker.com | sh

RUN usermod -aG docker jenkins

USER jenkins
