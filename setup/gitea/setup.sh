#!/bin/bash
# curl -X 'POST' 'http://localhost:3000/api/v1/orgs' -H 'accept: application/json' -H 'authorization: Basic Y2ljZGFkbWluOnBhc3N3b3Jk' -H 'Content-Type: application/json' -d @/setup/gitea/gitea-create-org.json
# wait for Gitea to accept requests
echo "Start of Gitea setup"
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
cd /tmp || exit 1
for reponame in "cicdlab-check"; do
  echo "Checking repository: ${reponame}"
  if curl -Ifs -o /dev/null http://scmserver:3000/cicdservice/cicdlab-check/src/branch/main/Jenkinsfile; then
    echo "Repository ${reponame} already populated"
    continue
  fi
  echo "Restoring repository: ${reponame}"
  git clone "https://github.com/mscata/${reponame}.git"
  cd "./${reponame}" || exit 1
  git remote set-url origin "http://x-token-auth:35400151bd4c17cd678ff3d303f5e6500abb55b3@scmserver:3000/cicdservice/${reponame}.git"
  git push -u origin main
  cd ..
done
echo "End of Gitea setup"
