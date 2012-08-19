# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit distutils git-2
PYTHON_DEPEND="2"

DESCRIPTION="Adds flavor of interactive selection to the traditional pipe concept on UNIX"
HOMEPAGE="https://github.com/mooz/percol"
EGIT_REPO_URI=$HOMEPAGE
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS="~x64-macos"
IUSE=""

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

