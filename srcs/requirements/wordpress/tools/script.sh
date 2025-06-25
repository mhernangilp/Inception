#!/bin/bash

WORDPRESS_DIR="/wordpress/"
WORDPRESS_URL="https://wordpress.org/latest.tar.gz"

mkdir -p "$WORDPRESS_DIR"

curl -sSL "$WORDPRESS_URL" -o /tmp/wordpress.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /tmp
cp -r /tmp/wordpress/* "$WORDPRESS_DIR/"

rm -rf /tmp/wordpress /tmp/wordpress.tar.gz
rm -rf "$WORDPRESS_DIR/wp-config-sample.php"

cd "$WORDPRESS_DIR"

wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --allow-root

wp config set WP_MEMORY_LIMIT '256M' --type=constant --allow-root

wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

wp user create "$DB_USER" "$DB_EMAIL" --role=author --user_pass="$DB_PASSWORD" --allow-root

chown -R www-data:www-data "$WORDPRESS_DIR"
chmod -R 755 "$WORDPRESS_DIR"

exec "$@"