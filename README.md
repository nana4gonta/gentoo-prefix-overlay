# Overview
I fixed or added ebuild files for Gentoo Prefix/MacOSX.
these were tested in MacOSX Lion.

note: I do not still make sure of installing in Mountain Lion.

# Usage
1.open ${EPREFIX}/etc/layman/layman.cfg
2. add URL in a item "overlays"
    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
	  http://github.com/nana4gonta/gentoo-prefix-overlay/raw/master/repository.xml
3. enter the command
    layman -a naota-prefix

