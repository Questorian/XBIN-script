#-------------------------------------------------------------------------
#
# fx.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# fx.pl: convert a given value in one currency to another with current FX rate
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-11-23T15:24:46
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

use Locale::Currency;
use File::Basename;

# use Cache::FileCache;
# use Finance::YahooQuote;
use Finance::Quote;

#use Readonly
#use DateTime;
#use Getopt::Long;
#use Config::Std;
#use Config::Tiny;

# call the main function
fx(@ARGV);

### Main Function ###
# Usage     : fx()
# Purpose   : fx -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub fx {
    my ( $amount, $currency_source, $currency_target ) = @_;

    # check args
    die "usage: $0 amount currency_source currency_target\n"
      unless @_ == 3;

    # upper case the ISO 4217 currency codes
    $currency_source = uc($currency_source);
    $currency_target = uc($currency_target);

    # check these are valid codes
    for my $code ( $currency_source, $currency_target ) {
        die "sorry, currency $code not in ISO 4217\n"
          unless defined code2currency($code);

        # do a bit of caching here - speed things up
        my ($filename) = fileparse( $0, '.pl' );

        #        # my $cache = Cache::FileCache->new(
        #        {
        #            cache_root         => "$ENV{TEMP}/.$filename",
        #            default_expires_in => '1 day',
        #        } );

    }

    # lets get the quote
    my $quote = Finance::Quote->new();

    # check the cache first
    # my $ratio = $cache->get("$currency_source:$currency_target");
    my $ratio;

    $ratio = $quote->currency( $currency_source, $currency_target )
      unless defined $ratio;

    die "sorry, cannot convert source $currency_source to $currency_target\n"
      unless defined $ratio;

    # update the cache
    # $cache->set( "$currency_source:$currency_target", $ratio );

    print "$amount $currency_source = ", $amount * $ratio,
      " $currency_target\n";

    return;
}
