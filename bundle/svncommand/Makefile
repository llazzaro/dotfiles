# $Id: Makefile 23 2005-04-17 14:06:35Z laz $

REV=$(shell head -1 NEWS.txt | awk '{print $$2}')

plugin/svncommand-autogenned.vim: plugin/cvscommand.vim
	./cvs2svn.sed < $< > $@

svncommand.diff: plugin/svncommand-autogenned.vim plugin/svncommand.vim
	diff -u $^ > $@ || true

diff: svncommand.diff
auto: plugin/svncommand-autogenned.vim

svncommand-${REV}:
	rm -rf $@
	repo=$$(svn info | awk '/URL: / { print $$2 }' | sed -e 's/trunk/tags/') ; \
	svn export $$repo/${REV} $@


svncommand-${REV}.tar.gz: svncommand-${REV}
	tar -czvf $@ $<

release:
	${MAKE} svncommand-${REV}.tar.gz

clean:
	rm -rf plugin/svncommand-autogenned.vim svncommand.diff svncommand-*

.PHONY: clean svncommand-${REV} release
