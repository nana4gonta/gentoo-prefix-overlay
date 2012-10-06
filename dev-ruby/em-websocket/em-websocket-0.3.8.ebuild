# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_NAME=em-websocket

# RUBY_FAKEGEM_TASK_DOC="docs"
# RUBY_FAKEGEM_DOCDIR="doc"
# RUBY_FAKEGEM_EXTRADOC="README.txt History.txt example.txt example1.rb example2.rb example_dot_autotest.rb"

inherit ruby-fakegem

DESCRIPTION="EventMachine based, async, Ruby WebSocket server."
HOMEPAGE="https://github.com/igrigorik/em-websocket"
LICENSE="MIT"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/eventmachine-0.12.9
	>=dev-ruby/addressable-2.1.1
	"

# ruby_add_bdepend "
# 	test? (
# 		dev-ruby/bundler
# 		>=dev-ruby/rspec-2.10.0
# 		>=dev-ruby/guard-rspec-1.1.0
# 	)"
