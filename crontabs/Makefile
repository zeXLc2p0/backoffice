SHELL := /bin/bash -euo pipefail

crontabs := \
	id3c-production \
	return-of-results \
	scan-amazon-addresses \
	scan-switchboard \
	uw-ehs-report

install: $(crontabs:%=/etc/cron.d/backoffice-%)

/etc/cron.d/backoffice-%: %
	@install -cv $< $@
