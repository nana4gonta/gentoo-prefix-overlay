# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/cmigemo/cmigemo-1.3c-r2.ebuild,v 1.4 2012/06/14 09:33:05 jdhore Exp $

EAPI=2
inherit eutils flag-o-matic multilib toolchain-funcs mercurial

DESCRIPTION="C/Migemo -- Migemo library implementation in C"
HOMEPAGE="http://www.kaoriya.net/#CMIGEMO"
EHG_REPO_URI="https://code.google.com/p/cmigemo/"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x64-macos"
IUSE="emacs unicode vim-syntax"

DEPEND=">=app-dicts/migemo-dict-200812[unicode=]
	dev-lang/perl
	|| (
		net-misc/curl
		net-misc/wget
		net-misc/fetch
	)
	app-i18n/nkf"
RDEPEND="${RDEPEND}
	emacs? ( >=app-text/migemo-0.40-r1 )"

#src_unpack() {
#	mercurial_fetch
#}

src_prepare() {
	# Bug #246953
#	epatch "${FILESDIR}/${P}-gentoo.patch" \
#		"${FILESDIR}"/${P}-ldflags.patch

	touch dict/SKK-JISYO.L
	if use unicode ; then
		sed -i -e "/gcc:/s/euc-jp/utf-8/" dict/dict.mak || die
	fi

	# Bug #255813
	sed -i -e "/^docdir/s:/doc/migemo:/share/doc/${PF}:" compile/config.mk.in || die
}

src_compile() {
	local target
	if [[ ${CHOST} == *-darwin* ]] ; then
		target="osx"

		# fix install_name (gcc option)
		sed -i -e "s/\$@/\${EPREFIX}\/usr\/lib\/\$@/" compile/Make_osx.mak || die
	else
		target="gcc"
	fi

	append-flags -fPIC
	# parallel make b0rked
	emake -j1 \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		${target}-all || die
}

src_install() {
	local target
	if [[ ${CHOST} == *-darwin* ]] ; then
		target="osx"
	else
		target="gcc"
	fi

	# parallel make b0rked
	emake -j1 \
		prefix="${ED}/usr" \
		libdir="${ED}/usr/$(get_libdir)" \
		${target}-install || die

	local encoding
	if use unicode ; then
		encoding="utf-8"
	else
		encoding="euc-jp"
	fi

	mv "${ED}/usr/share/migemo/${encoding}/"*.dat "${ED}/usr/share/migemo/"
	rm -rf "${ED}/usr/share/migemo/"{cp932,euc-jp,utf-8}

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/plugin
		doins tools/migemo.vim
	fi

	dodoc doc/{README_j,TODO_j,vimigemo}.txt
}

pkg_postinst() {
	if use emacs ; then
		elog
		elog "Please add to your ~/.emacs"
		elog "    (setq migemo-command \"cmigemo\")"
		elog "    (setq migemo-options '(\"-q\" \"--emacs\" \"-i\" \"\\\\a\"))"
		elog "    (setq migemo-dictionary \"/usr/share/migemo/migemo-dict\")"
		elog "    (setq migemo-user-dictionary nil)"
		elog "    (setq migemo-regex-dictionary nil)"
		elog "to use cmigemo instead of migemo under emacs."
		elog
	fi
}
