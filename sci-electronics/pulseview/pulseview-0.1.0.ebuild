# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_COMPAT=( python3_{2,3,4} )
inherit eutils cmake-utils python-single-r1
if [ ${PV} = 9999 ]; then
	inherit git-2
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	KEYWORDS=""
else
	SRC_URI="http://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="a Qt based logic analyzer GUI for sigrok."
HOMEPAGE="http://sigrok.org/"

REQUIRED_USE="sigrokdecode? ( ${PYTHON_REQUIRED_USE} )"
LICENSE="GPL-3"
SLOT="0"
IUSE="+sigrokdecode static"

CMAKE_MIN_VERSION=2.6

# >=automake-1.11
# >=autoconf-2.63
RDEPEND=">=sci-electronics/libsigrok-0.2.0
	sigrokdecode? ( >=sci-electronics/libsigrokdecode-0.2.0 ${PYTHON_DEPS} )
	>=dev-libs/glib-2.28.0
	dev-qt/qtgui:4
	>=dev-libs/boost-1.42"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
#	>=dev-util/pkgconfig-0.22

pkg_setup () {
	python-single-r1_pkg_setup
}

src_configure() {
	# TODO: test support via ENABLE_TESTS
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
		$(cmake-utils_use_enable sigrokdecode DECODE)
	)
	if use static; then
		mycmakeargs+=( -DSTATIC_PKGDEPS_LIBS=TRUE )
	else
		mycmakeargs+=( -DSTATIC_PKGDEPS_LIBS=FALSE )
	fi
	cmake-utils_src_configure
}
