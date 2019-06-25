# Metabase service config and data

A suitably-configured Docker container named `metabase` is created by the
`create-container` script.  Every time you create the container, you will need
to bake into the environment connection details for Metabase's own internal
application database (not our ID3C databases).  This should take the form of:

    MB_DB_CONNECTION_URI="postgres://hostname/metabase?ssl=true&sslmode=require&user=metabase&password=$(grep :metabase: ~/.pgpass | cut -d: -f5)"

The `metabase.service` file should be symlinked into `/etc/systemd/system/` and
enabled using `systemctl enable metabase`.  Management of the Metabase
container is then performed using `systemctl {start,stop,restart} metabase`.

To upgrade Metabase, change the image version in `create-container`, stop the
Metabase service, remove the existing `metabase` container with `docker
container rm`, run the `create-container` script, and restart the Metabase
service.  You may want to make a backup of the Metabase database first so that
you can restore and rollback to the previous Metabase version if the upgrade
corrupts the configuration.
