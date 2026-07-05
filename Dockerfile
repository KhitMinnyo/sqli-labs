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

# The labs include shared files with CWD-relative paths ("../sql-connections/..").
# Under Apache the working directory is not the script's folder, so those
# includes fail and pages show no data. This prepend forces the CWD to each
# script's own directory on every request (see _prepend.php).
RUN echo "auto_prepend_file = /var/www/html/_prepend.php" >> /usr/local/etc/php/conf.d/labs-chdir.ini

# Disable OPcache. The labs are edited live (bind-mounted), and cached
# bytecode of an earlier/broken version of a lesson keeps being served even
# after the file is fixed, so pages show no data. Turning OPcache off makes
# PHP always read the current file. (This is a lab, not a production app.)
RUN echo "opcache.enable=0" >> /usr/local/etc/php/conf.d/labs-opcache.ini && \
    echo "opcache.enable_cli=0" >> /usr/local/etc/php/conf.d/labs-opcache.ini

RUN a2enmod rewrite

RUN rm -rf /var/www/html/*
