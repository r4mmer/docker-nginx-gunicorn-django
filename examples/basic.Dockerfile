FROM django-stack:sqlite3

ENV DJANGO_APP="testproj"

COPY example /app
WORKDIR /app

COPY entrypoint.sh /bootstrap/entrypoint.sh
RUN chmod u+x /bootstrap/entrypoint.sh

RUN pip install -e .
