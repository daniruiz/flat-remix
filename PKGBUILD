# Maintainer: Daniel Ruiz de Alegria <daniruizdealegria@gmail.com>

pkgname="flat-remix-git"
pkgver=20171129
pkgrel=1
pkgdesc="Flat remix is a pretty simple icon theme inspired on material design."
arch=('any')
url="https://github.com/daniruiz/Flat-Remix/"
license=('GPL 3.0')
source=("${pkgname}::git+https://github.com/daniruiz/Flat-Remix.git")
sha256sums=('SKIP')

pkgver() {
	cd ${pkgname}
	git log -1 --format="%cd" --date=short | tr -d '-'
}

package() {
	cd "${srcdir}/${pkgname}/"
	install -dm755 "${pkgdir}/usr/share/icons"
	cp -a "Flat Remix"* "${pkgdir}/usr/share/icons/"
    install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"  
}
