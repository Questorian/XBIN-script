#!/usr/sepp/bin/perl
#
# Sets the drive letters of the CD-ROM/CD-RW drives to R:,S:,...
#
# name : cdromtor.pl
# vers : 1.1
# maint: et
# path : http://isg.ee.ethz.ch/tools/realmen/down/cdromtor.pl
#
# date        ver   cksum     who  description
# ----------  ----  --------  ---  -------------------------------------------
# 2000/09/07  1.0   efed99de  et   first functioning version
# 2001/07/31  1.1   6ac2766c  et   modified to handle multiple drives

# to calculate cksum, use:
# cat cdromtor.pl | grep -v '^#' | cksum | gawk '{printf "%08x\n", $1}'

#
# remember:
#   key names ends with delimiter (/)
#   value names starts with delimiter (/)
#

use strict;

use Win32::TieRegistry ( Delimiter=>"/", ArrayValues=>1 ); 
use Win32API::File qw ( :ALL);

my $mdevkeyname = "HKEY_LOCAL_MACHINE/SYSTEM/MountedDevices/";
my $lettervalue ="/\\DosDevices\\";
my $cdromt='Z';

my $mdevkey = $Registry->{$mdevkeyname};
die "key for $mdevkeyname not found" unless defined $mdevkey;

my $m;
my @cdromletters;
for $m ($mdevkey->MemberNames) {
	if($m =~ m|^/\\DosDevices\\([A-Z]):|) {
		my $dletter = $1;
		die "drive letter R already in use\n" unless $dletter ne "R";
		if (GetDriveType("$dletter:") == DRIVE_CDROM()) {
			print "CDROM found with drive letter $dletter:\n";
			push @cdromletters,$dletter;
		}
	}
}

my $cd;
for $cd (@cdromletters) {
	print "$cd: -> $cdromt:\n";
	# change registry entry
	$mdevkey->{$lettervalue . $cdromt. ':'} =
	   $mdevkey->{$lettervalue . $cd . ':'};
	delete $mdevkey->{$lettervalue . $cd . ':'};
	$cdromt = chr(ord($cdromt)+1);
}

=head1 NAME

cdromtor.pl - Set Drive Letters of CD-ROM/CD-RW Drives to R:,S:,...

=head1 SYNOPSIS

perl cdromtor.pl

cdromtor changes the registry value of the CD-ROM/CD-RW drive letters.
("HKEY_LOCAL_MACHINE/SYSTEM/MountedDevices/DosDevices...")

Reboot after running cdromtor.pl.

=head1 AUTHOR

Edwin Thaler <thaler@ee.ethz.ch>
