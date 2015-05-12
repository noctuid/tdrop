install:
	install -D tdrop $(DESTDIR)/usr/bin/tdrop
	install -D -m 644 tdrop.groff $(DESTDIR)/usr/share/man/man1/tdrop.1
