DESTDIR ?= /
PREFIX ?= /usr

bindir := $(PREFIX)/bin
datadir := $(PREFIX)/share
libexecdir := $(PREFIX)/libexec

MANDIR ?= $(datadir)/man
man1dir := $(MANDIR)/man1

LIBS := \
	helpers.sh

COMMANDS := \
	install\
	validate\
	generate-changelog \
	lock

all:

test:
	bats tests

doc:
	scdoc < doc/decomposer.scd > man/decomposer.1
	for c in ${COMMANDS}; do \
		scdoc < doc/decomposer-$$c.scd > man/decomposer-$$c.1; \
	done

install:
	install -d "${DESTDIR}$(bindir)"
	install "bin/decomposer" "${DESTDIR}$(bindir)"

	install -d "${DESTDIR}$(datadir)/decomposer";
	for l in ${LIBS}; do \
		install -m644 "share/decomposer/$$l" "${DESTDIR}$(datadir)/decomposer/$$l"; \
	done

	install -d "${DESTDIR}$(libexecdir)/decomposer/";
	for c in ${COMMANDS}; do \
		install "libexec/decomposer/decomposer-$$c" "${DESTDIR}$(libexecdir)/decomposer/decomposer-$$c"; \
	done

	install -d "${DESTDIR}$(man1dir)"
	install -m644 "man/decomposer.1" "${DESTDIR}$(man1dir)/decomposer.1"
	for c in ${COMMANDS}; do \
		install -m644 "man/decomposer-$$c.1" "${DESTDIR}$(man1dir)/decomposer-$$c.1"; \
	done

uninstall:
	rm -f "${DESTDIR}$(bindir)/decomposer"

	for l in ${LIBS}; do \
		rm -f "${DESTDIR}$(datadir)/decomposer/$$l"; \
	done
	rm -rf "${DESTDIR}$(datadir)/decomposer"

	for c in ${COMMANDS}; do \
		rm -f "${DESTDIR}$(libexecdir)/decomposer/decomposer-$$c"; \
	done
	rm -rf "${DESTDIR}$(libexecdir)/decomposer"

	rm -f "${DESTDIR}$(man1dir)/decomposer.1"
	for c in ${COMMANDS}; do \
		rm -f "${DESTDIR}$(man1dir)/decomposer-$$c.1"; \
	done

.PHONY: all test doc install uninstall
