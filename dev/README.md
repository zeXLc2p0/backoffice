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

### Setting up a database for the first time

If you are setting up a new local dev database, make a postgres user and database named after
your OS username and assign the user superuser privileges, before running refresh-database

### Common Error
If you are running this script on a Mac, you may run into this error:
```
./dev/refresh-database: line 107: syntax error near unexpected token `&'
```
This is due to the default version of bash on macOS being extremely outdated.
Install the latest version of bash via Homebrew to run this script.


## export-redcap-user

Export a UW ITHS REDCap user's project permissions with:

    ./dev/export-redcap-user --net-id <net-id>

See `./dev/export-redcap-user --help` for more information.
