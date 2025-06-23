FROM debian:bullseye

RUN mkdir -p /wordpress /run/php && chown -R www-data:www-data /wordpress /run/php
RUN mkdir -p tmp && chown -R www-data:www-data tmp

WORKDIR /wordpress

RUN apt-get -y update && apt-get install -y php-fpm php-mysql curl mariadb-client unzip

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/script.sh /script.sh

RUN chmod +x /script.sh

RUN PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;') && \
    sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 9000|' /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

EXPOSE 9000

ENTRYPOINT ["sh", "/script.sh"]

CMD ["php-fpm7.3", "-F"]