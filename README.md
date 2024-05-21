# CI/CD Lab

This repo contains all the resources that are required to set up a simple CI/CD lab for educational purposes.

The lab allows a group of participants to initiate one or more projects and establish a full SDLC around them, including:

- project management: [Redmine](https://redmine.org)
- source control management: [Gitea](https://github.com/go-gitea/gitea)
- continuous integration facilities: [Jenkins](https://jenkins.io)
- artifacts storage and management: [Nexus](https://www.sonatype.com/products/sonatype-nexus-repository)
- deployment runtime: [Kubernetes](https://kubernetes.io/)
- database and database administration: [Postgres](https://www.postgresql.org/) and [PG Admin](https://www.pgadmin.org/)
- application monitoring and observability: [Prometheus](https://prometheus.io/) and [Grafana](https://grafana.com/)

All customised Docker images are [published to the Docker Hub](https://hub.docker.com/search?q=mscata%2Fcicdlab).

## Pre-requisites

The lab was developed on a Windows laptop with a quad-core AMD Ryzen 5 and 16GB of RAM, and runs happily in there.
You will need [Docker](https://www.docker.io/) in order to run the lab, and at least 8GB FREE of RAM.
If you want to deploy to Kubernetes, then you will also need [Minikube](https://minikube.sigs.k8s.io/docs/).

## Starting the Lab

Just run `docker compose up -d`. If you haven't changed the services' ports in `docker-compose.yml`, then the services will be running as follows:

|Service             | Browser URL                   | Admin User         | Password |
|--------------------|-------------------------------|--------------------|----------|
|Artifacts Repo      | http://localhost:8081/        | admin              | password |
|CI Server           | http://localhost:8080/jenkins | admin              | password |
|Clean Code Server   | http://localhost:9000/        | admin              | password |
|Database            | use the DB Admin URL          | postgres           | password |
|DB Admin            | http://localhost:5050/        | admin@cicdlabs.org | password |
|Project Server      | http://localhost:3001/        | admin              | password |
|SCM Server          | http://localhost:3000/        | cicdadmin          | password |

It will take about 20 minutes to start all services from scratch for the first time, so be patient. The first time
you start everything, all images will have to be downloaded and that takes a good few minutes on the average
home broadband connection. After that, all services will start up much faster, usually within 2 minutes.

The artifacts repository takes the longest to start up. The first time it starts, it will automatically install
and configure a lot of stuff. The first time you login to it, it will ask you to complete a couple of manual
setup steps. Just make sure you enable anonymous access and that's it. I haven't found a way to easily turn this 
into a pre-built fast-loading custom image. If you do, then please let me know how you did it.

The lab also contains a `labsetup` service. This performs some additional configuration operations on some
services that couldn't be pre-built as custom images. The `labsetup` service runs fairly quickly and then it stops.
It should not be running continuously, and you don't need to try starting it up again and again.
It only needs to run once to finish setting things up. Just let it be.

The CI server will use the following credentials to connect to other services. All of these are stored in the 
[Credentials management screen](http://localhost:8080/jenkins/manage/credentials/):

| Target Service       | Credentials ID    |Username             |Password  |
|----------------------|-------------------|---------------------|----------|
| SCM Server           | GITEA_CREDENTIALS |cicdservice          |password  |
| Artifacts Repository | NEXUS_CREDENTIALS |cicdservice          |password  |

There is a predefined user called `developer` with password `password` for source control. You can use it to create new repositories and to push code to source control.

There really is no particular need to persist all data on the host filesystem, apart from the SCM server, for the
simple reason that it is very useful for lab users not to lose easily any of the code they produce. Also, there are no 
predefined repositories in source control. You will have to create them as part of your lab exercises.

The Jenkins user to access all other services is called `cicdservice` with password `password`. 
The Jenkins token for the `admin` user is `11d877beb7a5a4e4ea09561047fd4706b0`, which is used to perform additional setup
through the Jenkins API.

The Gitea token for the `cicdadmin` user is `234bf3a2b99bc52d9f0db2cbe90c0dbb4682a130`. The setup service will use
this token to prepare and configure all the lab repos.

The Gitea token for the `cicdservice` user is `35400151bd4c17cd678ff3d303f5e6500abb55b3`. This will be used by the
CI agent to clone the repo before each build.

The Gitea token for the `developer` user is `149b1f7fe81cdcbcef7782d78dfc5efd229ec033`. The setup service will use
this token to push all sample code to the lab repos.

The Sonar token for automated passwordless analysis is `squ_0dd6393e80a4bd4ab058ccb649625f34878ee6f3`. Jenkins will
use this token to submit all code scans and retrieve the results. NOTE: the Sonar service is work-in-progress and is
not currently deployed as part of the lab. Stay tuned.

### Databases

The `Postgres` database contains schemas for the lab's services, with a separate schema for each service.
You can use the `public` schema for your lab sessions, or you can create a new database.
