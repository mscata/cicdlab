#!/bin/bash
# wait for jenkins to accept requests
echo "Start of Jenkins setup"
retries=20
curl -X POST -s --user admin:11b97984ddae80553014a4c5581f8ee404 http://ciserver:8080/jenkins/createItem?name=cicdlab --data @/setup/jenkins/jobs/cicdlab/config.xml -H "Content-Type:text/xml"
for ((retry = 1; retry <= retries; retry++)); do
  if curl -Ifs -o /dev/null http://ciserver:8080/jenkins/job/cicdlab/; then
      break
  else
      if [[ retry -eq $retries ]]; then
        echo "Failed to set up Jenkins"
        exit 1
      else
        echo "Waiting for Jenkins... ($retry/$retries)"
        sleep 60
      fi
  fi
done
echo "Scanning cicdlab org..."
curl -X POST -s --user admin:11b97984ddae80553014a4c5581f8ee404 http://ciserver:8080/jenkins/job/cicdlab/build?delay=0
echo "End of Jenkins setup"
