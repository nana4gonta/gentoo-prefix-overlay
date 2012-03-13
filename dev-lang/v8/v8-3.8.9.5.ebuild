# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/v8/v8-3.8.9.5.ebuild,v 1.1 2012/02/09 20:44:40 floppym Exp $

EAPI="4"

PYTHON_DEPEND="2:2.6"

inherit eutils flag-o-matic multilib pax-utils scons-utils python toolchain-funcs versionator

DESCRIPTION="Google's open source JavaScript engine"
HOMEPAGE="http://code.google.com/p/v8"
SRC_URI="http://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos ~x86-macos"
IUSE=""

pkg_pretend() {
	local gccver=$(gcc-fullversion)
	if [[ ${gccver} = 4.5.2 ]]; then
		eerror "The currently selected version of gcc is known to segfault when building this"
		eerror "version of V8. Please use at least gcc-4.5.3."
		die "gcc-${gccver} detected."
	fi
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_compile() {
	tc-export AR CC CXX RANLIB
	export LINK="${CXX}"

	export LINKFLAGS="${LDFLAGS}"
	local myconf="library=shared
	soname=on importenv=LINKFLAGS,PATH"

	# Use target arch detection logic from bug #354601.
	case ${CHOST} in
		i?86-*) myarch=x86 ;;
		x86_64-*)
			if [[ $ABI = "" ]] ; then
				myarch=amd64
			else
				myarch="$ABI"
			fi ;;
		arm*-*) myarch=arm ;;
		*) die "Unrecognized CHOST: ${CHOST}"
	esac

	if [[ $myarch = amd64 ]] ; then	
		myconf+=" arch=x64"
	elif [[ $myarch = x86 ]] ; then
		myconf+=" arch=ia32"
	elif [[ $myarch = arm ]] ; then
		myconf+=" arch=arm"
	else 
		die "Failed to determine target arch, got '$myarch'."
	fi

	local snapshot=on
	host-is-pax && snapshot=off

	escons $(use_scons readline console readline dumb) ${myconf} \
	       snapshot=${snapshot} mode=release || die
}

src_test() {
	local arg testjobs
	for arg in ${MAKEOPTS}; do
		case ${arg} in
			-j*) testjobs=${arg#-j} ;;
			--jobs=*) testjobs=${arg#--jobs=} ;;
		esac
	done

	tools/test-wrapper-gypbuild.py \
		-j${testjobs:-1} \
		--arch-and-mode=${mytarget} \
		--no-presubmit \
		--progress=dots || die
}

src_install()
{
	insinto /usr
	doins -r include || die

	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libv8-${PV}$(get_libname) \
			libv8-${PV}$(get_libname) || die
	fi

	dolib libv8-${PV}$(get_libname) || die
	dosym libv8-${PV}$(get_libname) /usr/$(get_libdir)/libv8$(get_libname) || die

	dodoc AUTHORS ChangeLog || die
}


pkg_preinst() {
	preserved_libs=()
	local baselib candidate

	eshopts_push -s nullglob

	for candidate in "${EROOT}usr/$(get_libdir)"/libv8-*$(get_libname) \
		"${EROOT}usr/$(get_libdir)"/libv8$(get_libname).*; do
		baselib=${candidate##*/}
		if [[ ! -e "${ED}usr/$(get_libdir)/${baselib}" ]]; then
			preserved_libs+=( "${EPREFIX}/usr/$(get_libdir)/${baselib}" )
		fi
	done

	eshopts_pop

	if [[ ${#preserved_libs[@]} -gt 0 ]]; then
		preserve_old_lib "${preserved_libs[@]}"
	fi
}

pkg_postinst() {
	if [[ ${#preserved_libs[@]} -gt 0 ]]; then
		preserve_old_lib_notify "${preserved_libs[@]}"
	fi
}
