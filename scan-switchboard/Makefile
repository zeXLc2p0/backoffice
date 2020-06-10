SHELL := /bin/bash -euo pipefail

uvicorn-apps := \
	scan-switchboard.service

install: $(uvicorn-apps:%=/etc/systemd/system/%)

/etc/systemd/system/%: %
	@install -cv $< $@
