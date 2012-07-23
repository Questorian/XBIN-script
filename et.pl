#-------------------------------------------------------------------------
#
# et.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# et.pl: Expense-Tracker - Track and charge back QS expenses
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-11-28T01:48:33
#
# TBD:
#   rewrite - so that INI file values are correctly used by this application
#   add template name to ini file
#   backup option - dump the QBase database somewhere safe - call DBA module
#   book - print a report and book the payments
#   Proper ISO8601 timeformat with date portion only i.e. 8008-12-02
#   hook-in procs - dbo.asp_get_expense_claims @my_booking_id,
#           asp_book_open_expense_claims
# History:
#
#       v1.02 - 2010-04-08 - Added default FX feature to the ini file
#       v1.01 - 2009-05-28 - Added subtotals to the printed report, and 
#                               the ClaimID number to the output report so
#                               that we can have more than one report 
#                               existing in a single directory at a time
#       v1.00 - 2009-05-12 - First production version
#       v0.92 - 2009-05-11 - corrected SQL connection string for SQL 2008
#                               moved connection string out of source code
#       v0.91 - 2009-01-07 - added the Number::Format, and TT wrapper 
#		v0.90 - 2008-12-08 - first release version and real expenses entered
#		v0.10 - 2008-11-28 - initial version created
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

use DBI;
use Carp;
use Config::Tiny;
use Getopt::Long;
use DateTime;
use Template;
use Template::Plugin::Number::Format;


# cmd-line opotions -:- global variables
my $fx = 'CHF';    # foreign currency exchange - ISO currency code
my $help;          # yes we want help
my $date;          # the date that the transaction occured
my $ago;           # date_relative - the number of days ago from today
my $timezone;
my $status;        # status of current et system
my $print;         # print an invoice to standard output
my $book;          # book the currently open expenses

# ini file - we get the DBI connection parameters (connection string) out of this file
my $ini = "v:/_data/ini/Questor.ini";

# $ini_section - change this to the name of the section you want loaded in the ini file
my $ini_section = "QBase";

my $query_1 = q{
insert into 
	expense_items
	(value_date, amount, currency_code, category, description, amount_CHF)
values
    (?, ?, ?, ?, ?, dbo.convert_to_CHF(?, ?))
	
};

# return the currencies
my $query_2 = q{
    select CurrencyCode, CurrencyName from dbo.ISOCurrencies order by CurrencyCode
};

# get a list of valid expense categories
my $query_3 = q{
    select Category, Description from dbo.ExpenseCategories order by Category
};

# get 'what's in the pot?' report - how much are we owed?
my $query_4 = q{
  select 
	sum(amount_CHF) 
from 
	dbo.expense_items
where 
	booked_date IS NULL
};

# get 'what's in the pot?' report - but how many items
my $query_5 = q{
  select 
	count(*)
from 
	dbo.expense_items
where 
	booked_date is NULL
};

# break-down by category
my $query_6 = q{
  select 
	Category, sum(amount_CHF)as 'Subtotal'
from 
	dbo.expense_items
where 
	booked_date is NULL
group by category
};

# dump the last 'n' transactions
my $query_7 = q{
select 
	top (20)
	expense_id,  CONVERT(nvarchar(30), value_date, 102), category, amount, 
	currency_code, amount_CHF, description
from
	dbo.expense_items
Where
    booked_date is NULL
order by
	expense_id desc
};

my $query_8 = q{
  exec dbo.asp_get_expense_claims @my_booking_id = ?
};

my $query_9 = q{
  select booking_id, CONVERT(nvarchar(30), booked_date, 102) , amount_CHF, CONVERT(nvarchar(30), payment_date, 102)  
    from 
        dbo.expense_claims
    order by
        booking_id DESC
};

my $query_10 = q{
  exec dbo.asp_book_open_expense_claims
};


my $query_11 = q {
  select amount_CHF from dbo.expense_claims where booking_id = ?
};

my $query_12 = q {
select 
	expense_id,  CONVERT(nvarchar(30), value_date, 102) as value_date, 
    category, amount, 	currency_code, amount_CHF, description
from
	dbo.expense_items
where
	booked_date = 
    (select booked_date from dbo.expense_claims where booking_id = ?)
order by
	expense_id

};

my $query_13 = q {
  select 
	Category, 
	sum(amount_CHF)as 'Subtotal',
	(select Acc1 from dbo.ExpenseCategories where Category = a.Category) as Acc1,
	(select Acc2 from dbo.ExpenseCategories where Category = a.Category) as Acc2
from 
	dbo.expense_items as a
where 

	booked_date = 
    (select booked_date from dbo.expense_claims where booking_id = ?)

group by category

};

