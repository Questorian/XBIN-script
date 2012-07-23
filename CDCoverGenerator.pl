#-------------------------------------------------------------------------
#
# CDCoverGenerator.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# CDCoverGenerator.pl: Generate a quick and dirty cover for a CD I might
#               com accross
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-12-06T14:23:55
# History:
#		v0.2 -
#		v0.1 - 2008-12-06 - initial version created
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2008, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;
use PostScript::CDCover;
use File::Basename;

#use Readonly
#use DateTime;
#use Getopt::Long;
#use Config::Std;
#use Config::Tiny;

# call the main function
CDCoverGenerator(@ARGV);

### Main Function ###
# Usage     : CDCoverGenerator()
# Purpose   : CDCoverGenerator -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub CDCoverGenerator {
    my ($filepath) = @_;

    my $cd = new PostScript::CDCover -root => 'root', -all => 1, -columns => 0, -minwidth => 50, -separator => 1, -title => 'Fred Wesley - Full Circle (From Be Bop To Hip Hop... )';


    my @found = glob( $filepath . "\\*.mp3");
    foreach my $file (@found) {
      my ($filename, $path, $ext) = fileparse($file, ".mp3");
      # print " -> basename: $filename\n";
      $cd->add_file($filename);
    	}

    # print the file to STDIO
    $cd->flush();

    return;
}

