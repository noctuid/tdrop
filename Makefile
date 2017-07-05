PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
LICENSEDIR = $(PREFIX)/share/licenses

install:
	# 755 is default
	install -D -m 755 tdrop "$(DESTDIR)$(BINDIR)"/tdrop
	install -D -m 644 tdrop.1 "$(DESTDIR)$(MANDIR)"/man1/tdrop.1
	install -D -m 644 LICENSE "$(DESTDIR)$(LICENSEDIR)"/tdrop/LICENSE

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)"/tdrop
	rm -f "$(DESTDIR)$(MANDIR)"/man1/tdrop.1
	rm -rf "$(DESTDIR)$(LICENSEDIR)/tdrop"
