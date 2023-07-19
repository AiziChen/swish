MAKEFLAGS += --no-print-directory
.PHONY: clean coverage install pristine swish test

swish: src/swish/Makefile
	$(MAKE) -C src/swish all

src/swish/Makefile:
	@echo "Run ./configure to create $@"
	@exit 1

test: src/swish/Makefile
	@$(MAKE) -C src/swish mat-prereq
	@./src/run-mats

coverage: src/swish/Makefile
	@PROFILE_MATS=yes $(MAKE) -C src/swish mat-prereq
	@PROFILE_MATS=yes ./src/run-mats

check-astyle:
	@(astyle --project $$(git ls-files '*.c' '*.h' | grep -v 'sqlite3'))

warn-letrec-check:
	@WARN_UNDEFINED=yes $(MAKE) -C src/swish all

install: swish
	$(MAKE) -C src/swish install

clean: src/swish/Makefile
	$(MAKE) -C src/swish clean

pristine: clean
	$(MAKE) -C src/swish pristine
	rm -f src/swish/Makefile
	rm -f src/swish/Mf-config
	rm -f src/swish/sh-config
	rm -f src/osi-bootstrap.ss
