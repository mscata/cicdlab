default: all

.PHONY: default all

date := `date '+%Y-%m-%d'`
img_suffix := mscata/cicdlabs

all: ciserver, ciagent

clean:
	@docker compose down
	@docker volume rm cicdlab_jenkins-data
	@docker volume rm postgres-data

ciserver:
	@docker build . -f dockerfiles/ciserver.dockerfile -t $(img_suffix)-$@:latest

ciagent:
	@docker build . -f dockerfiles/ciagent.dockerfile -t $(img_suffix)-$@:latest

dbserver:
	@docker build . -f dockerfiles/dbserver.dockerfile -t $(img_suffix)-$@:latest

artifactsrepo:
	@docker build . -f dockerfiles/artifactsrepo.dockerfile -t $(img_suffix)-$@:latest

push:
	@docker tag $(img_suffix)-ciserver:latest $(img_suffix)-ciserver:$(date)
	@docker push $(img_suffix)-ciserver:latest
	@docker tag $(img_suffix)-ciagent:latest $(img_suffix)-ciagent:$(date)
	@docker push $(img_suffix)-ciagent:latest