# call the main function
expense(@ARGV);

### Main Function ###
# Usage     : expense()
# Purpose   : expense -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub expense {
    my ($v) = @_;

    # Command line options
    # parse the command line arguments if any
    my $result = GetOptions(
        "help"    => \$help,
        "date=s"  => \$date,
        "ago=i"   => \$ago,
        "fx=s"    => \$fx,
        "status"  => \$status,
        "book"    => \$book,
        "print=i" => \$print,

    );

    # check the options
    if ($help) {
        give_help(@ARGV);
    }

    # check if caller wants just a status
    if ($status) {
        give_status(@ARGV);
    }

    # they want to raise an expense claim
    if ($print) {
        print_expenses($print);
    }

    # book
    if ($book) {
        book_claims(@ARGV);
    }

    # Command line arguments
    my ( $amount, $category, $description );

    if ( 2 > @ARGV ) {
        print "error: you need to specify at least 2 arguments \n";
        give_help();
    }

    $amount   = shift @ARGV;
    $category = uc( shift @ARGV );

    # 1 left to shift, if 3 was specified
    if ( 1 == @ARGV ) {
        $description = shift @ARGV;
    }

    my $dbh = open_db_with_ini( $ini, $ini_section, 0 );

    if ($date) {

        # we have a custom date - break it down
        my @parts = split( /-/, $date );
        my ( $year, $month, $day );

        # find out if they specified mm-dd, or full yyyy-mm-dd

        if ( @parts == 2 ) {

            # short form specified - assume current year
            ( $month, $day ) = @parts;
            $year = DateTime->now()->year;
        }
        elsif ( @parts == 3 ) {

            # full date has been specified - yyyy-mm-dd
            ( $year, $month, $day ) = @parts;
        }
        else {
            die "$date - is not in yyyy-mm-dd, or mm-dd format";
        }

        # do some sanity checking on the month parts supplied
        if ( $year < 2005 || $year > 2015 ) {
            die "$year out of bounds - (2005 - 2015)\n";
        }
        if ( $month < 1 || $month > 12 ) {
            die "month $month is out of range - (1 - 12)";
        }
        if ( $day < 1 || $day > 31 ) {
            die "day $day is out of range - ( 1 - 31 )";
        }

        $date = DateTime->new(
            year      => $year,
            month     => $month,
            day       => $day,
            time_zone => 'Europe/Zurich',
        );

    }
    else {

        # use todays date for expense item
        $date = DateTime->now();

        # need to apply the time_zone at some point
    }

    if ($ago) {

        # ok we have a transaction that occured a number of days ago
        if ( $ago <= 0 ) {
            die
"$ago - out of range - specify the number of days ago as positive number";
        }
        if ( $ago > 60 ) {
            die
"$ago - out of range - specify the date as a date string, i.e. 2009-01-01";
        }

        # now lets do it:
        $date->subtract( days => $ago );

    }

    # execute do() - from the $dbi handle
    $fx = uc($fx);
    my $rows = $dbh->do(
        $query_1,  undef,        $date->ymd, $amount, $fx,
        $category, $description, $amount,    $fx
    );

    # get the unique id number - SET @ExpenseID = SCOPE_IDENTITY()
    my $sth2 = $dbh->prepare('SELECT @@Identity');
    $sth2->execute();
    my $id = $sth2->fetchrow_array();

    # close the statement handle
    $sth2->finish;

    $id = "can't tell" if !defined($id);
    print "Expense ID: $id\n";

    # disconnect and exit
    $dbh->disconnect;

    return;
}

sub print_expenses
{
my ($claim_id)=@_;

my $total = 999.45;
my $template_directory = 'V:\\_data\\templates';
my $template = 'expense_claim_category.tt2';
# my $new_file = 'c:\\temp\\expense_claim_out.html';
my $new_file = 'c:\\temp\\expense_claim_out-';
my (@items, @subtotals);


    if ($claim_id == 0 ) {

        # we need to find the latest one
        tbd();
    	}

    # format the claim id - make it purdy
    $claim_id = sprintf("%0.3d", $claim_id);

    # set the configuration options for the template
    my $tt2_config = {
        DELIMITER    => ';',
        INCLUDE_PATH => $template_directory,

        # ABSOLUTE => 1,
    };


    # calculate the total amount of the claim for the report
    # open the databaes and find all the valid currencies
    my $dbh = open_db_with_ini( $ini, $ini_section, 0 );

    # get the total amount of this calim
    my $sth = $dbh->prepare($query_11);
    $sth->execute($claim_id);
    $total = $sth->fetchrow_array();

    # now lets get all the rows for the table
    $sth = $dbh->prepare($query_12);
    $sth->execute($claim_id);
    while ( my $row_ref = $sth->fetchrow_hashref()  ){
        push(@items, $row_ref);
    }


    # lets get the subtotals for the subtotal report
    $sth = $dbh->prepare($query_13);
    $sth->execute($claim_id);
    while ( my $row_ref = $sth->fetchrow_hashref()  ){
        push(@subtotals, $row_ref);
    }


    # update the name of the report to be generated
    $new_file = $new_file . $claim_id . '.html';


    # define the variables
    my $vars = {
      title => "Expense Reclaim Report - $claim_id",
      claim_id => $claim_id,
      total => $total,
      date => DateTime->now()->ymd,
      items => \@items,
      subtotals => \@subtotals,
    };


        # create a new template TT2 object
    my $tt = Template->new($tt2_config);


    # print the claim form with the template
        print "Printing ClaimID : #$claim_id  ->  $new_file\n";
    $tt->process( $template, $vars, $new_file ) || die $tt->error();


    # exit the program
    exit (1);

}


