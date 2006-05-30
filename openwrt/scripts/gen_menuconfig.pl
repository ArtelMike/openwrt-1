#!/usr/bin/perl
use strict;

my $src;
my $makefile;
my $pkg;
my %category;

sub print_category($) {
	my $cat = shift;
	
	return unless $category{$cat};
	
	print "menu \"$cat\"\n\n";
	my %spkg = %{$category{$cat}};
	foreach my $spkg (sort {uc($a) cmp uc($b)} keys %spkg) {
		foreach my $pkg (@{$spkg{$spkg}}) {
			my $title = $pkg->{name};
			my $c = (72 - length($pkg->{name}) - length($pkg->{title}));
			if ($c > 0) {
				$title .= ("." x $c). " ". $pkg->{title};
			}
			print "\t";
			$pkg->{menu} and print "menu";
			print "config PACKAGE_".$pkg->{name}."\n";
			print "\t\ttristate \"$title\"\n";
			print "\t\tdefault ".$pkg->{default}."\n";
			foreach my $depend (@{$pkg->{depends}}) {
				print "\t\tdepends PACKAGE_$depend\n";
			}
			print "\t\thelp\n";
			print $pkg->{description};
			print "\n";

			$pkg->{config} and print $pkg->{config}."\n";
		}
	}
	print "endmenu\n\n";
	
	undef $category{$cat};
}

my $line;
while ($line = <>) {
	chomp $line;
	$line =~ /^Source-Makefile: \s*(.+\/([^\/]+)\/Makefile)\s*$/ and do {
		$makefile = $1;
		$src = $2;
		undef $pkg;
	};
	$line =~ /^Package: \s*(.+)\s*$/ and do {
		$pkg = {};
		$pkg->{src} = $src;
		$pkg->{makefile} = $makefile;
		$pkg->{name} = $1;
		$pkg->{default} = "m if ALL";
	};
	$line =~ /^Version: \s*(.+)\s*$/ and $pkg->{version} = $1;
	$line =~ /^Title: \s*(.+)\s*$/ and $pkg->{title} = $1;
	$line =~ /^Menu: \s*(.+)\s*$/ and $pkg->{menu} = $1;
	$line =~ /^Default: \s*(.+)\s*$/ and $pkg->{default} = $1;
	$line =~ /^Depends: \s*(.+)\s*$/ and do {
		my @dep = split /,\s*/, $1;
		$pkg->{depends} = \@dep;
	};
	$line =~ /^Category: \s*(.+)\s*$/ and do {
		$pkg->{category} = $1;
		defined $category{$1} or $category{$1} = {};
		defined $category{$1}->{$src} or $category{$1}->{$src} = [];
		push @{$category{$1}->{$src}}, $pkg;
	};
	$line =~ /^Description: \s*(.*)\s*$/ and do {
		my $desc = "\t\t$1\n\n";
		my $line;
		while ($line = <>) {
			last if $line =~ /^@@/;
			$desc .= "\t\t$line";
		}
		$pkg->{description} = $desc;
	};
	$line =~ /^Config: \s*(.*)\s*$/ and do {
		my $conf = "$1\n";
		my $line;
		while ($line = <>) {
			last if $line =~ /^@@/;
			$conf .= "$line";
		}
		$pkg->{config} = $conf;
	}
}

print_category 'Base system';
foreach my $cat (keys %category) {
	print_category $cat;
}
