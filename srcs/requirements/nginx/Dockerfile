FROM debian:bullseye

RUN apt-get -y update && apt-get -y install nginx openssl

RUN mkdir -p /wordpress /var/log/nginx /var/cache/nginx /etc/nginx && chmod 755 /wordpress /var/log/nginx /var/cache/nginx /etc/nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/ssl

COPY ./tools/script.sh /etc/nginx/ssl/script.sh

RUN chmod +x /etc/nginx/ssl/script.sh && /etc/nginx/ssl/script.sh

RUN chmod 600 /etc/nginx/ssl/ssl.key && chmod 700 /etc/nginx/ssl/ssl.crt

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]