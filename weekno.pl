#!/usr/bin/env perl -ws
use DateTime;

our ($twiki);

my $dt = DateTime->now( time_zone => 'Europe/Zurich' );

my ( $year, $week ) = $dt->week();

if ($twiki) {

    printf( "!Week %d/%0.2d\n", $year, $week );

    #print date range for info
    for ( my $i = 0; $i < 7; $i++ ) {

      print "!!", $dt->day_name, ' ', $dt->day, " ", $dt->month_name, "\n";
      $dt->add( days => 1);


    }
}
else {
    printf( "%d/%0.2d", $year, $week );
}

