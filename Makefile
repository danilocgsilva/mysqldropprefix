BIN ?= mysqldropprefix
PREFIX ?= /usr/local

install:
	cp mysqldropprefix.sh $(PREFIX)/bin/$(BIN)
	chmod +x $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
