#-------------------------------------------------------------------------
#
# qsbkup.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# qsbkup.pl: whatever
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2011-04-01T12:30:16
# History:
#		v0.2 -
#		v0.1 - 2011-04-01 - initial version created
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2011, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;

use DateTime;
use File::Copy;
use File::Basename;

#use Config::Tiny;
#use Readonly
#use Getopt::Long;
#use Config::Std;

use Questor::QSCDE;

my $basedir = "C:\\temp\\_bkup";

# initialise
my $dt      = DateTime->now();
my $isodate = $dt->ymd;
$basedir .= '\\' . $isodate;
mkdir($basedir);

if ( -d $basedir ) {
    print
      "$isodate - backup valuable QUESTOR data from QSCDE environment ...\n";
    print "backing up to target: $basedir\n";

}
else {
    die
      "unable to create target backup directory: $basedir - please investigate";
}

# get a new Questor QSCDE object
my $qs = Questor::QSCDE->new();

# start backing-up
foreach my $e ( $qs->enum_EO() ) {
    printf( "%-12s - %s\n", $e->name, $e->path_twiki );

    # backup the Tiddly Wiki
    bkupfile( $e->path_twiki, $basedir . '\\wikis' );

    # backup PST files including previous years
    bkupfile($e->path_pst, $basedir . '\\pst');


    # backup journals
    bkupfile( $e->path_journal,     $basedir . '\\journals' );
    bkupfile( $e->path_journal(-1), $basedir . '\\journals' );
    bkupfile( $e->path_journal(-2), $basedir . '\\journals' );
    bkupfile( $e->path_journal(-3), $basedir . '\\journals' );
    bkupfile( $e->path_journal(-4), $basedir . '\\journals' );
    bkupfile( $e->path_journal(-5), $basedir . '\\journals' );

}

# now we backup IMPORTANT files from the file list

my @files = qw /

  V:\\_data\\PWSafe\\PWSData.psafe3
  \\\\nqsaaa01\\Qweb\\wol\\WoL.php
  \\\\nqsaaa01\\SHRDATA\\PROD\\PROJECTS\\PACK\\PACK-ConfigMgr07\\doc\\wikis\\ConfigMgr07.html                           
  \\\\nqsaaa01\\SHRDATA\\PROD\\PROJECTS\\PACK\\PACK-ConfigMgr12\\doc\\wikis\\ConfigMgr12.html                           

  /;

push (@files,   "D:\\QS\\EO\\BALAFUND\\Admin\\General Reports\\BalaFund - Monthly Financial Report.xls");

foreach my $file (@files) {
    bkupfile( $file, $basedir . '\\misc' );
}

sub bkupfile {
    my $file = shift;
    my $dir  = shift;

    # check target directory exists
    mkdir($dir);

    my ( $fileBaseName, $dirName, $fileExtension ) =

      # fileparse( $file,  ('\.html') );
      fileparse($file);

    $dir .= '\\' . $fileBaseName . $fileExtension;

    if ( -f $file ) {
        print " bkup: $file -> $dir\n";
        copy( $file, $dir );

    }
    else {
        print " WARNING: $file does not exist!\n";
    }

}
