#-------------------------------------------------------------------------
#
# recurs.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# recurs.pl: whatever
#
# Project:	
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2009-06-07T00:14:39
# History:
#		v0.2 - 
#		v0.1 - 2009-06-07 - initial version created
#            
#-------------------------------------------------------------------------
$svn_rev='$Rev: 110 $';
$svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';
#-------------------------------------------------------------------------
# (c)1997 - 2009, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

#!/usr/local/bin/perl 
#
# recurs.pl
#
# This script executes recursively on subdirs the command you supply as a parameter
#
# Run "program -h" to see the run options
#
# Last modified:  	Apr 10 1997
# Author: Bekman Stas   <c0409532@techst02.technion.ac.il>
#                       <sbekman@iil.intel.com>

$|=1;


# Set here the pattern extensions of your image files

# Usage

(@ARGV == 1 ) || die ("Usage: recurs.pl [-h]  \n\t-h this help\n\n");

$command=$ARGV[0];
#$command=~s/(.*)/'$1'/;

&recursive(); 


# Subroutine "recursive" goes recursively down at the dir tree and 
# and runs the $ARGV[0] for you. After comming to the end it's coming back up
# at the tree.


sub recursive {
    system($command);
#print "$command\n";
#die;
    foreach $dir (<*>) {
	if (-d $dir) {
#	print "$dir\n";
	    chdir $dir;
	    &recursive(); 
	    chdir ".."; 
	}
    }
}


