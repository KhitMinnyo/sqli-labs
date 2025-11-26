FROM php:8.2-apache

RUN apt-get update && \
    apt-get install -y \
    mariadb-client \
    libxml2-dev \
    && docker-php-ext-install mysqli 

RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-display-errors.ini && \
    echo "date.timezone = Asia/Yangon" >> /usr/local/etc/php/conf.d/timezone.ini

RUN a2enmod rewrite

RUN rm -rf /var/www/html/*
