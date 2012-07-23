use strict;
use Net::Ping;
use Time::Piece;

my ( @hosts, @failed, $t, $host, $timeout, $p, $str, $my_addr );

#setup the hosts, three should do...
$t = localtime;
$my_addr = "sqsaaa01";
$timeout = 5;
@failed  = ();
@hosts   = qw(

  sqsaaa01.questor.intra
  www.cern.ch
  www.bbc.co.uk
  www.google.com
  swisstime.ethz.ch

);


#make a new ping object
$p = Net::Ping->new("icmp") || die "Can't make pinger object: $!";
$p->bind($my_addr);    # Specify source interface of pings
foreach $host (@hosts) {
    if ( !( $p->ping( $host, $timeout ) ) ) {
        push ( @failed, $host );
    }

    sleep(1);
}
$p->close();

if (@failed) { print "\n", $t->datetime, "\t@failed" }