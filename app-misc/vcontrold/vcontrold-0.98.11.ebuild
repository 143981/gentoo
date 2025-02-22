# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-any-r1

DESCRIPTION="Daemon for communication with Viessmann Vito heatings"
HOMEPAGE="https://github.com/openv/vcontrold/"
SRC_URI="https://github.com/openv/vcontrold/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+man +vclient vsim"

DEPEND="dev-libs/libxml2:2"
RDEPEND="${DEPEND}"
BDEPEND="man? ( $(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]') )"

src_prepare() {
	sed "s/@VERSION@/${PV}/" "src/version.h.in" \
		> "src/version.h" || die "Setting version failed"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMANPAGES="$(usex man)"
		-DVCLIENT="$(usex vclient)"
		-DVSIM="$(usex vsim)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doinitd "${FILESDIR}/vcontrold"
	insinto /etc/vcontrold/
	doins -r xml
}
