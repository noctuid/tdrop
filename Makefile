PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man

install:
	# 755 is default
	install -D -m 755 tdrop "$(DESTDIR)$(BINDIR)"
	install -D -m 644 tdrop.groff "$(DESTDIR)$(MANDIR)"/man1/tdrop.1

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)"/tdrop
	rf -rf "$(DESTDIR)$(MANDIR)"
