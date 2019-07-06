# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_5 python3_6 )
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

inherit cmake-utils distutils-r1

DESCRIPTION="pybind11 - Seamless operability between C++11 and Python"
HOMEPAGE="https://pybind11.readthedocs.io/"
SRC_URI="https://github.com/pybind/pybind11/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND="
	dev-cpp/eigen
	dev-libs/boost
	"

DEPEND="
	dev-util/cmake
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pluggy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/breathe[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	"

python_install_all() {
	if use doc; then
		rm -fr docs/_build/html/_sources || die
		local HTML_DOCS=( docs/.build/html/. )
	fi

	insinto "${MY_HTDOCSDIR#${EPREFIX}}"
	distutils-r1_python_install_all
}

src_prepare() {
	eapply_user
	mkdir -p "${S}/build-cmake"
}

src_compile() {
	cd ${S}
	python setup.py build
	cd "${S}/build-cmake"
	cmake -DCMAKE_INSTALL_PREFIX:PATH='/usr' -Wno-dev ..
	make all mock_install
	cd "${S}/docs"
	make man
	if use doc; then
		make html
	fi
}

src_install() {
	distutils-r1_src_install --install-headers='/usr/include/pybind11' --skip-build --optimize='1'
	cd "${S}/docs/.build/man"
	sed -i '/^\.TH/s/"1"/"7"/' "${PN}.1"
	newman "${PN}.1" "${PN}.7"
}

src_test() {
	cd ${S}
	emake -C build-cmake check
}
