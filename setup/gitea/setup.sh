#!/bin/bash
# curl -X 'POST' 'http://localhost:3000/api/v1/orgs' -H 'accept: application/json' -H 'authorization: Basic Y2ljZGFkbWluOnBhc3N3b3Jk' -H 'Content-Type: application/json' -d @/setup/gitea/gitea-create-org.json
# wait for Gitea to accept requests
echo "Start of Gitea setup"
retries=20
for ((retry = 1; retry <= retries; retry++)); do
  if curl -Ifs -o /dev/null http://scmserver:3000/; then
    break
  else
    if [[ retry -eq $retries ]]; then
      echo "Failed to set up Gitea"
      exit 1
    else
      echo "Waiting for Gitea... ($retry/$retries)"
      sleep 60
    fi
  fi
done
for reponame in "cicdlab-check"; do
  cd /tmp || exit 1
  echo "Checking repository: ${reponame}"
  response=$(curl -fsw '%{http_code}' http://scmserver:3000/cicdlab/cicdlab-check/src/branch/main/Jenkinsfile -o /dev/null)
  if [[ response -eq 200 ]]; then
    echo "Repository ${reponame} already populated"
    continue
  fi
  rm -rf "./${reponame}"
  echo "Cloning remote repository: ${reponame}"
  for ((retry = 1; retry <= retries; retry++)); do
    if git clone "https://github.com/mscata/${reponame}.git"; then
	    break
	  else
	    echo "Retry $retry/$retries"
	  fi
  done
  cd "./${reponame}" || exit 1
  echo "Restoring lab repository: ${reponame}"
  curl -X 'POST' -s \
    'http://scmserver:3000/api/v1/orgs/cicdlab/repos?token=234bf3a2b99bc52d9f0db2cbe90c0dbb4682a130' \
    -H 'authorization: Basic Y2ljZGFkbWluOnBhc3N3b3Jk' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"name": "cicdlab-check","private": false}' \
    -o /dev/null
  echo "Pushing repo ${reponame}"
  git remote set-url origin "http://x-token-auth:149b1f7fe81cdcbcef7782d78dfc5efd229ec033@scmserver:3000/cicdlab/${reponame}.git"
  git push origin main
done
echo "End of Gitea setup"
