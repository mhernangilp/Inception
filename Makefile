DOCKER_COMPOSE=docker compose

DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

.PHONY: kill build down clean restart

build:
	@sudo mkdir -p /home/mhernangilp/data/mariadb
	@sudo mkdir -p /home/mhernangilp/data/wordpress
	@$(DOCKER_COMPOSE)  -f $(DOCKER_COMPOSE_FILE) up --build -d
kill:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) kill
down:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down
clean:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	@sudo rm -r /home/mhernangilp/data/mariadb
	@sudo rm -r /home/mhernangilp/data/wordpress
	@docker system prune -a -f

restart: clean build