# Husky Musher

Musher is served from _/opt/husky-musher_ and manages its own Pipenv there.

## Serving the web API

The uWSGI configuration file for serving the web API is _uwsgi.ini_.  This file
is used by referencing it from Ubuntu's app-based configuration layout.

For example, in _/etc/uwsgi/apps-available/husky-musher.ini_:

    [uwsgi]
    ini = /opt/backoffice/husky-musher/uwsgi.ini

The configuration assumes that Pipenv is configured with
`PIPENV_VENV_IN_PROJECT=1` so that it installs its virtualenv in _.venv_.

Non-sensitive environment variables required by the app are stored in
`env.d/`, which is a collection of envdirs.
