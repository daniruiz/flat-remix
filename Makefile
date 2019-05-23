# GNU make is required to run this file. To install on *BSD, run:
#   gmake PREFIX=/usr/local install

PREFIX ?= /usr
IGNORE ?=
THEMES ?= $(patsubst %/index.theme,%,$(wildcard ./*/index.theme))
PKGNAME = flat-remix
MAINTAINER = Daniel Ruiz de Alegría <daniel@drasite.com>

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
	$(eval VERSION ?= $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

_get_tag:
	$(eval TAG := $(shell git describe --abbrev=0 --tags))
	@echo $(TAG)

dist: _get_version
	git archive --format=tar.gz -o $(notdir $(CURDIR))-$(VERSION).tar.gz master -- $(THEMES)

release: _get_version
	$(MAKE) aur_release VERSION=$(VERSION)
	$(MAKE) copr_release VERSION=$(VERSION)
	git tag -f $(VERSION)
	git push origin --tags

aur_release: _get_version _get_tag
	cd aur; \
	sed "s/$(TAG)/$(VERSION)/g" -i PKGBUILD .SRCINFO; \
	git commit -a -m "Update aur version $(VERSION)"; \
	git push origin master;

	git commit aur -m "$(VERSION)"
	git push origin master

	$(MAKE) launchpad_release

copr_release: _get_version _get_tag
	sed "s/$(TAG)/$(VERSION)/g" -i $(PKGNAME).spec
	git commit $(PKGNAME).spec -m "Update $(PKGNAME).spec version $(VERSION)"
	git push origin master

launchpad_release: _get_version _get_tag
	cp -a Flat-Remix* Makefile deb/$(PKGNAME)
	sed "s/$(TAG)/$(VERSION)/g" -i deb/$(PKGNAME)/debian/changelog-template
	cd deb/$(PKGNAME)/debian/ && echo " -- $(MAINTAINER)  $$(date -R)" | cat changelog-template - > changelog
	cd deb/$(PKGNAME) && debuild -S -d
	dput ppa deb/$(PKGNAME)_$(VERSION)_source.changes

undo_release: _get_tag
	-git tag -d $(TAG)
	-git push --delete origin $(TAG)


.PHONY: all install $(THEMES) uninstall _get_version _get_tag dist release aur_release copr_release launchpad_release undo_release

# .BEGIN is ignored by GNU make so we can use it as a guard
.BEGIN:
	@head -3 Makefile
	@false
