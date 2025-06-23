#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

WORDPRESS_URL="https://wordpress.org/latest.tar.gz"
WORDPRESS_DIR="/wordpress/"

mkdir -p "$WORDPRESS_DIR"

echo "${GREEN}Descargando WordPress...${NC}"
curl -sSL "$WORDPRESS_URL" -o /tmp/wordpress.tar.gz

echo "${GREEN}Descomprimiendo WordPress...${NC}"
tar -xzf /tmp/wordpress.tar.gz -C /tmp

echo "${GREEN}Copiando archivos de WordPress a $WORDPRESS_DIR...${NC}"
cp -r /tmp/wordpress/* "$WORDPRESS_DIR/"

echo "${GREEN}Limpiando archivos temporales...${NC}"
rm -rf /tmp/wordpress /tmp/wordpress.tar.gz
rm -rf "$WORDPRESS_DIR/wp-config-sample.php"

cd "$WORDPRESS_DIR"

echo "${GREEN}Creando wp-config.php dinámicamente...${NC}"
wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
#    --dbhost="$DB_HOST" \
    --allow-root

# Establecer el límite de memoria
wp config set WP_MEMORY_LIMIT '256M' --type=constant --allow-root

# Insertar WP_DEBUG antes de require_once
sed -i "/require_once ABSPATH . 'wp-settings.php';/i \
define( 'WP_DEBUG', true );\n\
define( 'WP_DEBUG_LOG', true );\n\
define( 'WP_DEBUG_DISPLAY', true );" "$WORDPRESS_DIR/wp-config.php"

echo "${GREEN}Instalando WordPress...${NC}"
wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

echo "${GREEN}Creando usuario adicional...${NC}"
wp user create "$DB_USER" "$DB_EMAIL" --role=author --user_pass="$DB_PASSWORD" --allow-root

echo "${GREEN}Ajustando permisos...${NC}"
chown -R www-data:www-data "$WORDPRESS_DIR"
chmod -R 755 "$WORDPRESS_DIR"

echo "${GREEN}¡WordPress instalado y configurado correctamente!${NC}"

exec "$@"