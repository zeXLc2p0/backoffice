SHELL := /bin/bash -euo pipefail
CROND ?= /etc/cron.d

crontabs := \
	id3c-production \
	public-datasets \
	return-of-results \
	scan-switchboard \
	uw-ehs-report

old_crontabs := \
	scan-amazon-addresses

install: $(crontabs:%=$(CROND)/backoffice-%)
	@rm -fv $(old_crontabs:%=$(CROND)/backoffice-%)

$(CROND)/backoffice-%: %
	@install -cv $< $@
