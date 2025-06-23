#!/bin/bash

service mysql start

# Usa las variables reales del entorno
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${database_name};"
mysql -u root -e "CREATE USER IF NOT EXISTS '${mysql_user}'@'%' IDENTIFIED BY '${mysql_password}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${database_name}.* TO '${mysql_user}'@'%';"
mysql -u root -e "ALTER USER '${mysql_root_user}'@'localhost' IDENTIFIED BY '${mysql_root_password}';"
mysql -u root -e "FLUSH PRIVILEGES;"

mysqladmin -u${mysql_root_user} -p${mysql_root_password} shutdown

exec "$@"
