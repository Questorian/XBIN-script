#
#------------------------------------------------------------------------------
# QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
#------------------------------------------------------------------------------
#
# _test_qscde.pl: Test program to test the qscde.pm modules.  This should be run and updated whenever there are any changes made to the qscde.pm module
#
# Project:	
# Author:	Farley Balasuriya,  (qs10001@QUESTOR.INTRA)
# Created:	Wed May 18 22:12:00 2005
# History:
#		v0.2 - 
#		v0.1 - 18/05/05 - initial version created
#            
#------------------------------------------------------------------------------
$svn_rev='$Rev: 110 $';
$svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';
#------------------------------------------------------------------------------
# Copyright (C) 1998-2005 Farley Balasuriya, Questor Sytems GmbH, Switzerland
# All rights reserved.
#------------------------------------------------------------------------------
use strict;
use qscde;

my (%qscde, $key, $val);

# test code here
print "This is the start\n";


#initialise the qscde environment, and receive a hash of all our constants
%qscde = qscde_init();
print "-------- qscde constants -----------\n";
foreach $key (sort keys (%qscde)) {
    print "$key -> $qscde{$key}\n";
	}
print "-------- qscde constants -----------\n";


# test the getProperty() function
print "Now we will getProperty() on some usefule keys...\n";
my @plist = qw( QS_Debug QS_Editor QS_PRN1 PROMPT PERL5OPT PAGER QS_Persona_Long );
foreach  (@plist) {
  print "key: $_ -> ", getProperty($_), "\n";
	}

# test the setProperty function
print "Now we will setProperty() on some usefule keys...\n";
my @plist = qw( SpongeCake QS_Debug QS_PRN1 PROMPT PAGER QS_Persona_Long NOGGBERT DiggleBottom);
foreach  (@plist) {
  setProperty($_, "New value we have just set ...");
	}

#generate a batch ...
genCMDFile("c:\\temp\\qscde_sets.cmd");


log_write("record something important in the log");
log_write("another important process is starting");
log_write("and we do not need to remember to close the log any more, the END{} function will do that for us.");
# log_close();
print "This is the end of the program\n";


#------------------------------------------------------------------------------
# Copyright (C) 1998-2005 Farley Balasuriya, Questor Sytems GmbH, Switzerland
# All rights reserved.
#------------------------------------------------------------------------------