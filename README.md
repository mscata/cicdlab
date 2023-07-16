# CI/CD Lab

This repo contains all the resources that are required to set up a generic CI/CD lab for educational purposes.

The lab allows a group of participants to initiate one or more projects and establish a full SDLC around them, including:

- source control management [Gitea](https://github.com/go-gitea/gitea)
- continuous integration facilities [Jenkins](https://jenkins.io)
- artifacts storage and management [Artifactory](https://jfrog.com/artifactory/)
- deployment runtime [Kubernetes](https://kubernetes.io/)
- database and database administration [Postgres]() and [PG Admin]()
- application monitoring [Prometheus](https://prometheus.io/)

## Pre-requisites

You will need [Docker](https://www.docker.io/) in order to run the lab, and at least 8GB of RAM (recommended 16GB).

## Starting the Lab

Just run `docker compose up -d`. If you haven't changed the services' ports in `docker-compose.yml`, then the services will be running as follows:

|Service         |URL                         |Admin User                  |Password             |
|----------------|----------------------------|----------------------------|---------------------|
|SCM Server      |http://localhost:3000/      |                            |                     |
|Database        |                            |postgres                    |postgres             |
|DB Admin        |http://localhost:5050/      |admin@cicdlabs.org          |password             |
|CI              |http://localhost:8080/      |                            |                     |
|

## Details for Lab Leaders

All data for all services is stored in the `./data` folder. If you want to scrap all labs and start again from scratch,
then stop all containers and just remove eveything from this data folder.

### Databases

The lab creates 2 databases. The `gitea` database stores all the metadata for the SCM platform and must not be touched.
The `cicdlabs` database is at your disposal to provide the lab group with a runtime database for their applications.

### Source Control

|Username       |Password      |
|---------------|--------------|
|cicd
|cicdlabs
|developer