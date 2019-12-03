# Dotfiles

This directory contains various dotfiles for the backoffice system user's home
directory (e.g. _/home/ubuntu_).

Files are installed by running:

    make

from within this directory or running:

    make -C dotfiles

from within the top-level of this repo.

## Files of note

  * `pg_service.conf` is the PostgreSQL service definition file used by some of
    our automated processes.
