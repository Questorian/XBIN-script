#-------------------------------------------------------------------------
#
# renamer-GCRU.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# renamer-GCRU.pl: rename the GCRU files after they are downloaded
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-11-23T20:00:28
# History:
#		v0.2 -
#		v0.1 - 2008-11-23 - initial version created
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

#use Readonly
#use DateTime;
#use Getopt::Long;
#use Config::Std;
#use Config::Tiny;

# call the main function
renamer_GCRU(@ARGV);

### Main Function ###
# Usage     : renamer-GCRU()
# Purpose   : renamer-GCRU -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub renamer_GCRU {
    my ($v) = @_;

    my @flist = glob("GCRU*.*");
    foreach (@flist) {
        if (/GCRU(\d\d).(\d\d).(\d\d).*/) {
            my $new_name = "GCRU-20" . $3 . "-" . $1 . "-" . $2 . ".pdf";
            print "ren  $_  $new_name\n";
        }
    }

    return;
}
