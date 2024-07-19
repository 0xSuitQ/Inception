start: mkdir
	cd srcs && docker-compose up

restart: clean build run

mkdir:
	mkdir -p /home/nandroso/data/wp /home/nandroso/data/db
build:
	cd srcs && docker-compose build
run:
	cd srcs && docker-compose up -d
stop:
	cd srcs && docker-compose stop
ps:
	cd srcs && docker-compose ps
clean: stop
	cd srcs && docker-compose rm
	docker volume rm db
	docker volume rm wp
	rm -rf /home/nandroso/data/db/*
	rm -rf /home/nandroso/data/wp/*
	yes | docker system prune -a --force
	yes | docker volume prune
