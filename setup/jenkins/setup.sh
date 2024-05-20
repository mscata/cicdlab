#!/bin/bash
# wait for jenkins to accept requests
echo "Start of Jenkins setup"
retries=20
for ((retry = 1; retry <= retries; retry++)); do
  if curl -Ifs -o /dev/null http://ciserver:8080/jenkins/job/cicdlabs/; then
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
curl -X POST --user admin:11b97984ddae80553014a4c5581f8ee404 http://ciserver:8080/jenkins/job/cicdlabs/build?delay=0
echo "End of Jenkins setup"
