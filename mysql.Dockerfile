FROM r4mmer/django-gunicorn-nginx:latest

MAINTAINER André Carneiro <acarneiro.dev@gmail.com>

# Install libraries needed to install mysqlclient module
RUN apk add --update --no-cache mariadb-connector-c-dev && \
	  apk add --no-cache --virtual .build-deps mariadb-dev gcc musl-dev && \
	  pip install --no-cache-dir mysqlclient && \
	  apk del --purge .build-deps
