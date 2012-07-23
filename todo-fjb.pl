#-------------------------------------------------------------------------
#
# Todo.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# Todo.pl: Send todo jobs to my queue for later processing
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2009-06-07T11:31:31
# History:
#		v0.2 -
#		v0.1 - 2009-06-07 - initial version created
#
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

use Questor;

#use DateTime;
#use Config::Tiny;
#use Readonly
#use Getopt::Long;
#use Config::Std;

my $email_target = 'nbbalasufa@nestle.com';

# call the main function
Todo_init(@ARGV);

### Main Function ###
# Usage     : Todo()
# Purpose   : Todo -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub Todo_init {
    my (@args) = @_;

    if ( @args == 0 ) {
        die
"You need to specify the task on the commandline: current target is: $email_target";

    }

    dispatch_outlook(@args);

    return;
}

sub dispatch_outlook {
    my (@args) = @_;

    my $subject = "ToDo: @args";

    my $body = "sent: " . timestamp() . ' - ' . $ENV{'COMPUTERNAME'};

    print "dispatching: $subject\n$body";

    my $email = olmail(
        {
            to      => $email_target,
            subject => $subject,
            body    => $body,
            send    => 1,
        }
    );

}
