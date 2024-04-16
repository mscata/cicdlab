ARG JENKINS_IMG=jenkins/jenkins:jdk17

FROM $JENKINS_IMG

COPY --chown=jenkins:jenkins setup/jenkins/jenkins-plugins.txt /var/jenkins_home
COPY --chown=jenkins:jenkins setup/jenkins/users/ /var/jenkins_home/users/
RUN ["jenkins-plugin-cli", "-f", "/var/jenkins_home/jenkins-plugins.txt", "-d", "/var/jenkins_home/plugins", "--verbose"]

USER jenkins
