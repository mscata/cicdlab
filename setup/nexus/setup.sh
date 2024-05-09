#!/bin/bash
# wait for nexus to accept requests
echo "Start of Nexus setup"
retries=20
for ((retry = 1; retry <= retries; retry++)); do
  if curl -s -o /dev/null http://artifactsrepo:8081/nexus/service/rest/v1/status; then
      break
  else
      if [[ retry -eq $retries ]]; then
        echo "Failed to set up Nexus"
        exit 1
      else
        echo "Waiting for Nexus... ($retry/$retries)"
        sleep 60
      fi
  fi
done
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/repositories/raw/hosted -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/raw-hosted-repo.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/repositories/docker/hosted -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/docker-hosted-repo.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/repositories/docker/proxy -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/docker-proxy-repo.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/repositories/docker/group -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/docker-group-repo.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/repositories/pypi/hosted -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/pypi-hosted-repo.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/repositories/pypi/proxy -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/pypi-proxy-repo.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/repositories/pypi/group -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/pypi-group-repo.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/security/roles -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/role-publisher.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/security/users -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/user-cicdservice.json
curl -s -o /dev/null -u admin:password -X 'POST' http://artifactsrepo:8081/nexus/service/rest/v1/security/anonymous -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/json/anonymous-access.json
echo "End of Nexus setup"
