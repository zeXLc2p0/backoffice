# Metabase service config and data

A suitably-configured Docker container named `metabase` is created by the
`create-container` script, along with a protected, persistent data directory
which stores the Metabase configuration.

The `metabase.service` file should be symlinked into `/etc/systemd/system/` and
enabled using `systemctl enable metabase`.  Management of the Metabase
container is then performed using `systemctl {start,stop,restart} metabase`.

To upgrade Metabase, change the image version in `create-container`, stop the
Metabase service, remove the existing `metabase` container with `docker
container rm`, run the `create-container` script, and restart the Metabase
service.  You may want to make a backup of the `data/` directory first so that
you can restore and rollback to the previous Metabase version if the upgrade
corrupts the configuration.
