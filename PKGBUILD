# Maintainer: Lit Wakefield <nocturnalartifice[at]gmail[dot]com>

_pkgname=tdrop
pkgname=tdrop-git
pkgver=
pkgrel=1
pkgdesc="A WM-Independent dropdown window and terminal creator"
arch=('any')
url="https://github.com/angelic-sedition/tdrop"
license=('Simplified BSD')
depends=('bash' 'xdotool' 'xorg-xwininfo' 'xorg-xprop')
optdepends=('tmux: session starting support' 
            'tmuxinator: session starting support'
            'sxhkd: for a tdrop keybinding')
makedepends=('git')
provides=("${_pkgname}")
md5sums=('SKIP')
source=("git://github.com/angelic-sedition/${_pkgname}.git")

pkgver() {
  cd "$srcdir/$_pkgname"
  git describe --long | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
}

package() {
  cd "$srcdir/$_pkgname"
  make PREFIX=/usr DESTDIR="$pkgdir" install
}