sub print_expenses2 {
    my ($v) = @_;

    # open the databaes and find all the valid currencies
    my $dbh = open_db_with_ini( $ini, $ini_section, 0 );

    # show the last 5 transactions
    my $sth = $dbh->prepare($query_7);
    $sth->execute();
    print "\nLast Transactions:\n";
    print "------------------\n";
    while (
        my (
            $expense_id,    $value_date, $category, $amount,
            $currency_code, $amount_CHF, $description
        )
        = $sth->fetchrow_array()
      )
    {

        # tidy-up the description
        $description = "<none>" if ( !defined($description) );

        # remove currency code, if it is the base rrency code
        $currency_code = '' if ( $currency_code eq 'CHF' );

        # clean up the date
        $value_date =~ s/\./-/g;

        printf(
            "#%0.3d %s %-5s %6.2f %3s - %5.2f CHF %-20s\n",
            $expense_id,    $value_date, $category, $amount,
            $currency_code, $amount_CHF, $description
        );
    }

    # leave
    exit(0);

}

sub give_status {
    my ($v) = @_;

    my $sth;
    my $total_claims = 0;    # total claims to date

    # show the following thigs: last transaction ID, next transactionID,
    # next bill: Total value of items, How many items
    # show the last 5 transactions

    # open the databaes and find all the valid currencies
    my $dbh = open_db_with_ini( $ini, $ini_section, 0 );

    # "what's in the post?" - how much?
    $sth = $dbh->prepare($query_4);
    $sth->execute();
    my $valuation = $sth->fetchrow_array();

    # "what's in the post?" - how many?
    $sth = $dbh->prepare($query_5);
    $sth->execute();
    my $count = $sth->fetchrow_array();

    # display  the result
    $valuation = 0 if ( !defined($valuation) );    # NULL check
      printf( "Current valuation: %0.2f CHF\n", $valuation );
    print "Number of open expenses: $count\n";
    print( "Next transaction ID: ", "<tbd>", "\n" );

    # show the last 5 transactions
    $sth = $dbh->prepare($query_7);
    $sth->execute();
    print "\nLast Transactions:\n";
    print "------------------\n";
    while (
        my (
            $expense_id,    $value_date, $category, $amount,
            $currency_code, $amount_CHF, $description
        )
        = $sth->fetchrow_array()
      )
    {

        # tidy-up the description
        $description = "<none>" if ( !defined($description) );

        # remove currency code, if it is the base currency code
        $currency_code = '' if ( $currency_code eq 'CHF' );

        # clean up the date
        $value_date =~ s/\./-/g;

        printf(
            "#%0.3d %s %-5s %9.2f %3s - %9.2f CHF %-20s\n",
            $expense_id,    $value_date, $category, $amount,
            $currency_code, $amount_CHF, $description
        );
    }

    # now show the last Claims
    $sth = $dbh->prepare($query_9);
    $sth->execute();
    print "\nLast Claims:\n";
    print "-------------\n";

    while ( my ( $booking_id, $booked_date, $amount_CHF, $payment_date ) =
        $sth->fetchrow_array() )
    {

        $payment_date = "<unpaid>" if ( !defined($payment_date) );

        # clean up the dates
        $booked_date  =~ s/\./-/g;
        $payment_date =~ s/\./-/g;

        # updat the running-total
        $total_claims += $amount_CHF;

        printf( "#%0.3d %s %9.2f %s\n",
            $booking_id, $booked_date, $amount_CHF, $payment_date );

    }

    print "Total claims booked: $total_claims\n";

    # exit
    exit(0);
}

