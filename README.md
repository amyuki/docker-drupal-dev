# docker-drupal-dev
Docker image file

* docker-compose.yml sample
```
version: "3"
services:
  drupal:
    image: ycheung/drupal-dev
    container_name: drupal-dev
    ports:
      - "8080:80"
    expose:
      - "9000"
      - "9001"
    volumes:
      - ${HOST_DIR}:/var/www/html
    links:
      - mariadb:mysql
    depends_on:
      - mariadb
  mariadb:
    image: mariadb
    container_name: mariadb
    restart: always
    volumes:
      - ${DATA_DIR}:/var/lib/mysql
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: drupal-dev
      MYSQL_DATABASE: drupal-dev
#    command  just for windows docker client
    command: 'mysqld --innodb-flush-method=fsync'
    ```
    
