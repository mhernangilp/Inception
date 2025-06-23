GREEN	= \033[0;32m
RED		= \033[0;31m
NC		= \033[0m

CONTAINERS = nginx wordpress mariadb

all: volumes up

volumes:
	@sudo mkdir -p ~/data/wordpress ~/data/mariadb
	@sudo chmod 755 ~/data
	@sudo chown -R 33:33 ~/data/wordpress
	@sudo chown -R 101:101 ~/data/mariadb

up:
	@echo "$(GREEN)Starting up containers$(NC)"
	sudo docker-compose -f srcs/docker-compose.yml up --build -d

down:
	@echo "$(RED)Stopping containers$(NC)"
	sudo docker-compose -f srcs/docker-compose.yml down

re: fclean all

clean:
	@echo "$(GREEN)Checking running containers...$(NC)"
	@for container in $(CONTAINERS); do \
		if docker ps -a --format '{{.Names}}' | grep -q "^$$container$$"; then \
			echo "$(RED)Stopping $${container}$(NC)"; \
			sudo docker stop $$container 2>/dev/null || true; \
			echo "$(RED)Removing $${container}$(NC)"; \
			sudo docker rm $$container 2>/dev/null || true; \
		else \
			echo "$(GREEN)Container $${container} not found, skipping$(NC)"; \
		fi; \
	done
	@echo "$(RED)Removing images$(NC)"
	sudo docker rmi srcs_nginx srcs_wordpress srcs_mariadb 2>/dev/null || true

fclean: clean
	@echo "$(RED)Removing local volumes$(NC)"
	@sudo rm -rf /home/mhernangilp/data/wordpress/* /home/mhernangilp/data/mariadb/* /home/mhernangilp/data/mariadb/.db_configured 2>/dev/null || true
	@echo "$(RED)Removing docker volumes$(NC)"
	@sudo docker volume rm srcs_mariadb srcs_wordpress 2>/dev/null || true

.PHONY: volumes all up down re clean fclean