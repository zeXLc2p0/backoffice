# backoffice — ID3C production environment

This directory is a Pipenv project for controlling the ID3C **production**
environment for the Seattle Flu Study.

Currently this means installing both [core ID3C][] and [our customizations][]
into the same environment.  As these projects are not released to [PyPi][], we
use [Git (VCS) dependency URLs][].

To get started, install the locked deps:

    pipenv sync

Then you can run ID3C's CLI:

    pipenv run id3c

You should see our custom commands like `id3c reportable-conditions` in the
help output.

## Updating

Pull the latest versions from Git by running:

    pipenv update

This will update the file _Pipfile.lock_ and install updates into the
virtualenv managed by Pipenv.

## Serving the web API

The uWSGI configuration file for serving the web API is _uwsgi.ini_.  This file
is used by referencing it from Ubuntu's app-based configuration layout.

For example, in _/etc/uwsgi/apps-available/api-production.ini_:

    [uwsgi]
    ini = /opt/backoffice/id3c-production/uwsgi.ini

The configuration assumes that Pipenv is configured with
`PIPENV_VENV_IN_PROJECT=1` so that it installs its virtualenv in _.venv_.

Non-sensitive environment variables required by the web API are stored in
`env.d/`, which is an envdir.


[core ID3C]: https://github.com/seattleflu/idc3
[our customizations]: https://github.com/seattleflu/id3c-customizations
[PyPi]: https://pypi.org/
[Git (VCS) dependency URLs]: https://pipenv-fork.readthedocs.io/en/latest/basics.html#a-note-about-vcs-dependencies
