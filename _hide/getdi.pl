#dump a WWW url to standard output

use strict;

use LWP::Simple;

my $url = "http://quotes.ino.com/chart/?s=NYBOT_DXY0&v=w";

my $buff = get( $url );

# if ($buff =~ /Last trade.*B>(\d\d.\d\d)/ ) {

# new version - <tr><th scope="row">Last Price</th><td>78.691</td></tr>
if ($buff =~ /Last Price.*td>(\d\d.\d\d\d)/ ) {

    print "dollar index = $1\n";
	}
