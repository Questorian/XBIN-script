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

my $user_account_prefix = "SA_";



chomp ();

my $account = $user_account_prefix . $_ ;

my @chars = ( "A" .. "Z", "a" .. "z", 0 .. 9, qw(! @ $ ^ - + _ # [ ]) );
my $password = join("", @chars[ map { rand @chars } ( 1 .. 10 ) ]);

#generate accounts for batch file

# print "net user $user_account_prefix$_ $password /Add \n";

# PasswordSafe
print "_Import.$account,$account,$password,,,,,,,,,\n";