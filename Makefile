PREFIX = /usr

LIBS = \
	general.sh

COMMANDS = \
	install\
	validate\
	generate-changelog

all:

test:
	bats tests

doc:
	scdoc < doc/decomposer.scd > man/decomposer.1
	for c in ${COMMANDS}; do \
		scdoc < doc/decomposer-$$c.scd > man/decomposer-$$c.1; \
	done

install:
	install -D bin/decomposer "${DESTDIR}${PREFIX}/bin/decomposer"

	for l in ${LIBS}; do \
		install -Dm644 "lib/decomposer/$$l" "${DESTDIR}${PREFIX}/lib/decomposer/$$l"; \
	done

	for c in ${COMMANDS}; do \
		install -D "libexec/decomposer/decomposer-$$c" "${DESTDIR}${PREFIX}/libexec/decomposer/decomposer-$$c"; \
	done

	install -Dm644 man/decomposer.1 "${DESTDIR}${PREFIX}/share/man/man1/decomposer.1"
	for c in ${COMMANDS}; do \
		install -Dm644 "man/decomposer-$$c.1" "${DESTDIR}${PREFIX}/share/man/man1/decomposer-$$c.1"; \
	done

uninstall:
	rm -f "${DESTDIR}${PREFIX}/bin/decomposer"

	for l in ${LIBS}; do \
		rm -f "${DESTDIR}${PREFIX}/lib/decomposer/$$l"; \
	done

	for c in ${COMMANDS}; do \
		rm -f "${DESTDIR}${PREFIX}/libexec/decomposer/decomposer-$$c"; \
	done

	rm -f "${DESTDIR}${PREFIX}/share/man/man1/decomposer.1"
	for c in ${COMMANDS}; do \
		rm -f "${DESTDIR}${PREFIX}/share/man/man1/decomposer-$$c.1"; \
	done

.PHONY: all test doc install uninstall
