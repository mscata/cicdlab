ifdef OS
	PATH_PREFIX=/

endif

.PHONY: default
default:
	echo "You need to select one of the valid targets"

date := `date '+%Y-%m-%d'`
img_basename := mscata/cicdlabs

.PHONY: clean
clean:
	@docker compose down

.PHONY: freezedbserver
freezedbserver:
	@docker exec cicdlab-dbserver bash -c "pg_dump -h localhost -U postgres -d postgres > /tmp/postgres-init.sql"
	@docker cp cicdlab-dbserver:$(PATH_PREFIX)/tmp/postgres-init.sql setup/postgres/

.PHONY: freezeciserver
freezeciserver:
	@docker cp cicdlab-ciserver:$(PATH_PREFIX)/var/jenkins_home/credentials.xml setup/jenkins

buildimg:
	@docker build . -f dockerfiles/$(IMAGE).dockerfile -t $(img_basename)-$(IMAGE):latest

.PHONY: ciserver
ciserver:
	@make buildimg IMAGE=ciserver

.PHONY: ciagent
ciagent:
	@make buildimg IMAGE=ciagent

.PHONY: dbserver
dbserver:
	@make buildimg IMAGE=dbserver

pushimg:
	@docker tag $(img_basename)-$(IMAGE):latest $(img_basename)-$(IMAGE):$(date)
	@docker push $(img_basename)-$(IMAGE):$(date)
	@docker push $(img_basename)-$(IMAGE):latest

pushciserver:
	@make pushimg IMAGE=ciserver

pushciagent:
	@make pushimg IMAGE=ciagent

pushdbserver:
	@make pushimg IMAGE=dbserver
