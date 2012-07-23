#-------------------------------------------------------------------------
#
# tbd2.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# tbd2.pl: whatever
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2011-03-21T12:19:16
# History:
#		v0.2 -
#		v0.1 - 2011-03-21 - initial version created
#
#-------------------------------------------------------------------------
my ($svn_rev, $svn_id, $svn_LastChangedDate );
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

my $tag = 'task';

# valid tags - lower case only
my @valid_tags =
  qw /task ipanema @work @home urgent project call email errand waiting-for joana wellness goal someday-maybe trip /;

while (<>) {

    chomp();

    if (/^([-@\w]*):$/) {
        $tag = validate_tag($1);
    }

    else {
        if ( !/^\s*$/ ) {
            print "$_ [$tag]\n";
        }

    }
}

sub validate_tag {
    my ($newtag) = lc(shift);

    # print "new tag[$newtag]\n";

    my $return_tag = "_invalid-tag";

    # check the new tag is in the list
    if ( grep { $_ eq $newtag } @valid_tags ) {
        $return_tag = $newtag;

    }

    # force tag to lowercase
    lc($return_tag);

}

__END__

=pod

=head1 TBD

=Head1 TBD for TBD

What we need to do next

=item * pritnt the empty tbd list template from the array we have here 

=item * use the '-s' option to get arguments

=item * dump batch helper and use single script (along with -s option)


=cut