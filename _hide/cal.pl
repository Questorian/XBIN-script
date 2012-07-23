#!/usr/bin/perl
# cal.pl - Display the calendar of a given month.
# Fedon Kadifeli, 1998 - April 2003.

use integer;

%mon_ord = (
    "jan" => 1,
    "feb" => 2,
    "mar" => 3,
    "apr" => 4,
    "may" => 5,
    "jun" => 6,
    "jul" => 7,
    "aug" => 8,
    "sep" => 9,
    "oct" => 10,
    "nov" => 11,
    "dec" => 12,
);
@monames = (
    "",
    " January",
    " February",
    "  March",
    "  April",
    "   May",
    "  June",
    "  July",
    "  August",
    "September",
    " October",
    " November",
    " December"
);
@monlens = ( 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );

die "Usage: cal.pl [month] [year]\n" if $#ARGV > 1;

( $t, $t, $t, $t, $mon1, $year1, $t, $t, $t ) = localtime(time);
$mon = ( defined $ARGV[0] ) ? $ARGV[0] : $mon1 + 1;
if ( $mon =~ /^ *\d{1,2} *$/ ) {
    die "Month must be between 1 and 12!\n" unless ( $mon >= 1 && $mon <= 12 );
}
else {
    $mon = $mon_ord{ lc( substr( $mon, 0, 3 ) ) };
    die "Wrong month name: $ARGV[0]!\n" unless defined($mon);
}
$year = ( defined $ARGV[1] ) ? $ARGV[1] : $year1 + 1900;
die "Wrong year: $year!\n" unless $year =~ /^ *\d{4} *$/;
$year = int($year);
die "Year must be greater than 0!\n" unless $year > 0;
print "\n\t$monames[$mon] $year\n\nMon  Tue  Wed  Thu  Fri  Sat  Sun\n";
$monlens[2] = 29
  if ( $year % 400 == 0 ) || ( ( $year % 4 == 0 ) && ( $year % 100 != 0 ) );
--$year;
# FJB edit 2011-07-19 - week starts on Monday (substract 1 from below)
$st = 0 + $year * 365 + $year / 4 - $year / 100 + $year / 400;

for ( $i = 1 ; $i < $mon ; ++$i ) {
    $st += $monlens[$i];
}
$st %= 7;
for ( $i = 0 ; $i < $st ; ++$i ) {
    print "     ";
}
for ( $i = 1 ; $i <= $monlens[$mon] ; ++$i ) {
    printf "%3d  ", $i;
    print "\n" if ( $st + $i ) % 7 == 0;
}
print "\n\n";

