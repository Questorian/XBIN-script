use warnings;
use strict;

my $price = shift;
my $count = shift || 1000;

if ( !defined($price) ) {   # we need at least the share price
    print
        "usage: $0 price [number_of_shares] - will default to 1,000 shares if not specified.\n";
    exit 1;
}

my @percentages = qw( 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0);

sub calculate_percentage {
    my ( $price, $count, $pc ) = @_;

    my $target = ( $price / 100 ) * ( 100 + $pc );

    my $profit = ( $target - $price ) * $count;

    #print "$pc %: $target - proift: $profit\n";
    printf( "%5.2f %%: %6.2f - profit: %6d (%6.2f)",
        $pc, $target, $profit, $count * $target );

    if ( $pc == 0 ) {
        print " <== Starting price. No Change (0%).";
    }

    print "\n";

}

my $pc;

# gains - positive percentages
foreach $pc ( reverse @percentages ) {

    calculate_percentage( $price, $count, $pc )

}

# opening price - no percentage change
calculate_percentage( $price, $count, 0 );

# losses - negative perecentages
foreach $pc (@percentages) {

    calculate_percentage( $price, $count, $pc * -1 )

}

__END__

=pod

A script to calculate the price of a stock at various percentages.

=cut
