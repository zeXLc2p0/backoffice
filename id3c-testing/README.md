# backoffice — ID3C testing environment

This directory is a Pipenv project for controlling the ID3C **testing**
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


[core ID3C]: https://github.com/seattleflu/idc3
[our customizations]: https://github.com/seattleflu/id3c-customizations
[PyPi]: https://pypi.org/
[Git (VCS) dependency URLs]: https://pipenv-fork.readthedocs.io/en/latest/basics.html#a-note-about-vcs-dependencies
