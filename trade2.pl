use strict;
use warnings;
use Finance::YahooQuote;
use Time::Piece;

$Finance::YahooQuote::TIMEOUT = 20;

use feature qw/switch/;

my $equity        = 50_000;
my $minimum_trade = 4_000
  ; # above this value all Swissquotes fees for all markets and currencies are the same
my $pc_max_trade_loss = 2;       # maximum allowable percentage loss per trade
my $fx_base           = 'CHF';
my $max_single_loss = ( $equity / 100 ) * $pc_max_trade_loss;
my $iban            = 'CH8408781000030693400';

# test with AAPL, GOOG, AMZN

#get command line parameters
my $stock  = uc(shift);
my $pieces = shift;

print "Trading Account: $iban\n";
print "BalaFund Trading equity: $equity $fx_base\n";
print
"Maximum allowable loss per trade: $max_single_loss (=> $pc_max_trade_loss % of trading equity)\n";
print "note that losses INCLUDE trading fees & shrinkage!\n";

my $transaction = 9_000;
print "charges for transactoin of $transaction is ",
  get_transaction_fee($transaction) * 2, " (2 x ",
  get_transaction_fee($transaction), ")\n";

print "\n";
print "----*** QUOTE: $stock ***----\n";
print "Current Price: ";
my @quote = getonequote($stock);
my $price = $quote[2];
print "$price\n";
print "price version 2: ", get_quote($stock), "\n";
print "Nummber of Stock: $pieces\n";
my $stock_cost = $pieces * $price;
print "Stock Cost: ", $stock_cost, "\n";
print "Stock cost #2: ", get_stock_cost($stock, $pieces), "\n";
# we double up transasction charges so that buy & sell are included
my $charge = get_transaction_fee($stock_cost) * 2 ;
print "Transaction charges: $charge (", (($charge / $stock_cost) * 100) * 1.00, " %)\n";
my $total_cost = $stock_cost + $charge;
print "Total Transaciton cost: $total_cost";

my $pc_equity = $total_cost / $equity * 100 ;
printf(" (%1.2f%% of total equity)\n", $pc_equity);

my $max_loss = get_max_loss($total_cost);
print "maximum permissable loss on this trade: $max_loss\n";


print "----*** QUOTE: $stock ***----\n";

# return the stoploss price to ensure that stock
# gets sold and honours the $pc_max_trade_loss limit
sub get_stoploss();
{
my $unit_price = shift;
my $pieces = shift;


}

# cost of n shares of symbol
sub get_stock_cost
{
my $symbol = shift;
my $pieces = shift;

    get_quote($symbol) * $pieces ;



}

sub get_max_loss
{
my $value = shift;

    ($value / 100) * $pc_max_trade_loss;


}


# get current price of stock symbol - yahoo stock symbol
sub get_quote
{
my $symbol = uc(shift);

    my @quote = getonequote($symbol);

    # return the current price part of the array
    $quote[2];


}


# as long as your trades are more than 2k in currency
# the charges are the same - so we will trade above
# that and keep the system simple!
sub get_transaction_fee {
    my $value = shift;

    my $transaction_fee = 0;

    # 2k is lower limit - fees vary below this amount
    if ( $value < $minimum_trade ) {
        die("error: transaction value $value is too low - must be greater that $minimum_trade\n");
    }

    given ($value) {
        # calculate the Swissquote transaction fee for the 
        # transaction from it's total value
        when ( $value < 10_000 )  { $transaction_fee = 35; }
        when ( $value < 15_000 )  { $transaction_fee = 50; }
        when ( $value < 25_000 )  { $transaction_fee = 75; }
        when ( $value < 50_000 )  { $transaction_fee = 125; }
        when ( $value < 75_000 )  { $transaction_fee = 175; }
        when ( $value < 125_000 ) { $transaction_fee = 220; }
        when ( $value < 125_001 ) { $transaction_fee = 250; }
    }

    $transaction_fee;

}
