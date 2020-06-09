SHELL := /bin/bash -euo pipefail

crontabs := \
	id3c-production \
	website-science-map \
	scan-return-of-results \
	scan-amazon-addresses \
	scan-switchboard

install: $(crontabs:%=/etc/cron.d/backoffice-%)

/etc/cron.d/backoffice-%: %
	@install -cv $< $@
