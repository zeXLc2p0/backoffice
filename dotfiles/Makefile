SHELL := /bin/bash -euo pipefail
HOME ?= /home/ubuntu

dotfiles := \
	gitconfig

install: $(dotfiles:%=$(HOME)/.%)

$(HOME)/.%: %
	@install -cv --mode=ug=r,o= --compare --backup=numbered $< $@
