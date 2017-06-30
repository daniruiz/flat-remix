# Maintainer:  DяA <daniruizdealegria@gmail.com>

pkgname=flat-remix
pkgver=r87.adc62f9
pkgrel=1
pkgdesc="Flat remix is a pretty simple icon theme inspired on material design. It is mostly flat with some shadows, highlights and gradients for some depth and uses a colorful palette with nice contrasts."
arch=('any')
url="https://github.com/daniruiz/Flat-Remix/"
license=('GPL-3.0')
depends=('xdg-utils')
source=("${pkgname}::git+https://github.com/daniruiz/Flat-Remix.git")

sha256sums=('SKIP')

pkgver() {
	cd "${pkgname}"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
	cd "${srcdir}/${pkgname}/"
	install -dm755 "${pkgdir}/usr/share/icons"
	cp -a "Flat Remix" "${pkgdir}/usr/share/icons/Flat Remix"
	install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
