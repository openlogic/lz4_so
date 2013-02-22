REVISION=88
VERSION=0r$(REVISION)
PATCH=1
URL=http://lz4.googlecode.com/svn/trunk/
WORKDIR=lz4-$(VERSION)
PREFIX?=build
UNAME?=$(shell uname)
DEBUG=true

ifeq ($(UNAME),Darwin)
	LIBEXT=dylib
else
	LIBEXT=so
endif

default: install

all:
	make -C $(WORKDIR) $@

clean:
	-rm -fr $(WORKDIR)

distclean:
	-rm -fr $(PREFIX)/lib/liblz4*
	-rm -fr $(PREFIX)/include/lz4*

$(PREFIX)/lib:
	mkdir -p $@

$(PREFIX)/include:
	mkdir -p $@

$(WORKDIR):
	svn export $(URL)@$(REVISION) $(WORKDIR)

workdir: $(WORKDIR)
	@# nothing to do

configure: workdir
	@# nothing to do

$(WORKDIR)/liblz4.$(LIBEXT).$(VERSION): configure
	cc -shared -Wl,-soname,liblz4.$(LIBEXT).$(VERSION) -fPIC -o $@ $(WORKDIR)/lz4.c $(WORKDIR)/lz4hc.c

$(PREFIX)/lib/liblz4.$(LIBEXT).$(VERSION): | build
	install $(WORKDIR)/liblz4.$(LIBEXT).$(VERSION) $(PREFIX)/lib

$(PREFIX)/lib/liblz4.$(LIBEXT): | $(PREFIX)/lib/liblz4.$(LIBEXT).$(VERSION)
	ln -s liblz4.$(LIBEXT).$(VERSION) $@

$(PREFIX)/include/lz4.h: | build
	install -m 644 $(WORKDIR)/lz4.h $(PREFIX)/include

$(PREFIX)/include/lz4hc.h: | build
	install -m 644 $(WORKDIR)/lz4hc.h $(PREFIX)/include

build: $(WORKDIR)/liblz4.$(LIBEXT).$(VERSION)

install: $(PREFIX)/lib \
         $(PREFIX)/include \
         $(PREFIX)/lib/liblz4.$(LIBEXT).$(VERSION) \
         $(PREFIX)/lib/liblz4.$(LIBEXT) \
         $(PREFIX)/include/lz4.h

rpm deb: | install
	-rm -fr *.deb *.rpm 
	fpm -s dir -t $@ -n liblz4 -v $(VERSION)-$(PATCH) --prefix /usr \
                -C build \
		--description "lz4 fast compression" \
		--url "http://code.google.com/p/lz4/" \
		lib
	fpm -s dir -t $@ -n liblz4-dev -v $(VERSION)-$(PATCH) --prefix /usr \
                -C build \
		--description "lz4 fast compression" \
		--url "http://code.google.com/p/lz4/" \
		include
