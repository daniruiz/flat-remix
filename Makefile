PKGNAME = flat-remix
MAINTAINER = Daniel Ruiz de Alegría <daniel@drasite.com>
UBUNTU_RELEASE = impish
PREFIX ?= /usr
THEMES ?= $(patsubst %/index.theme,%,$(wildcard ./*/index.theme))
COLOR_VARIANTS ?= Blue Green Red Yellow Black Brown Cyan Grey Magenta Orange Teal Violet


all:

generate_folder_variants:
	find color-folder -type d -name 'places-*' ! -name 'places-blue' \
	| while read folder_variant; do \
		color_variant=$$(echo $$folder_variant | sed -E 's/.*-([a-z])([a-z]+)$$/\U\1\L\2/g'); \
		for variant in Dark Light; do \
			new_theme="Flat-Remix-$${color_variant}-$${variant}"; \
			rm -rf $$new_theme; \
			cp -a "Flat-Remix-Blue-$${variant}" $$new_theme; \
			rm -rf "$${new_theme}/places/scalable/"; \
			cp -a $$folder_variant "$${new_theme}/places/scalable/"; \
			sed -i "s/Name=.*/Name=$${new_theme}/" "$${new_theme}/index.theme"; \
		done; \
	done

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
	variants="Light Dark"; \
	count=1; \
	for color_variant in $(COLOR_VARIANTS); \
	do \
		for variant in $$variants; \
		do \
			count_pretty=$$(echo "0$${count}" | tail -c 3); \
			tar -c "Flat-Remix-$${color_variant}-$${variant}"* | \
				xz -z - > "$${count_pretty}-Flat-Remix-$${color_variant}-$${variant}_$(VERSION).tar.xz"; \
			count=$$((count+1)); \
		done; \
	done; \

release: _get_version
	$(MAKE) generate_changelog VERSION=$(VERSION)
	$(MAKE) aur_release VERSION=$(VERSION)
	$(MAKE) copr_release VERSION=$(VERSION)
	#$(MAKE) launchpad_release VERSION=$(VERSION)
	git tag -f $(VERSION)
	git push origin --tags
	$(MAKE) dist

aur_release: _get_version _get_tag
	cd aur; \
	sed "s/$(TAG)/$(VERSION)/g" -i PKGBUILD .SRCINFO; \
	git commit -a -m "$(VERSION)"; \
	git push origin master;

	git commit aur -m "Update aur version $(VERSION)"
	git push origin master

copr_release: _get_version _get_tag
	sed "s/$(TAG)/$(VERSION)/g" -i $(PKGNAME).spec
	git commit $(PKGNAME).spec -m "Update $(PKGNAME).spec version $(VERSION)"
	git push origin master

launchpad_release: _get_version
	rm -rf /tmp/$(PKGNAME)
	mkdir -p /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION)
	cp -a * /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION)
	cd /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION); \
	echo "$(PKGNAME) ($(VERSION)) $(UBUNTU_RELEASE); urgency=low" > debian/changelog; \
	echo >> debian/changelog; \
	echo "  * Release $(VERSION)" >> debian/changelog; \
	echo >> debian/changelog; \
	echo " -- $(MAINTAINER)  $$(date -R)" >> debian/changelog; \
	debuild -S -d; \
	dput ppa:daniruiz/flat-remix /tmp/$(PKGNAME)/$(PKGNAME)_$(VERSION)_source.changes

generate_changelog: _get_version _get_tag
	git checkout $(TAG) CHANGELOG
	mv CHANGELOG CHANGELOG.old
	echo [$(VERSION)] > CHANGELOG
	printf "%s\n\n" "$$(git log --pretty=format:' * %s' $(TAG)..HEAD)" >> CHANGELOG
	cat CHANGELOG.old >> CHANGELOG
	rm CHANGELOG.old
	$$EDITOR CHANGELOG
	git commit CHANGELOG -m "Update CHANGELOG version $(VERSION)"
	git push origin HEAD

.PHONY: all install $(THEMES) uninstall _get_version _get_tag dist release aur_release copr_release launchpad_release undo_release generate_changelog
