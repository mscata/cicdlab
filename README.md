# CI/CD Lab

This repo contains all the resources that are required to set up a generic CI/CD lab for educational purposes.

The lab allows a group of participants to initiate one or more projects and establish a full SDLC around them, including:

- source control management: [Gitea](https://github.com/go-gitea/gitea)
- continuous integration facilities: [Jenkins](https://jenkins.io)
- artifacts storage and management: [Artifactory](https://jfrog.com/artifactory/)
- deployment runtime: [Kubernetes](https://kubernetes.io/)
- database and database administration: [Postgres]() and [PG Admin]()
- application monitoring: [Prometheus](https://prometheus.io/)

## Pre-requisites

You will need [Docker](https://www.docker.io/) in order to run the lab, and at least 8GB of RAM (recommended 16GB).

## Starting the Lab

Just run `docker compose up -d`. If you haven't changed the services' ports in `docker-compose.yml`, then the services will be running as follows:

|Service         |Browser URL                 |Admin User                  |Password             |
|----------------|----------------------------|----------------------------|---------------------|
|SCM Server      |http://localhost:3000/      |cicdadmin                   |password             |
|Database        |none                        |postgres                    |password             |
|DB Admin        |http://localhost:5050/      |admin@cicdlabs.org          |password             |
|CI              |http://localhost:8080/      |                            |                     |
|

## Details for Lab users

There is a predefined user called `developer` with password `password` for source control. You can use it to create new repositories and to push
code to source control.

## Details for Lab Leaders

All data for all services is stored in the `./data` folder. If you want to scrap all labs and start again from scratch,
then stop all containers and just remove eveything from this data folder.

There are no predefined repositories in source control. You will have to create them as part of your lab exercises.

The Jenkins user for source control access is called `cicdservice` with password `password`. Note that this user has also admin rights on Gitea.

### Databases

The lab creates a database called `cicdlabs` for all the runtime needs of the lab projects. Feel free to create schemas for all your lab's needs.
The `Postgres` database is used for the lab's infrastructure. It contains a `gitea` database for source control, and a `pgadmin` database for
the database DB admin UI.

