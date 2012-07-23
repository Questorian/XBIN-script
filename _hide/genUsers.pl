#
#-----------------------------------------------------------------
# Alcatel - Alcatel-Lucent(Schweiz)AG, Friesenberg Strasse 75
#-----------------------------------------------------------------
#
# genUsers.pl: Generate a set of users account complete with password, and an
#   import file for PasswordSafe for a given list of users accounts (passed in
#   a text file)
#
# Project:
# Author:	Farley Balasuriya,  (fbalasur@AD5.AD.ALCATEL.COM)
# Created:	Sat Feb 10 04:10:25 2007
# History:
#		v0.2 -
#		v0.1 - 10/02/07 - initial version created
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

my (@batch, @psafe, @csv, $t, $str);

#default SA (Service Account) extension
# my $user_account_prefix = "QSSA_";
# my $user_account_prefix = "SA_";
my $user_account_prefix = "";

#generate the password safe date string 
$t = localtime;
$str = $t->ymd("/") . " " . $t->hms;


while (<>) {

    chomp();

    my $account = $user_account_prefix . $_;

    my @chars = ( "A" .. "Z", "a" .. "z", 0 .. 9, qw(! @ $ ^ - + _ [ ] ) );
    my $password = join( "", @chars[ map { rand @chars } ( 1 .. 10 ) ] );

    #generate accounts for batch file
    push @batch, "net user $user_account_prefix$_ $password /Add \n";

    # generate PasswordSafe import file for documentation
    push @psafe, "_Import.$account,$account,$password,,,$str,,,,,,\n";

    # csv file
    push @csv, "$account;$password\n";

}

# print out the  batch
print "\@echo off\n:: Create user accounts\n";
print @batch;
print "goto END\n";
print "\n\n\n";

# print out the Password safe import file
print ":: - Password safe import file\n";
print @psafe;
print "\n\n\n";


# print out a CSV format to hand out to people
print ":: - CSV format if you want it...\n";
print @csv;
print "\n\n\n:END\n";
