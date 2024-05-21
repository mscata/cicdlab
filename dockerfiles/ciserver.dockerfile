ARG JENKINS_IMG=jenkins/jenkins:jdk17
# dumper build to prepare files
FROM $JENKINS_IMG as dumper

COPY --chown=jenkins:jenkins ../setup/jenkins /var/jenkins_home
RUN jenkins-plugin-cli -f /var/jenkins_home/jenkins-plugins.txt -d /var/jenkins_home/plugins --verbose
RUN for f in $(ls /var/jenkins_home/plugins/*.jpi); do \
  plugin_name=$(basename "$f" .jpi); \
  unzip -o "$f" -d /var/jenkins_home/plugins/"$plugin_name"; \
done

# final build
FROM $JENKINS_IMG

USER root

RUN apt-get update \
  && apt-get install -y lsb-release apt-utils sudo zip unzip \
  && curl -fsSL https://get.docker.com | sh

RUN usermod -aG docker jenkins

USER jenkins
COPY --from=dumper --chown=jenkins:jenkins /var/jenkins_home /var/jenkins_home
