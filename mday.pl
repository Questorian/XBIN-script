#!/usr/bin/env perl -s
#-------------------------------------------------------------------------
#
# mday.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# mday.pl: whatever
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2012-02-21T15:41:13
# History:
#		v0.2 -
#		v0.1 - 2012-02-21 - created
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (C)1997 - 2012, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;

use DateTime;
use Data::Dumper;

my $tzone = 'Europe/Zurich';

my $mday = DateTime->new(
    year  => 2014,
    month => 10,
    day   => 1,
                );

my $today = DateTime->now(time_zone  => $tzone);

my ($year, $week) = DateTime->now(time_zone  => $tzone)->week();


my $duration = $mday->delta_days( $today);
# $duration->in_units('months');

print "M-Day (MIDAS Day): ", $mday->day_name, " ", $mday->month_name, " ", $mday->day, " ", $mday->year, "\n";

print "Today: ", $today->ymd;
printf (", (%d/%0.2d)", $year, $week);       
my $weeks = $duration->weeks;
print " - We have ", $weeks, " weeks left.\n";

# print rest as here doc
print <<"END_OF_STRING_MIDAS"

M-Day - MIDAS Day
=================

Venceremos!! We must work hard to achieve our lifes dreams!

M-Day signifies nothing less than the validation and badge of proof
that I am smart, resourceful, disciplined, a planner and hardworking.

A successful and proven M-Day is the badge of pride an hounour that I will
wear and others will see that will show to me and all around that I have 
always had, and always will have great potential.

It will also be delivery on all the talk, that I have given all the people all 
these years.

Midas day is not  the end, but the start of a real, new chapter in my life.

Successes so far
* TDP - The Daily Paycheck
* Rome Symposium 2011 - were the TDP was forumlated
* Midas Plan - OCt 1st 2014 Global Wealth Transfer Program
* BalaFund::Midas - Financial system

MIDAS: USE YOUR $weeks COMING WEEKS WISELY! BE PREPARED!!

END_OF_STRING_MIDAS

# print Dumper($duration);

__END__

=pod

=head1 NAME

mday - Time left to my D-Day October 1st 2015

=head1 SYNOPSIS

I need to be ready for the mass financial meltdown

=head1 SWITCHES & OPTIONS


=head1 REVISION HISTORY

v0.0.1 - 2012-02-21 - initial version created
    
=head1 AUTHOR

Farley Balasuriya    (developer@QuestorSystems.com)

=head1 LICENCE AND COPYRIGHT

Copyright (C) 1996-2012 Farley Balasuriya.  All rights reserved.  

=cut
