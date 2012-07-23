use strict;
use warnings;

sub usage() {

    print "$0 <price> <high> <low>\n";
    print "purchases - low numbers are good (<30%)\n";
    print "sales     - high numbers are good (>70%)\n";
    print "The value represents how optimal the transaction price was\n";
    print "given the days trading range. You need to work on improving\n";
    print "this figure - and yes granted, it is not easy but it will\n";
    print "signigicantly improve the profitability of your trading greatly.\n";
    exit 0;

}

if (@ARGV != 3) {
  usage();
	}



my $price = shift;
my $high  = shift;
my $low   = shift;


# sanity check on the arguments
# @ARGV != 3
if ( ($low > $high) || ($price < $low) || ($price > $high) ) { usage(); }

printf( "Trade grade: %2.1f %%",

  ( $price - $low ) / ( $high - $low ) * 100);

