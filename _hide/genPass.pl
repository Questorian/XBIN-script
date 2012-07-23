##############################################################
# purpose: Generate Windows user accounts from a file and assign a password
# created: 2006-09-26 18:49
#
# Farley Balasuriya  - farley@questor.ch
#
# usage: perl -n script usernames.txt
#
##############################################################

use strict;
use warnings;

my $length  = shift || 16;
my @chars = ( "A" .. "Z", "a" .. "z", 0 .. 9, qw(! @ $ ^ - + _ [ ] ) );
# my @chars = ( "A" .. "Z", "a" .. "z", 0 .. 9,  );


my $password = join("", @chars[ map { rand @chars } ( 1 .. $length ) ]);


print "$password\n";