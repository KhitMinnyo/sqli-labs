FROM php:8.2-apache

RUN apt-get update && \
    apt-get install -y \
    mariadb-client \
    libxml2-dev \
    && docker-php-ext-install mysqli 

RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-display-errors.ini && \
    echo "date.timezone = Asia/Yangon" >> /usr/local/etc/php/conf.d/timezone.ini

# Cookie lessons (Less-20/21/22) call setcookie()/header() AFTER HTML output.
# This php:8.2-apache image ships with output_buffering off, so those calls
# fail with "headers already sent" and the login cookie/redirect never happen.
# Enabling output buffering restores the lab's intended behaviour.
RUN echo "output_buffering = 4096" >> /usr/local/etc/php/conf.d/output-buffering.ini

RUN a2enmod rewrite

RUN rm -rf /var/www/html/*
