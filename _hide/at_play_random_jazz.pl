#!/usr/bin/perl -w

use strict;

my $wget   = "wget --http-user=admin --http-passwd=admin -t 1 -q -O -";
my $random = "";
my $repeat = "";
my $tries  = 0;
my $ATRON  = "192.168.1.254";

`$wget 'http://${ATRON}/apicmd.asp?cmd=stop'`;
`$wget 'http://${ATRON}/apicmd.asp?cmd=clear'`;

# Had to make a loop out of this because the AT does not always do
# what it is told...sigh
&getstate();
while ( $tries < 5 && ( $random eq "0" || $repeat eq "1" ) ) {
    $tries++;

    # Turn on random, if it is not on
    if ( $random eq "0" ) {
        `$wget 'http://${ATRON}/apicmd.asp?cmd=random'`;
    }

    # Turn off repeat, if it is on
    if ( $repeat eq "1" ) {
        `$wget 'http://${ATRON}/apicmd.asp?cmd=repeat'`;
    }
    &getstate();
}
if ( $random eq "0" || $repeat eq "1" ) {
    print "The AT cannot get Random on and Repeat off, exiting...\n";
    exit(1);
}

# This seems wrong, should be type=web, but this works...
`$wget 'http://${ATRON}/apiqfile.asp?type=genre\&file=jazz'`;

# Start playing...
`$wget 'http://${ATRON}/apicmd.asp?cmd=play'`;
exit(0);

sub getstate {
    my $junk;
    my $line;

    my @status = `$wget http://${ATRON}/apigetstatus.asp`;
    foreach $line (@status) {
        chomp($line);
        if ( $line =~ /^RANDOM_LED=/ ) {
            ( $junk, $random ) = split ( /=/, $line );
        }
        if ( $line =~ /^REPEAT_LED=/ ) {
            ( $junk, $repeat ) = split ( /=/, $line );
        }
    }
}
