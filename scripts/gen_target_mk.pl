#!/usr/bin/perl
# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

use strict;

my @target;
my $target;
my $profile;

while (<>) {
	chomp;
	/^Target:\s*((.+)-(\d+\.\d+))\s*$/ and do {
		$target = {
			id => $1,
			board => $2,
			kernel => $3,
			profiles => []
		};
		push @target, $target;
	};
	/^Target-Name:\s*(.+)\s*$/ and $target->{name} = $1;
	/^Target-Path:\s*(.+)\s*$/ and $target->{path} = $1;
	/^Target-Arch:\s*(.+)\s*$/ and $target->{arch} = $1;
	/^Target-Features:\s*(.+)\s*$/ and $target->{features} = [ split(/\s+/, $1) ];
	/^Target-Description:/ and do {
		my $desc;
		while (<>) {
			last if /^@@/;
			$desc .= $_;
		}
		$target->{desc} = $desc;
	};
	/^Linux-Version:\s*(.+)\s*$/ and $target->{version} = $1;
	/^Linux-Release:\s*(.+)\s*$/ and $target->{release} = $1;
	/^Linux-Kernel-Arch:\s*(.+)\s*$/ and $target->{karch} = $1;
	/^Default-Packages:\s*(.+)\s*$/ and $target->{packages} = [ split(/\s+/, $1) ];
	/^Target-Profile:\s*(.+)\s*$/ and do {
		$profile = {
			id => $1,
			name => $1,
			packages => []
		};
		push @{$target->{profiles}}, $profile;
	};
	/^Target-Profile-Name:\s*(.+)\s*$/ and $profile->{name} = $1;
	/^Target-Profile-Packages:\s*(.*)\s*$/ and $profile->{packages} = [ split(/\s+/, $1) ];
}

@target = sort {
	$a->{id} cmp $b->{id}
} @target;

foreach $target (@target) {
	my ($profiles_def, $profiles_eval);
	my $conf = uc $target->{kernel}.'_'.$target->{board};
	$conf =~ tr/\.-/__/;
	
	foreach my $profile (@{$target->{profiles}}) {
		$profiles_def .= "
  define Profile/$conf\_$profile->{id}
    ID:=$profile->{id}
    NAME:=$profile->{name}
    PACKAGES:=".join(" ", @{$profile->{packages}})."
  endef";
  $profiles_eval .= "
\$(eval \$(call Profile,$conf\_$profile->{id}))"
	}
	print <<EOF
ifeq (\$(CONFIG_LINUX_$conf),y)
  define Target
    KERNEL:=$target->{kernel}
    BOARD:=$target->{board}
    LINUX_VERSION:=$target->{version}
    LINUX_RELEASE:=$target->{release}
    LINUX_KARCH:=$target->{karch}
  endef$profiles_def
endif$profiles_eval

EOF
}
print "\$(eval \$(call Target))\n";
