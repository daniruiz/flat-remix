# GNU make is required to run this file. To install on *BSD, run:
#   gmake PREFIX=/usr/local install

PREFIX ?= /usr
IGNORE ?=
THEMES ?= $(patsubst %/index.theme,%,$(wildcard ./*/index.theme))

# excludes IGNORE from THEMES list
THEMES := $(filter-out $(IGNORE), $(THEMES))

all:

install:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons
	cp -R $(THEMES) $(DESTDIR)$(PREFIX)/share/icons

	# skip building icon caches when packaging
	$(if $(DESTDIR),,$(MAKE) $(THEMES))

$(THEMES):
	-gtk-update-icon-cache -q $(DESTDIR)$(PREFIX)/share/icons/$@

uninstall:
	-rm -rf $(foreach theme,$(THEMES),$(DESTDIR)$(PREFIX)/share/icons/$(theme))

_get_version:
	$(eval VERSION := $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

_get_tag:
	$(eval TAG := $(shell git describe --abbrev=0 --tags))
	@echo $(TAG)

dist: _get_version
	git archive --format=tar.gz -o $(notdir $(CURDIR))-$(VERSION).tar.gz master -- $(THEMES)

release: _get_version
	git tag -f $(VERSION)
	$(MAKE) aur_release
	$(MAKE) copr_release
	git push origin --tags

aur_release: _get_tag
	cd aur; \
	sed "s/pkgver\s*=.*/pkgver=$(TAG)/" -i PKGBUILD .SRCINFO; \
	makepkg --printsrcinfo > .SRCINFO; \
	git commit -a -m "$(TAG)"; \
	git push origin;

	git commit aur -m "$(TAG)"
	git push origin

copr_release: _get_tag
	sed "s/Version:.*/Version: $(TAG)/" -i flat-remix-gtk.spec
	git commit flat-remix-gtk.spec -m "Update flat-remix-gtk.spec version $(TAG)"
	git push origin

undo_release: _get_tag
	-git tag -d $(TAG)
	-git push --delete origin $(TAG)


.PHONY: $(THEMES) all install uninstall _get_version dist release undo_release

# .BEGIN is ignored by GNU make so we can use it as a guard
.BEGIN:
	@head -3 Makefile
	@false
