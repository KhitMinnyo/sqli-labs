FROM php:8.2-apache

# installing extensions
RUN apt-get update && \
    apt-get install -y \
    mariadb-client \
    libxml2-dev \
    && docker-php-ext-install mysqli

# PHP Configuration (using php.ini-development to show error)
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Timezone 
RUN echo "date.timezone = Asia/Yangon" >> /usr/local/etc/php/conf.d/timezone.ini

# Rewrite Module 
RUN a2enmod rewrite

# VIP
COPY . /var/www/html/

# Permission 
RUN chown -R www-data:www-data /var/www/html
