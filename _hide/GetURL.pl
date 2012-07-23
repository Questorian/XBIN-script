#dump a WWW url to standard output
use LWP::Simple;

print( get( "http://" . $ARGV[0] ) );
