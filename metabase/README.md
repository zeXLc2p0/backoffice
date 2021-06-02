# Metabase service config and data

A suitably-configured Docker container named `metabase` is created by the
`create-container` script.  Every time you create the container, you will need
to bake into the environment connection details for Metabase's own internal
application database (not our ID3C databases).  This should take the form of:

    MB_DB_CONNECTION_URI="postgres://production.db.seattleflu.org/metabase?ssl=true&sslmode=require&user=metabase&password=$(grep :metabase: ~/.pgpass | cut -d: -f5)"

The `metabase.service` file should be symlinked into `/etc/systemd/system/` and
enabled using `systemctl enable metabase`.  Management of the Metabase
container is then performed using `systemctl {start,stop,restart} metabase`.

## Upgrade
To upgrade Metabase, change the image version in `create-container`, stop the
Metabase service, remove the existing `metabase` container with `docker
container rm`, run the `create-container` script, and restart the Metabase
service.  You may want to make a backup of the Metabase database first so that
you can restore and rollback to the previous Metabase version if the upgrade
corrupts the configuration.

Before an upgrade, please review the [Metabase release
notes](https://github.com/metabase/metabase/releases) for any backwards
incompatible changes or other changes which might break the study team's usage
of Metabase.

In particular, it's worth checking if the format of Metabase's query
remark/comment has changed.  Our `pg_stat_get_activity_nonsuperuser()` function
parses the remark to provide additional metadata to our database connection
watchdogs ([for example](https://github.com/seattleflu/id3c-customizations/commit/6f5db9ad)).

### Testing

It's nice to test upgrades locally, particularly if there are significant
changes.  Briefly sketched out, here's one way to do so:

 1. Dump a copy of Metabase's internal database:

        pg_dump -Fc -h production.db.seattleflu.org -U postgres metabase > metabase.pgdb

 2. Create a local `metabase` PostgreSQL user with a password of your choosing:

        createuser -P metabase

 3. Restore the database dump to create a local `metabase` database:

        pg_restore --create --clean -d template1 metabase.pgdb

 4. Create the new Metabase container using the instructions in the
    [upgrade](#upgrade) section above, but don't (re-)start the new container
    yet.  When running `create-container`, you'll need to set the
    `MB_DB_CONNECTION_URI` environment variable to point to localhost and
    include the password you set in step #2.

 5. Forward connections from inside the Metabase container to your local
    PostgreSQL instance running outside the container:

        socat TCP4-LISTEN:5432,bind=172.20.0.1,reuseaddr,fork TCP4:localhost:5432

    Replace the `bind` IP address with the gateway IP output by `docker network
    inspect metabase-bridge`.

 6. Start the Metabase container:

        docker container start -a metabase

 7. Look at Metabase on <http://localhost:3000>.



## Restart
To restart Metabase, run `sudo systemctl restart metabase`.

## See service status
To see service status info, run `sudo systemctl status metabase`.

## View logs
Run `sudo journalctl -fu metabase` to view Metabase logs.
