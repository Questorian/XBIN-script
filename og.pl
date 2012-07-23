#-------------------------------------------------------------------------
#
# og.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# og.pl: n Objectives Guide (Daily, Weekly, Monthly, Quarterly, Half, Yearly)
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2009-06-02T07:09:18
# History:
#		v0.2 - 2009-06-10 - updated code for 'successes' file
#		v0.1 - 2009-06-02 - initial version created
#
# TBD:
#   * QSCDEE varaiables are need in INI file - e.g. %Q_EO% e.g. -> 'D:\QS'
#   * parameterise the year - 2009, etc
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2009, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;

use DateTime;
use Getopt::Long;
use Config::Tiny;
use File::Copy;

use Questor;

#use Config::Std;
#use Readonly

# script global variables
my $config_file = 'v:\\_data\\ini\\Questor.ini';

# command line arguments
my $next;
my $last;
my $success;
my $help;
my $goals;
my $cleanup;

my ( $year, $month, $day );    # used throughout the script
my $last_week_no;
my $this_week_no;
my $next_week_no;

# call the main function
og(@ARGV);

### Main Function ###
# Usage     : og()
# Purpose   : og -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub og {
    my ($v) = @_;

    # sort out the arguments
    my $result = GetOptions(

        next    => \$next,
        last    => \$last,
        success => \$success,
        help    => \$help,
        goals   => \$goals,
        success => \$success,
        cleanup=> \$cleanup,

    );

    # get parameters from the ini file
    my $config = Config::Tiny->new();
    $config = Config::Tiny->read($config_file);

    # get some basic information down
    $this_week_no = week_number();
    $last_week_no = $this_week_no - 1;
    $next_week_no = $this_week_no + 1;
    my $desired_week_no = $this_week_no;
    print "og: current Week no: $this_week_no\n";

    # ??? - tbd - get the correct CALCULATED year
    # Another dirty hack!
    $year = 2009;

    # process command line arguments

    if ($cleanup) {
        # user wants to see the goaols document
        print "opening cleanup document: $config->{og}->{doc_cleanup}\n";
        exec("\"$config->{og}->{doc_cleanup}\"");
        exit 0;
    }

    if ($success) {
        my $fname =
          $config->{og}->{output_directory} . "\\successes-$year.docx";
        print "opening current successes file: $fname\n";

        # note - we want exec() here, not system() - exec() will never return
        exec($fname);
        exit 0;
    }

    if ($help) {
      do_help();
    	}

    if ($goals) {

        # user wants to see the goaols document
        print "opening goals document: $config->{og}->{doc_goals}\n";
        exec("\"$config->{og}->{doc_goals}\"");
    }

    # adjust week no
    if ($next) {
        $desired_week_no++;
    }

    # adjust week no
    if ($last) {
        $desired_week_no--;
    }

    # get some extra data
    ( $year, $month, $day ) = split( /-/, date() );

    #if the file does not exist then make a new one
    my $fname = sprintf( "og-%s-w%0.2d.docx", $year, $desired_week_no );
    my $og_file = $config->{og}->{output_directory} . "\\$fname";

    #determine if the file is there or not and if not create it
    if ( -f $og_file ) {
        print "Opening existing: $og_file\n";
    }
    else {
        print "no existing file exist - creating: $og_file\n";
        copy( $config->{og}->{template}, $og_file );
    }

    # open the file
    exec($og_file );

}

sub do_help()
{
my ($v)=@_;

print <<"EOF_HELP";

og - Objectives Guide

Help with getting, setting, and checking your Objectives

Types of Objectives:
===================

  w -   wog - weekly 
  m -   mog - montly
  q -   qog - quarterly
  h -   hog - half-yearly
  y -   yog - yearly

arguments:
  -goals    goals - load and display your goals doucment
  -success  success file - load and dislpay your successes document

  -next     next (week/month/...)
  -last     last (week/month/...)

INI file:
most parameters are loaded from the INI file and can be changed there


EOF_HELP


exit(0);
}
