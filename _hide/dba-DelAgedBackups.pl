#
#-----------------------------------------------------------------
# Alcatel - Alcatel-Lucent(Schweiz)AG, Friesenberg Strasse 75
#-----------------------------------------------------------------
#
# DBADelAgedBackups.pl: Clean the aged backup files for a SQL server depnding on
#   the values stored in the DBA database
#
# Project:
# Author:	Farley Balasuriya,  (fbalasur@AD5.AD.ALCATEL.COM)
# Created:	Thu Feb  8 11:08:55 2007
# History:
#		v0.2 -
#		v0.1 - 08/02/07 - initial version created
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
use File::Find ();
use DBI;
use Config::IniHash;
use Time::Piece;
use Carp;

my $delete = 0;

GetOptions( "delete" => \$delete );

#global vars here
my (
    $BKUPRetentionDays,   $Path_DefaultBKUPFolder,
    $Ext_SQLDataFileBKUP, $Ext_SQLLogFileBKUP
);
my @to_delete;

# ini file - we get the DBI connection parameters (connection string) out of this file
my $ini = "f:/shrdata/DBABin/DBA.ini";

#note - change this to the name of the section you want loaded in the ini file
my $ini_section = "DBADelAgedBackups";

my $query_1 =
'SELECT  BKUPRetentionDays, Path_DefaultBKUPFolder, Ext_SQLDataFileBKUP, Ext_SQLLogFileBKUP from DBServerConfig';

print_header();

#check the ini file exist - get the DB location information
if ( -f $ini ) {
    print "INI File is ok...";
}
else {

    croak "unable to find ini file: $ini\n";
}

# lets open up the ini file, and find
# which database we need to connect to
my %opts;
$opts{"case"} = "preserve";
my $obj = ReadINI( $ini, %opts );

#print out the data we want...
print "\nDumping out INI file parameters:\n";
print "persona: $obj->{$ini_section}->{persona}\n";
print "server : $obj->{$ini_section}->{server}\n";
print "database: $obj->{$ini_section}->{database}\n";
print "trusted connection: $obj->{$ini_section}->{trusted_connection}\n";

# DBI::ADO connectino string
my $ms_con_str =
"dbi:ADO:Driver={SQL Native Client};Server=$obj->{$ini_section}->{server};Database=$obj->{$ini_section}->{database};trusted_connection=$obj->{$ini_section}->{trusted_connection}";

print "connection string: [$ms_con_str]\n";

# database handel - connect to the database
my $dbh = DBI->connect( $ms_con_str,,, { TimeOut => 5 } )
  or die $DBI::errstr;

# statement handel - prepare the statement
my $sth = $dbh->prepare($query_1);

# execute the statement handel
$sth->execute();

# read just one row of the config data
(
    $BKUPRetentionDays,   $Path_DefaultBKUPFolder,
    $Ext_SQLDataFileBKUP, $Ext_SQLLogFileBKUP
) = $sth->fetchrow_array;

# dump paramers
print "we have following data:\nBKUPRetentionDays = $BKUPRetentionDays\n";
print
"Path_DefaultBKUPFolder = $Path_DefaultBKUPFolder\nExt_SQLDataFileBKUP = $Ext_SQLDataFileBKUP\n";
print "Ext_SQLLogFileBKUP = $Ext_SQLLogFileBKUP\n";

# close the statement handle
$sth->finish;

# disconnect and exit
$dbh->disconnect;

print "starting aged bkup scan on directory: $Path_DefaultBKUPFolder\n";
chdir($Path_DefaultBKUPFolder);

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name  = *File::Find::name;
*dir   = *File::Find::dir;
*prune = *File::Find::prune;

# Traverse desired filesystems
File::Find::find( { wanted => \&wanted }, '.' );

if (@to_delete) {
    my $num = @to_delete;
    print "$num file(s) found to delete on this run\n";
    foreach (@to_delete) {
        print "$_: ";
        if ($delete) {
            if   ( unlink $_ ) { print " deleted.\n"; }
            else               { print " delete failed!\n"; }
        }
        else {
            print " ready to delete.\n";
        }

    }
}

print "\nend of run...";

sub wanted {
    my ( $dev, $ino, $mode, $nlink, $uid, $gid );

         ( /^.*$Ext_SQLDataFileBKUP\z/s || /^.*$Ext_SQLLogFileBKUP\z/s )
      && ( ( $dev, $ino, $mode, $nlink, $uid, $gid ) = lstat($_) )
      && ( int( -C _ ) > $BKUPRetentionDays )
      &&

      # we take a copy so that we can process it
      push( @to_delete, $name );

}

sub print_header() {
    my $str = localtime;

    print "\n-***-\n$str: $0: start-up: ";

}
