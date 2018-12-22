# Lab Labels service config

A suitably-configured Docker container named `lab-labels` is created by the
`create-container` script.

The `lab-labels.service` file should be symlinked into `/etc/systemd/system/`
and enabled using `systemctl enable lab-labels`.  Management of the container
is then performed using `systemctl {start,stop,restart} lab-labels`.

To upgrade Lab Labels, change the image version in `create-container`, stop the
service, remove the existing `lab-labels` container with `docker container rm`,
run the `create-container` script, and restart the service.
