#
# @file Makefile
# @version 1.0
#
# @section License
# Copyright (C) 2014-2015, Erik Moqvist
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# This file is part of the Simba project.
#

.PHONY: tags

BOARD ?= linux

TESTS = $(addprefix tst/kernel/,event fs log prof queue sem shell std sys thrd timer)
TESTS += $(addprefix tst/slib/,hash_map)

APPS = $(TESTS)

ifneq ($(BOARD),linux)
    APPS += $(addprefix tst/drivers/,adc cantp ds18b20 exti mcp2515 owi pin uart)
endif

all: $(APPS:%=%.all)

release: $(APPS:%=%.release)

clean: $(APPS:%=%.clean)

run: $(TESTS:%=%.run)

size: $(TESTS:%=%.size)

report:
	for t in $(TESTS) ; do $(MAKE) -C $(basename $$t) report ; echo ; done

test: run
	$(MAKE) report

jenkins-coverage: $(TESTS:%=%.jc)

$(APPS:%=%.all):
	$(MAKE) -C $(basename $@) all

$(APPS:%=%.release):
	$(MAKE) -C $(basename $@) release

$(APPS:%=%.clean):
	$(MAKE) -C $(basename $@) clean

$(APPS:%=%.size):
	$(MAKE) -C $(basename $@) size

$(TESTS:%=%.run):
	$(MAKE) -C $(basename $@) run

$(TESTS:%=%.report):
	$(MAKE) -C $(basename $@) report

$(TESTS:%=%.jc):
	$(MAKE) -C $(basename $@) jenkins-coverage

tags:
	echo "Creating tags file .TAGS"
	etags -o .TAGS $$(git ls-files *.[hci] | xargs)

help:
	@echo "--------------------------------------------------------------------------------"
	@echo "  target                      description"
	@echo "--------------------------------------------------------------------------------"
	@echo "  all                         compile and link the application"
	@echo "  clean                       remove all generated files and folders"
	@echo "  run                         run the application"
	@echo "  report                      print test report"
	@echo "  test                        run + report"
	@echo "  release                     compile with NDEBUG=yes and NPROFILE=yes"
	@echo "  size                        print executable size information"
	@echo "  help                        show this help"
	@echo
