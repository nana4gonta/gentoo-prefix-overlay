# Overview
I fixed or added ebuild files for Gentoo Prefix/MacOSX.
these were tested in MacOSX Lion.

Note: I do not still make sure of installing in Mountain Lion.

# Usage
* open ${EPREFIX}/etc/layman/layman.cfg
* add URL in a item "overlays"
    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
	  http://github.com/nana4gonta/gentoo-prefix-overlay/raw/master/repository.xml
* enter the command
    layman -a naota-prefix

