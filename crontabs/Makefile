SHELL := /bin/bash -euo pipefail

crontabs := \
	id3c-production \
	website-science-map

install: $(crontabs:%=/etc/cron.d/backoffice-%)

/etc/cron.d/backoffice-%: %
	@install -cv $< $@
