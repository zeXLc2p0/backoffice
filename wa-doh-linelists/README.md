# backoffice — wa-doh-linelists environment

This directory is a Pipenv project for controlling the linelist upload
to the Washington State Department of Health for the Seattle Flu Study.

Currently this means installing both [core ID3C][] and [our customizations][]
into the same environment.  As these projects are not released to [PyPi][], we
use [Git (VCS) dependency URLs][].

To get started, install the locked deps:

    pipenv sync

Then you can run a shell in the environment to test upload functionality:

    pipenv shell
    /opt/backoffice/bin/wa-doh-linelists/generate

## Updating

Pull the latest versions from Git by running:

    pipenv update

This will update the file _Pipfile.lock_ and install updates into the
virtualenv managed by Pipenv.

The configuration assumes that Pipenv is configured with
`PIPENV_VENV_IN_PROJECT=1` so that it installs its virtualenv in _.venv_.

[core ID3C]: https://github.com/seattleflu/idc3
[our customizations]: https://github.com/seattleflu/id3c-customizations
[PyPi]: https://pypi.org/
[Git (VCS) dependency URLs]: https://pipenv-fork.readthedocs.io/en/latest/basics.html#a-note-about-vcs-dependencies
