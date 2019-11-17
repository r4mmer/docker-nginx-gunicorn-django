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
COPY ./gunicorn/collectstatic.sh /bootstrap/collectstatic.sh
RUN chown root:root /etc/service/gunicorn/run /bootstrap/collectstatic.sh && \
    chmod u+x       /etc/service/gunicorn/run /bootstrap/collectstatic.sh

# configuration for nginx and gunicorn
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./gunicorn/gunicorn.conf.py /etc/gunicorn/gunicorn.conf.py

COPY runit_bootstrap /usr/sbin/runit_bootstrap
RUN chmod 755 /usr/sbin/runit_bootstrap

# cleanup

EXPOSE 80
ENTRYPOINT ["/usr/sbin/runit_bootstrap"]
