# convert the Nestlé format gtime CSV file to QS format TT data for import into the TT system

# global variables
# my $job_number  = "00989";
my $job_number  = "D2D";

# new rate as of 2009-06-01 - for 8.5 our day
# my $day_rate    = 1_300;
# my $hourly_rate = 152.94;
my $hourly_rate = 144.3529;
my $day_rate    = 1_227.2;
my $days_worked = 0;
# my $csv_delim_char = ',';
my $csv_delim_char = ';';
my $csv_file = "MonthlyReport.csv";


my $month;         # month name from the report
my $month_name;    # Name of the month
my $year;          # year from the report

#sub-totals tracked here
my $total_hours = 0;

open( F,  $csv_file ) or die "unable to open input file  - $csv_file";

while (<F>) {

    # clean-up the line
    chomp();

    # get month and date from CSV file
    if (/Period : (.*) (\d\d\d\d)/) {
        $month_name = $1;
        $year       = $2;

        if ( ( $year < 2008 ) || ( $year > 2012 ) ) {
            die "Year in report file: $year is out of range";
        }

        # get the month number
        $month = month2num($month_name);

                print "-- SQL Import scrip: $month_name  ($year-$month)\n\n";
                print "Use QBase\nGo\n\n";
                print "BEGIN TRANSACTION\n\n";
    }

    if (/$job_number/) {

        # break up the CSV record - This is a timesheet line
        my @buff = split /$csv_delim_char/;

        # get the date range of this week - careful
        # the first character contains some garbage so we need to strip it off
        # let's use a regexp to strip it out
        my ( $start_date, $stop_date ) = ( $buff[0] =~ /\d+/g );

        # print "date range: $start_date - $stop_date\n";

# actually hours worked are fields 4 - 10 inclusive, and yes these are zero based
        for ( my $i = 4; $i < 11; $i++ ) {
            if ( ( my $hours = $buff[$i] ) > 0 ) {
                my $day = $start_date + ( $i - 5 );
                print "-- $year-$month-$day - worked hours: $hours\n";

                #update the total of hours that we have
                $total_hours += $hours;

                # print out the nice SQL statement for insert into the datbase
                print_it( $hours, $day );

                # increment the number of days worked
                $days_worked ++;

            }
        }
    }

}

my $sub = 0;
print "-- total days worked: $days_worked (hours: $total_hours)\n";
print "-- total nett income for month: ", $sub = $days_worked * $day_rate,
    ", (MWST: ", $mwst = $sub * (7.5/100), ", Total: ", $sub + $mwst , ") \n";

sub month2num {
    my ($month_name) = @_;

    # convert the SCCM log string month to a number usable by DateTime
    # see: http://www.perlmonks.org/?node_id=95456

    my %mon2num = qw(
        jan 1  feb 2  mar 3  apr 4  may 5  jun 6
        jul 7  aug 8  sep 9  oct 10 nov 11 dec 12
    );

    my $num = $mon2num{ lc substr( $month_name, 0, 3 ) };

    return $num;

}

sub print_it {
    my ( $worked_hours, $day ) = @_;

    print <<"SQL_END"
INSERT INTO
  dbo.TimeSheetLines
  (employee_id, ActivityCode_id, location_id, day_worked, hours_worked, comment)
VALUES
  (10001, 'SCCM', 'BUS', '$year-$month-$day', $worked_hours, 'Nestle gTime import (g2tt.pl)')


SQL_END
        ;

}
