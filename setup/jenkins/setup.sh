jenkins-plugin-cli -f /var/jenkins_home/jenkins-plugins.txt -d /var/jenkins_home/plugins --verbose
for f in $(ls /var/jenkins_home/plugins/*.hpi); do
    plugin_name=$(basename "$f" .hpi)
    unzip -o "$f" -d /var/jenkins_home/plugins/"$plugin_name"
done
