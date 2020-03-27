# Xenforo2 in Docker

Xenforo2 Forum Software in Docker image.


## Current tags

* php7.3-fpm-0.1 or latest ([Dockerfile](https://github.com/drive-n-code/xenforo2-docker/blob/php7.3-fpm-0.1/Dockerfile))
* php7.1-fpm-0.1 ([Dockerfile](https://github.com/drive-n-code/xenforo2-docker/blob/php7.1-fpm-0.1/Dockerfile))


## Usage example

### docker-compose

```yaml
version: '2'
services:
  db:
    image: mysql:latest
    container_name: xenforo_mysql
    command: --default-authentication-plugin=mysql_native_password --innodb-use-native-aio=0
    restart: always
    networks:
      - xenforo
    volumes:
      - ./volumes/mysql:/var/lib/mysql
      - ./volumes/mysql-log:/var/log/mysql/
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}

  php:
    container_name: xenforo_php
    image: drivencode/xenforo2:latest
    restart: always
    depends_on:
      - db
    networks:
      - xenforo
    volumes:
      - ${XENFORO_APP_PATH}:/var/xenforo

  nginx:
    container_name: xenforo_nginx
    image: nginx:latest
    restart: always
    ports:
      - 80
    networks:
      - xenforo
    volumes_from:
      - php
    volumes:
      - ${XENFORO_APP_PATH}:/var/xenforo
      - ./conf/nginx.conf:/etc/nginx/conf.d/default.conf
      - ./volumes/nginx:/var/log/nginx

networks:
  xenforo:
```

