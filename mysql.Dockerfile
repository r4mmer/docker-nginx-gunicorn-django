FROM python:3.7-alpine

MAINTAINER André Carneiro <acarneiro.dev@gmail.com>

ENV DJANGO_APP="proj_name"
ENV DJANGO_CMD="python /app/manage.py"

RUN touch /etc/inittab && \
    apk --no-cache update && \
    apk add --no-cache nginx runit && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir gunicorn==19.9.0

# configure nginx for runit
COPY ./nginx/run    /etc/service/nginx/run
RUN chown root:root /etc/service/nginx/run && \
    chmod u+x       /etc/service/nginx/run && \
    mkdir -p /run/nginx && \
    rm /etc/nginx/conf.d/default.conf

# configure gunicorn django app for runit
COPY ./gunicorn/run /etc/service/gunicorn/run
RUN chown root:root /etc/service/gunicorn/run && \
    chmod u+x       /etc/service/gunicorn/run

# configuration for nginx and gunicorn
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./gunicorn/gunicorn.conf.py /etc/gunicorn/gunicorn.conf.py

COPY runit_bootstrap /usr/sbin/runit_bootstrap
RUN chmod 755 /usr/sbin/runit_bootstrap

# Install libraries needed to install mysqlclient module
RUN apk add --update --no-cache mariadb-connector-c-dev && \
	  apk add --no-cache --virtual .build-deps mariadb-dev gcc musl-dev && \
	  pip install --no-cache-dir mysqlclient && \
	  apk del --purge .build-deps

# cleanup

EXPOSE 80
ENTRYPOINT ["/usr/sbin/runit_bootstrap"]



