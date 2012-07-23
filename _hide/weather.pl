#use modules
use LWP::Simple;

my $debug = 0;

#global variables that we need
#-----------------------------
#where to get the weather from - Yahoo!
%locations = (

    basel2 => "http://weather.yahoo.com/switzerland/canton-of-basel-city/basel-city-781739/",
    basel => "http://weather.yahoo.com/forecast/SZXX0004_c.html?force_units=1",
    redhill => "http://weather.yahoo.com/forecast/UKXX0606.html",
    malaga  => "http://weather.yahoo.com/forecast/SPXX0052.html",
    colombo => "http://weather.yahoo.com/forecast/CEXX0001.html",
    geneva  => "http://weather.travel.yahoo.com/forecast/SZXX0013.html",
    zermatt => "http://weather.travel.yahoo.com/forecast/SZXX0042.html",
    berlin  => "http://weather.travel.yahoo.com/forecast/GMXX0007.html"

);

#list of what we want - by default, gimme all
my @places = ();
foreach ( keys(%locations) ) {
    push ( @places, $_ );
}

# does the user want some custom behaviour?
if ( $ARGV[0] ) {
    @places = ();
    while ( $ARGV[0] ) {
        push ( @places, $ARGV[0] );
        shift;
    }

}

my $t = localtime;
print "Weather Report: $t\n\n";
foreach (@places) {
    getWeather($_);
}

# end of program

sub getWeather() {
    my ($place) = @_;
    my @fc    = ();
    my $found = 0;

    #retrieve the weather from URL
    $content1 = get( $locations{$place} );

    @content = split ( /\n/, $content1 );
    foreach $line (@content) {
        chomp($line);
        print "Parsing line $line\n" if ($debug);
        if ( $line =~ /ENDTEXT FORECAST/ ) {
            $found = 0;
        }
        if ( $found && $line =~ /^<b>/ ) {
            $line =~ s/<b>//;
            $line =~ s/<\/b>//;
            $line =~ s/<p>//;
            print "Checking line $line\n" if ($debug);
            if ( $line =~ /^To/ ) {    # To{day,night,morrow}
                print "Found line $line\n" if ($debug);
                push ( @fc, $line );
            }
        }
        if ( $line =~ /TEXT FORECAST/ ) {
            $found = 1;
        }
    }
    $underline = $place;
    $underline =~ s/[a-z]/-/ig;
    print "\u$place\n";
    print( $underline, "\n" );
    foreach $fcl (@fc) {
        $fcl = &convert_units($fcl);
        print "$fcl\n";
    }
    print "\n";
}

sub convert_units() {
    my ($str) = @_;

    #convert to celsius
    $str =~ /(\d+)F/;
    $num = ( 5 / 9 ) * ( $1 - 32.0 );
    $num = int($num);
    $str =~ s/(\d+)F/$num C/g;

    #conver the wind speeeds to KM/h - to
    if ( $str =~ /(\d+) to/ ) {
        $num = $1 * 1.6;
        $str =~ s/(\d+) to/$num to/;
    }

    #conver the wind speeeds to KM/h - kph
    $str =~ /(\d+) mph/;
    $num = $1 * 1.6;
    $str =~ s/(\d+) mph/$num kph/;

    $str;
}
