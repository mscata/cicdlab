#!/bin/sh

FILE_PATH_PREFIX=

unameOut="$(uname -s)"

case "${unameOut}" in
    CYGWIN*)    FILE_PATH_PREFIX=/ && echo "Running on CIGWIN";;
    MINGW*)     FILE_PATH_PREFIX=/ && echo "Running on MINGW";;
    *)          FILE_PATH_PREFIX= && echo "Running on unknown platform"
esac

echo "Initialising DB server connection in pgadmin"
docker exec -i cicdlab-dbadmin ${FILE_PATH_PREFIX}/usr/local/pgsql-15/psql postgresql://postgres:password@cicdlab-dbserver:5432/postgres -f ${FILE_PATH_PREFIX}/setup/pgadmin/pgadmin-init.sql


echo "Setting up users in Gitea"
docker exec --user 1000 -i cicdlab-scmserver gitea admin user create --password password --must-change-password=false --username cicdadmin --email admin@cicdlabs.org --admin
docker exec --user 1000 -i cicdlab-scmserver gitea admin user create --password password --must-change-password=false --username cicdservice --email cicdservice@cicdlabs.org --admin
docker exec --user 1000 -i cicdlab-scmserver gitea admin user create --password password --must-change-password=false --username developer --email developer@cicdlabs.org

echo "Setting up Nexus repositories"
docker exec -i cicdlab-artifactsrepo ${FILE_PATH_PREFIX}/bin/sh ${FILE_PATH_PREFIX}/setup/nexus/nexus-setup.sh  

echo "Setting up Jenkins server"
docker exec -i cicdlab-ciserver ${FILE_PATH_PREFIX}/bin/sh/ ${FILE_PATH_PREFIX}/setup/jenkins/jenkins-setup.sh

exec "$@"