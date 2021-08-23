# Changelog

All notable changes to `docker lemp` will be documented in this file.

## 0.0.1 - 2021-07-19

- initial release including readme.

## 0.0.2 - 2021-07-19

- added nginx vhost and reverse proxy studs.
- added php-fpm xdebug and globally installed composer.


## 0.0.3 - 2021-07-22

- added the global .env file
- addition of php-cli and php-fpm conf files.
- enhancement of nginx configuration.
- moved nginx, redis and phpfpm services to alpine3.13 based images.

## 0.0.5 - 2021-07-26
- added the projects' source folder SRC in .env defaulted to ./app.
- restructure of all docker components in the docker folder.

## 0.0.7 - 2021-08-13
- removed phpMyAdmin container
- added phpMyAdmin as nginx host

## 0.0.8 - 2021-08-23
- Combined nginx and phpfpm services into web.
