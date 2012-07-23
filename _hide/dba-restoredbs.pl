#-------------------------------------------------------------------------
#
# dba-restoredbs.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# restore-dbs.pl: Restore databases that were dumped with dbo.DumpAll
#   this is a quick and dirty script and should be replaced with a TT
#   solution - and something much nicer than this crappy script
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2010-06-17T15:17:43
# History:
#		v0.2 -
#		v0.1 - 2010-06-17 - initial version created
#
# qstag: dba
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2010, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;

use Cwd;

#use DateTime;
#use Config::Tiny;
#use Readonly
#use Getopt::Long;
#use Config::Std;

my $target_dir =
'C:\\Program Files\\Microsoft SQL Server\\MSSQL10_50.MSSQLSERVER\\MSSQL\\DATA';
my $dir = getcwd();
$dir =~ s|/|\\|g;

my @ignored = qw/ master msdb model ReportServerTempDB/;

# call the main function
restore_dbs_init(@ARGV);

# sample restore DB statement:
# RESTORE DATABASE DBA FROM DISK = 'c:\temp\db\DBA_Adhoc_201006111341.db-bak'
# WITH
# MOVE 'DBA_D01' TO 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\DBA_D01.mdf',
# MOVE 'DBA_L01' TO 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\DBA_L01.ldf'

### Main Function ###
# Usage     : restore_dbs()
# Purpose   : restore_dbs -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub restore_dbs_init {
    my ($v) = @_;

    print "NOTE: the following databases will be ignored!!!: @ignored\n\n";

    foreach my $fname (<*.db-bak>) {

        #get the DB name from the backup filename
        $fname =~ m/(.*)_Adhoc/;

        next if ( is_ignored($1) );

        print "-- $1\nRESTORE DATABASE $1 FROM DISK = '", $dir, "\\$fname'\n";
        print "GO\n\n";

    }
    return;

}

sub is_ignored {
    my $fname = shift;

    my $match = 0;

    foreach my $ignore (@ignored) {
        if ( uc($fname) eq uc($ignore) ) {
            $match = 1;
        }
    }

    $match;

}

sub with_restore {
    my ($v) = @_;

    print " WITH \n ";
    print " MOVE '$1_D01' TO '$dir\\$1_D01.mdf', \n ";
    print " MOVE '$1_L01' TO '$dir\\$1_L01.ldf' \n \n \n ";

}
