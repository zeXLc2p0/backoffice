SHELL := /bin/bash -euo pipefail
CROND ?= /etc/cron.d

crontabs := \
	id3c-production \
	return-of-results \
	scan-amazon-addresses \
	scan-switchboard \
	uw-ehs-report


install: $(crontabs:%=$(CROND)/backoffice-%)

$(CROND)/backoffice-%: %
	@install -cv $< $@
