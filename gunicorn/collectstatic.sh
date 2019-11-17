#!/bin/sh

source /etc/envvars

echo "[***] Collecting static files"
django_cmd=${DJANGO_CMD}
$django_cmd collectstatic
