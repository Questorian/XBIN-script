use strict;
use warnings;

my $char;
my $number;
my $string = 'DoC7MxN8';

# check command line - coords passed?
( my $code = shift ) or help_and_die();

#2012 L3 Security Card
my $l3card_2012 =

  "7825:3734:5202:0592:2422:8367:6055:8159:1945:8610:"
  . "5893:9538:6604:2199:4842:9618:7831:8340:5166:5572:"
  . "5578:3810:8574:0103:6694:2247:0643:7277:3417:2766:"
  . "5465:1678:3406:6336:2448:0674:5056:3871:8799:6992:"
  . "0311:7266:5271:8778:0802:8696:9723:7755:8303:0416:"
  . "5650:6378:5215:7413:1481:9450:4021:4204:7815:3663:"
  . "7252:5776:1981:7484:4479:5397:6129:8829:9003:7136:"
  . "0521:7890:7133:6112:3392:4725:2398:2274:5906:3845:"
  . "8352:6303:9159:0306:4477:7322:5897:9185:4711:0252:"
  . "4432:4321:1018:9071:8881:4323:8358:2726:5802:5978:";

# 2011 L3 Security card
my $l3card_2011 =

  "8765:6069:1286:8091:4396:4927:9281:0046:3183:3497:"
  . "6516:6516:0321:7802:0787:3727:4846:3572:8759:5478:"
  . "6109:6553:7555:1429:2278:8795:5047:2061:2681:3918:"
  . "3196:4767:1659:2057:3779:2025:8699:6963:4973:4418:"
  . "0685:2489:0109:7219:1091:0358:7343:2010:7095:9688:"
  . "7608:6550:4924:1110:4384:0220:3461:6705:9354:0907:"
  . "6371:8311:6014:3198:1738:5891:2036:3785:9530:0417:"
  . "3987:4863:1199:7570:1378:6037:0087:5383:4266:6452:"
  . "0428:9892:7456:8230:3655:5719:4999:7839:8247:3902:"
  . "4230:0169:4983:0984:4797:6878:6244:0163:5193:6065:";

print "$code: ", get_code($code), " - $string";

sub get_code {
    my $coord = shift;

    my $char;
    my $number;

    if ( $coord =~ m/([a-j])([0-9]*)/ ) {
        $char   = $1;
        $number = $2;
    }
    else {
        help_and_die();

    }

    if ( $number > 10 || $number < 1 ) {
        help_and_die();
    }

    # caculate offset into array from grid coordinates
    my $offset = ( ord($char) - ord('a') ) + ( ( $number - 1 ) * 10 );

    # print "looking up offset: $offset\n";

    my @list = split /:/, $l3card_2012;

    $list[$offset];

}

sub help_and_die {
    print "$0: error: need alphanumeric co-ordinate code - e.g: a3, c9, j4\n";
    print "letters: a - j\n";
    print "numbers: 1 - 10\n";
    exit(0);

}

__END__
