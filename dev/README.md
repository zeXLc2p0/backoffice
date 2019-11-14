# Dev tools

## refresh-database

As a quick start, you can refresh your local dev database with:

    ./dev/refresh-database

Refreshing the testing database is:

    PGHOST=testing.db.seattleflu.org PGDATABASE=testing PGUSER=postgres ./dev/refresh-database

If you provide a directory as the first argument, the database dump will be
preserved and re-used between runs.  This lets you save a bunch of time and use
the same dump for a week or two for local dev.

See `./dev/refresh-database --help` for more information.