sub display {
    my ($v) = @_;

    # temp for now
    my $sth;

    # iterate each row - dump quick and dirty
    while ( my @row = $sth->fetchrow_array ) {
        print "@row\n";
    }

}

sub book_claims {
    my ($v) = @_;

    # open the databaes and find all the valid currencies
    my $dbh = open_db_with_ini( $ini, $ini_section, 0 );

    # now book all the open claims - use do
    $dbh->do($query_10);

    # quit
    exit(1);

}

### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub give_help {
    my (@args) = @_;

    print <<"END_OF_HELP";
et - enter an et item into the QBase db and get a folio number back

usage:

    et [-options] amount category [description]

options:

    -date   date yyyy-mm-dd | mm-dd  (see notes below for explanation)
    -ago    ago - number of days ago (positive number: 1-60)
    -fx     EUR | USD | GBP | CHF | ... (see below for supported currencies)
    -status Show current status, and amount ready for payout
    -book   book the outstanding expenses, to claim #id
    -print  print a claim form - need claim #id number

examples:

    et 12.36 SUB
    et 28.46 CAR petrol
    et 99.00 TRAV "Lausanne - Basel - return ticket"
    et 329 CAPEX  "windows Vista Business edition licence for office"
    et -date 2008-07-11 40.00 TRAV "another train ticket"
    et -date 07-11 40.00 TRAV "same as above - assumes this year"
    et -date 12-25 40.00 TRAV "travel et christmas this year"
    et -ago 4 22.00 SUB "something else that I needed to eat 4 days ago"
    et -fx EUR 150.00 SUB "Dinner in Germany, or was it France?"

currency codes (for -fx option):

END_OF_HELP

    # open the databaes and find all the valid currencies
    my $dbh = open_db_with_ini( $ini, $ini_section, 0 );

    # prepare a statement
    my $sth = $dbh->prepare($query_2);
    $sth->execute();
    while ( my ( $fx_code, $description ) = $sth->fetchrow_array() ) {
        print "    $fx_code - $description\n";
    }

    print "\nexpense categories:\n\n";

    # prepare a statement - get the
    $sth = $dbh->prepare($query_3);
    $sth->execute();
    while ( my ( $category, $description ) = $sth->fetchrow_array() ) {
        print "    $category - $description\n";
    }

    # close dbi handle
    $dbh->disconnect;

    print <<"END_OF_HELP2";

notes:
* you can enter the date in the full ISO8601 format (e.g. yyyy-mm-dd), or you
  can use the more convenient mm-dd format for enering a date this year - the 
  system will assume the current year. This is for your date entering 
  convenience.

END_OF_HELP2

    # help given - now get the f*ck out of dodge
    exit(1);
}

sub open_db_with_ini {
    my ( $ini_file, $ini_section, $debug ) = @_;

    if ($debug) {

        #check the ini file exist - get the DB location information
        if ( -f $ini ) {
            print "found existing ini file: $ini";
        }
        else {
            croak "unable to find ini file: $ini\n";
        }

    }

    # create a config object
    my $config = Config::Tiny->new();

    # open the config file
    $config = Config::Tiny->read($ini_file);

    if ($debug) {

        #print out the data we want...
        print "\nDumping out INI file parameters:\n";
        print "----------------------------------\n";
        print "connection string : $config->{$ini_section}->{connection_string}\n";
        print "persona           : $config->{$ini_section}->{persona}\n";
        print "server            : $config->{$ini_section}->{server}\n";
        print "database          : $config->{$ini_section}->{database}\n";
        print
          "trusted connection: $config->{$ini_section}->{trusted_connection}\n";
        print "----------------------------------\n";
    }

    # DBI::ADO connectino string
    # my $ms_con_str = "dbi:ADO:Driver={SQL Native Client};
   my $ms_con_str = "$config->{$ini_section}->{connection_string};
   Server=$config->{$ini_section}->{server};
   Database=$config->{$ini_section}->{database};
   trusted_connection=$config->{$ini_section}->{trusted_connection}";

   # set default currency from INI file if defined
   if (my $ini_fx = $config->{$ini_section}->{FX}) {
     print "WARNING: Switching FX currency from ini file: $ini_fx\n\n";
     $fx = $ini_fx;
   	}

    # database handel - connect to the database
    my $dbh =
      DBI->connect( $ms_con_str,,,
        { RaiseError => 0, PrintError => 0, TimeOut => 5 } )
      or die $DBI::errstr;

    # let's get some tracing on this
    DBI->trace( 1, "c:\\temp\\dbitrace.txt" );

    # return the database handle
    return $dbh;

}

sub tbd()
{
my ($v)=@_;


    die "function not impletemented yet - please try later...!\n";

}
