#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
  mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

if [ ! -f "/var/lib/mysql/.db_configured" ]; then
  mysqld --skip-networking --socket=/tmp/mysql.sock &
  TEMP_PID=$!

  TIMEOUT=30
  while [ $TIMEOUT -gt 0 ]; do
   if mysqladmin -u root -p"$DB_ROOT_PASSWORD" --socket=/tmp/mysql.sock ping > /dev/null 2>&1; then
      break
    fi
    sleep 1
    TIMEOUT=$((TIMEOUT - 1))
  done

  if [ $TIMEOUT -eq 0 ]; then
    echo "Error: No se pudo iniciar el servidor temporal de MariaDB."
    kill $TEMP_PID
    exit 1
  fi

  mysql -u root -p"$DB_ROOT_PASSWORD" --socket=/tmp/mysql.sock <<EOF
  CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
  CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
  GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
  ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
  FLUSH PRIVILEGES;
EOF

  mysqladmin -u root -p"$DB_ROOT_PASSWORD" --socket=/tmp/mysql.sock shutdown
  wait $TEMP_PID

  touch /var/lib/mysql/.db_configured
fi

exec mysqld
