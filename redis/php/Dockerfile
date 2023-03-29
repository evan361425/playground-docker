FROM ghcr.io/roadrunner-server/roadrunner:2.X.X AS roadrunner

FROM php:8.1-cli

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

RUN set -xe \
    && apt-get update \
    && apt-get install -y tcpdump zip bash \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install sockets pcntl

RUN pecl install redis && docker-php-ext-enable redis

CMD [ "rr", "serve" ]
