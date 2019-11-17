# Django stack for docker

This container aims to be a simple stack for running a django app inside docker!

# Setup

Using runit as a process supervisor the container runs an nginx server and a process on gunicorn with your app

If you want to extend the nginx configuration just add it to the `/etc/nginx/conf.d` folder

To run another process (other than the django+gunicorn) add a folder on the /etc/service with your script (with the name `run`)
```
/etc/service
  ├── gunicorn
  │   └── run
  ├── nginx
  │   └── run
  └── yourprocess
      └── run
```

```
                            ┌───────┐
                 ┌──────────┤ runit ├────────┐
  control process│          └───────┘        │ control process
                 │                           │
                 │                           │
             ┌───┴───┐  unix socket ┌────────┴────────┐
 http call ->│ nginx ├──────────────┤ gunicorn+django │
             └───────┘              └─────────────────┘
```


# Basics

"COPY" your project to the /app folder and define the "DJANGO_APP" as the name of your app

So in this example, the project is called testproj
```
/app
  ├── testproj
  │   ├── __init__.py
  │   ├── settings.py
  │   ├── urls.py
  │   └── wsgi.py
  ├── manage.py
  └── setup.py
```
And on your dockerfile there should be something like this:
```Dockerfile
ENV DJANGO_APP="testproj"
```

Remember to install your dependencies!

# Django CLI

If `python /app/manage.py` is not how your django cmd should be called use the `DJANGO_CMD` variable
```bash
ENV DJANGO_CMD="python /app/other_manage.py"

# with some env var
ENV DJANGO_CMD="FOO=bar python /app/manage.py"

# or maybe as a cli module
ENV DJANGO_CMD="managecli"
```

# Bootstraping

If you have your own script you want to run at startup just COPY it to the /bootstrap.d folder

