CONTAINERS = nginx wordpress mariadb

all: volumes up

volumes:
	@sudo mkdir -p ~/data/wordpress ~/data/mariadb
	@sudo chmod 755 ~/data

up:
	sudo docker-compose -f srcs/docker-compose.yml up --build -d

down:
	sudo docker-compose -f srcs/docker-compose.yml down

re: fclean all

clean:
	@for container in $(CONTAINERS); do \
		if docker ps -a --format '{{.Names}}' | grep -q "^$$container$$"; then \
			sudo docker stop $$container 2>/dev/null || true; \
			sudo docker rm $$container 2>/dev/null || true; \
		fi; \
	done
	sudo docker rmi srcs_nginx srcs_wordpress srcs_mariadb 2>/dev/null || true

fclean: clean
	@sudo rm -rf /home/mhernangilp/data/wordpress/* /home/mhernangilp/data/mariadb/* /home/mhernangilp/data/mariadb/.db_configured 2>/dev/null || true
	@sudo docker volume rm srcs_mariadb srcs_wordpress 2>/dev/null || true

.PHONY: volumes all up down re clean fclean