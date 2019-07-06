# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_5 python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="A Python library for reading and writing PDF, powered by qpdf"
HOMEPAGE="https://pikepdf.readthedocs.io/"
SRC_URI="https://github.com/pikepdf/pikepdf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

DEPEND="
	app-text/qpdf
	dev-python/pybind11[${PYTHON_USEDEP}]
	"

python_test() {
	pytest -v || die "Tests fail with ${EPYTHON}"
}
