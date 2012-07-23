#!/usr/bin/env perl -s

use strict;
use warnings;
use Finance::YahooQuote;
use Time::Piece;

$Finance::YahooQuote::TIMEOUT = 20;

use feature qw/switch/;

our ($package);

# my $equity        = 50_000;
my $equity        = 41_000;
my $minimum_trade = 4_000
  ; # above this value all Swissquotes fees for all markets and currencies are the same
my $pc_max_trade_loss = 1.00;       # maximum allowable percentage loss per trade
my $fx_base           = 'CHF';
my $max_single_loss = ( $equity / 100 ) * $pc_max_trade_loss;
my $iban            = 'CH8408781000030693400';
my $extra_costs     = 25;

#get command line parameters
my $stock = uc(shift);
my $price = shift;
my $units = shift;

sub calc_percentage {
    my $number     = shift;
    my $percentile = shift;

    # return a number to 2 decimal places
    $number + ( ( $number / 100 ) * $percentile );

}

sub calc_stop_loss_limit($$$) {
    my $price      = shift;
    my $units      = shift;
    my $commission = shift;

    # claclate what is the lowest prices to protect our equity
    # using the MM (Money Management) rules - e.g. 2% rule

    # first check that this trade is not too expensive
    if ( $max_single_loss < ( $commission * 2 ) ) {
        print
"WARNING: The charges on this trasaction ($commission) are higher than your loss limit!!!\n";
        print "This trade cannot possibly work!!!\n";
    }

# now calculate min. price before we are loosing more than our max allowable loss per trade

    (($price * $units) - $max_single_loss) / $units;

}

sub calc_stop_loss_limit2() {
    my $price      = shift;
    my $units      = shift;
    my $commission = shift;

    # claclate what is the lowest prices to protect our equity
    # using the MM (Money Management) rules - e.g. 2% rule

    # first check that this trade is not too expensive
    if ( $max_single_loss < ( $commission * 2 ) ) {
        print
"WARNING: The charges on this trasaction ($commission) are higher than your loss limit!!!\n";
        print "This trade cannot possibly work!!!\n";
    }

# now calculate min. price before we are loosing more than our max allowable loss per trade
    my $loss = $max_single_loss;

    $loss -= ( $commission * 2 );    # remove the cost of the trade

    $price - ( $loss / $units );     # return the minimum price

}



sub calc_stop_break_even($$$) {
    my $price      = shift;
    my $units      = shift;
    my $commission = shift;

    # return the minimum price we need to achieve to break even
    # on a trade including all commission
    # assume double the charges - ie you will be charged on the sale too

    ( ( $price * $units ) + $commission  ) / $units;

}

# return the stoploss price to ensure that stock
# gets sold and honours the $pc_max_trade_loss limit
sub get_stoploss();
{
    my $unit_price = shift;
    my $pieces     = shift;

}

# cost of n shares of symbol
sub get_stock_cost {
    my $symbol = shift;
    my $pieces = shift;

    get_quote($symbol) * $pieces;

}

sub get_max_loss {
    my $value = shift;

    ( $value / 100 ) * $pc_max_trade_loss;

}

# get current price of stock symbol - yahoo stock symbol
sub get_quote {
    my $symbol = uc(shift);

    my @quote = getonequote($symbol);

    # return the current price part of the array
    $quote[2];

}

sub get_exchange_fee {
    my $value = shift;

    # hard code for now - fix at 3.00 CHF
    # which is maximum seen fo far for this bizare expense

    3.00;

}

# stampd duty in Switzerland on the SQB is 0.075%
# of total transaction cost
sub get_stamp_duty {
    my $value = shift;


    # ( $value / 100 ) * 0.075; # - Swiss stocks
    ( $value / 100 ) * 0.150;   # - non-Swiss stocks

}

# as long as your trades are more than 2k in currency
# the charges are the same - so we will trade above
# that and keep the system simple!
sub get_transaction_fee {
    my $value = shift;

    my $transaction_fee = 0;

    # 2k is lower limit - fees vary below this amount
    if ( $value < $minimum_trade ) {
        die(
"error: transaction value $value is too low - must be greater that $minimum_trade\n"
        );
    }

    given ($value) {

        # calculate the Swissquote transaction fee for the
        # transaction from it's total value
        when ( $value < 10_000 )  { $transaction_fee = 35; }
        when ( $value < 15_000 )  { $transaction_fee = 50; }
        when ( $value < 25_000 )  { $transaction_fee = 75.85; }
        when ( $value < 50_000 )  { $transaction_fee = 125.85; }
        when ( $value < 75_000 )  { $transaction_fee = 175; }
        when ( $value < 125_000 ) { $transaction_fee = 220; }
        when ( $value < 125_001 ) { $transaction_fee = 250; }
    }

    $transaction_fee;

}

my $t = localtime;

my $cost = $price * $units;

print "--- Trade $stock ---\n";
print "date: ", $t->datetime, "\n";
print "Cost: $units \@ $price => $cost\n";

# caclculate the fees
if ($package) {
  print "trading with a package of cost: $package\n";
  print "stamp: ", get_stamp_duty($cost), "\n";
  print "exchange fee: ", get_exchange_fee($cost), "\n";
  my $fee2 = $package + get_stamp_duty($cost) + get_exchange_fee($cost);
  $fee2 *= 2;
  print "Total round-trip Transaction costs with Package: $fee2\n";

	}

my $fees =
  get_transaction_fee($cost) + get_stamp_duty($cost) + get_exchange_fee($cost);
$fees *= 2;
print "Round trip transaction costs (buy & sell): ", $fees, 
"(fees percentage of transaction: ", ($fees / $cost ) * 100, ")\n";

print "STOPs to set:\n";
print "-------------\n";
my $lowest = calc_stop_loss_limit( $price, $units, $fees );
print "Buy LIMIT order: ", $price, "\n";
print "Money-Management stop-loss: $lowest\n";

my $evens = calc_stop_break_even( $price, $units, $fees );
print "break-even price: $evens\n";

my $unitprice = ( ( $price * $units ) + ( $fees * 2 ) ) / $units;

print "Profit Gain Milestones:\n";
print "03% gain: ", calc_percentage( $unitprice, 3 ), "\n";
print "05% gain: ", calc_percentage( $unitprice, 5 ), "\n";
print "07% gain: ", calc_percentage( $unitprice, 7 ), "\n";
print "09% gain: ", calc_percentage( $unitprice, 9 ), "\n";
print "--- Account ---\n";
print "Trading Account: $iban\n";
print "BalaFund Trading equity: $equity $fx_base\n";
print
"Maximum allowable loss per trade: $max_single_loss (=> $pc_max_trade_loss % of trading equity)\n";
print "note that losses INCLUDE trading fees & shrinkage!\n";
