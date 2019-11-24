FROM r4mmer/django-gunicorn-nginx:latest

MAINTAINER André Carneiro <acarneiro.dev@gmail.com>

# Install libraries needed to install psycopg2 module (PostGreSQL)
RUN apk add --no-cache --virtual .build-deps gcc python3-dev musl-dev && \
    apk add --no-cache postgresql-dev && \
    pip install --no-cache-dir psycopg2 && \
	  apk del --purge .build-deps
