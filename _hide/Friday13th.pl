
use strict;
use warnings;

use DateTime;

# see: https://gist.github.com/3107320

foreach my $year ( 2012 .. 2020 ) {
    foreach my $month ( 1 .. 12 ) {
        my $dt = DateTime->new(
            day   => 13,
            month => $month,
            year  => $year
        );

        if ( $dt->day_name eq 'Friday' ) {
            print 'Friday 13th on: ', $dt->ymd, "\n";
        }
    }
}
