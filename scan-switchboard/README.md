# SCAN Switchboard

The SCAN Switchboard source code lives at https://github.com/seattleflu/scan-switchboard.
The crontabs for the Switchboard live in this repo under [backoffice/crontabs/scan-switchboard](https://github.com/seattleflu/backoffice/blob/master/crontabs/scan-switchboard).
This directory contains configuration info for the SCAN Switchboard web app that
runs on the backoffice server.

The app is deployed via systemd by running:

    sudo make

from within this directory or running:

    sudo make -C scan-switchboard

from within the top-level of this repo.

To deploy this app, first run:
```sh
sudo systemctl daemon-reload
```

> ## Deploying for the first time? Run the following code once:
> ```sh
> sudo systemctl enable scan-switchboard
> ```
> This command creates a symlink pointing from
> _/etc/systemd/system/default.target.wants/scan-switchboard.service_ →
> _/etc/systemd/system/scan-switchboard.service_
>
> Next, start the service via:
> ```sh
> sudo systemctl start scan-switchboard
> ```

Reload the `scan-switchboard` service via `systemctl`.
```sh
sudo systemctl restart scan-switchboard
```
