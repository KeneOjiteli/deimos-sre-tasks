#A dockerfile with a custom PHP Apache image
FROM php:8.2-apache
RUN apt update && apt upgrade -y

#An environment to install mysqli, a PHP extension that will connect the PHP Apache to the MySQL server.
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

#A driver that implements the PHP Data Objects (PDO) interface to enable access from PHP to MySQL databases
RUN docker-php-ext-install pdo pdo_mysql