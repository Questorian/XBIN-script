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
while ( $tries < 5 && ( $random eq "1" || $repeat eq "0" ) ) {
    $tries++;

    # Turn off random, if it is on
    if ( $random eq "1" ) {
        `$wget 'http://${ATRON}/apicmd.asp?cmd=random'`;
    }

    # Turn on repeat, if it is not on
    if ( $repeat eq "0" ) {
        `$wget 'http://${ATRON}/apicmd.asp?cmd=repeat'`;
    }
    &getstate();
}
if ( $random eq "1" || $repeat eq "0" ) {
    print "The AT cannot get Random off and Repeat on, exiting...\n";
    exit(1);
}

# This seems wrong, should be type=web, but this works...
# You will most certainly have to change the URL to your desired
# Net Radio station's URL escaping special characters carefully...
`$wget 'http://${ATRON}/apiqfile.asp?type=file\&file=http%3a%2f%2fwww%2elive365%2ecom%2fplay%2f89450'`;

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
