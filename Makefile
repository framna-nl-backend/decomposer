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

install:
	install -D bin/decomposer "${DESTDIR}${PREFIX}/bin/decomposer"

	for l in ${LIBS}; do \
		install -Dm644 "lib/decomposer/$$l" "${DESTDIR}${PREFIX}/lib/decomposer/$$l"; \
	done

	for c in ${COMMANDS}; do \
		install -D "libexec/decomposer/decomposer-$$c" "${DESTDIR}${PREFIX}/libexec/decomposer/decomposer-$$c"; \
	done

uninstall:
	rm -f "${DESTDIR}${PREFIX}/bin/decomposer"

	for l in ${LIBS}; do \
		rm -f "${DESTDIR}${PREFIX}/lib/decomposer/$$l"; \
	done

	for c in ${COMMANDS}; do \
		rm -f "${DESTDIR}${PREFIX}/libexec/decomposer/decomposer-$$c"; \
	done

.PHONY: all test install uninstall
