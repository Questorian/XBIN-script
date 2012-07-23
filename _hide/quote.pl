# use strict;
use Finance::YahooQuote;
use Time::Piece;

$Finance::YahooQuote::TIMEOUT = 20;

# sub lookup_and_display( $ $);

#stuff we are looking for
@held  = qw( GOOG  );
@buy   = qw( UBSN.VX NESN.VX  NOVN.VX ATLN.VX ROG.VX RIGN.VX SYNN.VX);
@watch = qw(  LLOY.L HP AAPL );
@fx =
  qw( DX-Y.NYB EURUSD=X USDJPY=X  USDCHF=X EURCHF=X CADCHF=X GBPCHF=X GBPUSD=X AUDUSD=X USDCAD=X GBPEUR=X GBPEUR=X CHFLKR=X);

@metals     = qw( XAUUSD=X );
@goldstocks = qw( AUY RGLD EGO AEM G.TO AEM.TO ALS.TO );
@gold2 = qw( FCX );    # lower grade gold bets - BEWARE!

@bonds    = qw( ^FVX ^TNX ^TYX );
@markets  = qw( ^SPC  ^DJI ^DJT ^IXIC ^HSI ^n225 ^GDAXI ^SSMI ^FTSE ^FCHI );
@indicies = qw( ^HUI  ^VIX ^OSX);

my $t = localtime;
print "BalaFund Daily Financial Traders Barometer Report: ", $t->ymd;

#lets get some quotes...
lookup_and_display( \@metals,     "Gold" );
lookup_and_display( \@fx,         "Forex" );
lookup_and_display( \@bonds,      "Bonds" );
lookup_and_display( \@markets,    "Markets" );
lookup_and_display( \@indicies,   "Indicies" );
lookup_and_display( \@goldstocks, "Gold Stocks" );
lookup_and_display( \@held,       "Portfolio" );
lookup_and_display( \@buy,        "Trading Radar" );
lookup_and_display( \@watch,      "Watchlist" );

sub lookup_and_display() {
    my ( $ref, $title ) = @_;
    my ( @quote, $count );
    $count = 0;

    draw_bar($title);
    foreach $symbol (@$ref) {
        @quote = getonequote $symbol;    # Get a quote for a single symbol

        # reduce the noise - blank-out 0 or 'N/A' symbols ...
        if ( ( $quote[7] eq '0' ) || ( $quote[7] eq 'N/A' ) ) {
            $quote[7] = '-';
        }
        printf "\n%4s. %-10s %15.40s %15s", ++$count, $quote[0],
          commify( $quote[2] ), commify( $quote[7] );
    }
}

sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

sub draw_bar {
    my $title = shift;

    my $length = 50;

    my $num_dashes = ( $length - length($title) ) / 2;

    print "\n", '-' x $num_dashes, ' ', $title, ' ', '-' x $num_dashes;

}
