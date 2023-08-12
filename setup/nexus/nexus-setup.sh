curl -u admin:password -X 'POST' http://localhost:8081/service/rest/v1/repositories/docker/hosted -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/docker-hosted-repo.json
  
curl -u admin:password -X 'POST' http://localhost:8081/service/rest/v1/repositories/docker/proxy -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/docker-proxy-repo.json
  
curl -u admin:password -X 'POST' http://localhost:8081/service/rest/v1/repositories/docker/group -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/docker-group-repo.json

curl -u admin:password -X 'POST' http://localhost:8081/service/rest/v1/repositories/pypi/hosted -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/pypi-hosted-repo.json
  
curl -u admin:password -X 'POST' http://localhost:8081/service/rest/v1/repositories/pypi/proxy -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/pypi-proxy-repo.json
  
curl -u admin:password -X 'POST' http://localhost:8081/service/rest/v1/repositories/pypi/group -H 'accept: application/json' -H 'Content-Type: application/json' -d @/setup/nexus/pypi-group-repo.json
