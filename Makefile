start: mkdir build run

restart: clean build run

mkdir:
	mkdir -p ~/data/wp ~/data/db
build:
	cd srcs && docker-compose build
run:
	cd srcs && docker-compose up -d
stop:
	cd srcs && docker-compose stop
ps:
	cd srcs && docker-compose ps
clean: stop
	cd srcs && docker-compose rm -f
	docker volume rm srcs_db-data
	docker volume rm srcs_wordpress-data
	rm -rf ~/data/db/*
	rm -rf ~/data/wp/*
	docker system prune -a -f
	docker volume prune -f