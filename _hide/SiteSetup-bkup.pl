#
#-----------------------------------------------------------------
# Alcatel - Alcatel-Lucent(Schweiz)AG, Friesenberg Strasse 75
#-----------------------------------------------------------------
#
# GenDomainAccounts.pl: Generate the accounts for a new internet domain
#
# Project:
# Author:	Farley Balasuriya,  (fbalasur@AD5.AD.ALCATEL.COM)
# Created:	Fri Jun  1 19:20:23 2007
# History:
#		v0.2 -
#		v0.1 - 01/06/07 - initial version created
#
#-----------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-----------------------------------------------------------------
#-----------------------------------------------------------------
use strict;
use warnings;
use Getopt::Long;
use Time::Piece;

# parameters
# ----------

# maximum number of databases for your account
my $max_DBs = 10;

my $id     = $ARGV[0];
my $domain = $ARGV[1];
my @psafe;

# check that we have the correct command line arguments
if ( $id eq "" || $domain eq "" ) {
    print "usage: web_id  domain.name\n";
    exit(1);
}

print "Domain: $domain, Userid: $id\n";

#generate the password safe date string
my $t        = localtime;
my $time_str = $t->ymd("/") . " " . $t->hms;

my $display_name = "PlanetBala";
$display_name = $display_name . "." . $display_name;

# the main website access account - note site cannot accept passwords longer than 12 characters!
my $pass = GetPassword(12);

# generate PasswordSafe import file
push @psafe,
"_Import.$display_name - Admin,$id,$pass,http://mail.$domain,,$time_str,,,,,\"WebAdmin account: $id\",\n";

# now POP3-mailbox accounts accounts
# one for the site, and then one per person
for ( my $i = 1 ; $i < 10 ; $i++ ) {
    $pass = GetPassword(12);
    my $pop3 = $id . "p" . $i;
    push @psafe,
"_Import.$display_name - POP3,$pop3,$pass,http://mail.$domain,,$time_str,,,,,\"POP3 - $pop3\",\n";
}

# MySQL databases
my @db_comments = qw/ DBA Reference app1 app2 DevSandbox/;
for ( my $i = 1 ; $i <= $max_DBs ; $i++ ) {
    my $db   = "usr_" . $id . "_" . $i;
    my $pass = GetPassword(12);

    #
    push @psafe,
"_Import.$display_name - MySQL DB - $db_comments[$i - 1],$db,$pass,http://mail.$domain,,$time_str,,,,,\"MySQL DB - $db\",\n";
}

# print out the Password safe import file
print ":: - Password safe import file\n";
print @psafe;
print "\n\n\n";

sub GetPassword() {
    my ($v) = @_;

    my @chars = ( "A" .. "Z", "a" .. "z", 0 .. 9, qw(! @ $ ^ - + _ [ ] ) );

    my $password = join( "", @chars[ map { rand @chars } ( 1 .. $v ) ] );

}
