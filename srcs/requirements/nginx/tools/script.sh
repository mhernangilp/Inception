#!/bin/bash

mkdir -p /etc/nginx/ssl

openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/ssl.crt \
       -keyout /etc/nginx/ssl/ssl.key \
       -subj "/C=SP/ST=Madrid/L=Madrid/O=42 Madrid/OU=mhernangilp.42.fr/CN=mhernangilp.42.fr/"

chmod 600 /etc/nginx/ssl/ssl.key
chmod 644 /etc/nginx/ssl/ssl.crt

echo "Certificado SSL generado en /etc/nginx/ssl/"