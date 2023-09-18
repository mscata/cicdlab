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

You will need [Docker](https://www.docker.io/) in order to run the lab, and at least 8GB FREE of RAM.
The lab has been running happily on a laptop with a quad-core AMD Ryzen 5 and 16GB of RAM.
If you want to deploy to Kubernetes, then you will also need [Minikube](https://minikube.sigs.k8s.io/docs/).

## Starting the Lab

Just run `docker compose up -d`. If you haven't changed the services' ports in `docker-compose.yml`, then the services will be running as follows:

|Service             |Browser URL              |Admin User             |Password    |Startup time (approx)|
|--------------------|-------------------------|-----------------------|------------|---------------------|
|SCM Server          |http://localhost:3000/   |cicdadmin              |password    |2 minutes            |
|Database            |none                     |postgres               |password    |2 minutes            |
|DB Admin            |http://localhost:5050/   |admin@cicdlabs.org     |password    |
|CI Server           |http://localhost:8080/   |admin                  |            |
|Artifacts Repo      |http://localhost:8081/   |admin                  |password    |


It will take about 5 minutes to build the new Jenkins image, and 15-20 minutes to start all services from scratch for the first time, so be patient. 
After all the services are running, you will have to run the file `setup.sh` only once. This will run some lab-specific setup for a bunch of services. 
After the initial setup, services will start a lot more quickly in future sessions.

Note that the CI server in particular will take a long time to start up the very first time you run the lab. This is because there is a lot to do to generate
the image, install updates, install the Docker CLI, install a whole bunch of plugins, and a lot more stuff.

First-time setup times for all services is approximately 10-15 minutes.

The CI server will use the following credentials to connect to other services. Please note that you will probably have to update the passwords
**exactly as shown here** from the admin screens, otherwise it won't be able to connect to anywhere:

|Service             |Credentials ID       |Username             |Password  |
|--------------------|---------------------|---------------------|----------|
|SCM Server          |GITEA_CREDENTIALS    |cicdservice          |password  |

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

