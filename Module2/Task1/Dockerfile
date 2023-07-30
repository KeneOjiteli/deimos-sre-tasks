#A dockerfile with a custom PHP Apache image
FROM php:8.2-apache

RUN apt-get update && apt upgrade -y

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli

COPY php/* /var/www/html 

EXPOSE 80

# EXPOSE 443

CMD ["apache2-foreground"]

