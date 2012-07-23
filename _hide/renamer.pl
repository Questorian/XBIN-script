use strict;
use warnings;

# standarised naming is always good

# general purpose script to rename files

while (<*.*>) {

    #
    # PDF
    #

    # AdenForecast - old style renaming
    /AdenHSL-(\d\d\d\d)-(\d\d)\.pdf$/
        and print "rename $_  AdenForecast-$1-$2.pdf\n";

    # match - GCRU
    /GCRU\.(\d\d)\.(\d\d)\.(\d\d\d\d)\.\d+\.pdf$/i
        and print "rename $_ GCRU_$3-$1-$2.pdf\n";

    # SQB Contract Notes - Stock_Exchange_Advice_40471069_23-02-2012.pdf
    /Stock_Exchange_Advice_(\d+)_(\d+)-(\d+)-(\d+)\.pdf/
        and print "rename $_ SQB_$4-$3-$2_contract_$1.pdf\n";

    # SQB FX Transfer Notes - Stock_Exchange_Advice_40471069_23-02-2012.pdf
    /Transfer_Advice_(\d+)_(\d+)-(\d+)-(\d+)\.pdf/
        and print "rename $_ SQB_$4-$3-$2_Forex_$1.pdf\n";

    #
    # AUDIO
    # -----

    # KWN PodCasts

    if (/KWN Weekly Metals Wrap (\d+)_(\d+)_(\d\d\d\d).mp3$/) {

        my ( $name, $month, $day, $year ) = ( $1, $2, $3, $4 );
        $name =~ s/\s+$//;

        printf(
            "rename \"$_\" \"KWN - %d-%02d-%02d - KWN Weekly Metals Wrap.mp3\"\n",
            $year, $month, $day, $name );

    }

    if (/(.*)(\d+)_(\d+)_(\d\d\d\d).mp3$/) {

        my ( $name, $month, $day, $year ) = ( $1, $2, $3, $4 );
        $name =~ s/\s+$//;

        printf( "rename \"$_\" \"KWN - %d-%02d-%02d - %s.mp3\"\n",
            $year, $month, $day, $name );

    }

    if (/(.*)(\d+) (\d+) (\d\d\d\d).mp3$/) {

        my ( $name, $month, $day, $year ) = ( $1, $2, $3, $4 );
        $name =~ s/\s+$//;

        printf( "rename \"$_\" \"KWN - %d-%02d-%02d - %s.mp3\"\n",
            $year, $month, $day, $name );

    }

}

