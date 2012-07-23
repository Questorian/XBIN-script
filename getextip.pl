use warnings;

use 5.012;    # turns on strictures with Perl 5.12
use LWP::Simple;

my $url = 'http://www.questorsystems.com/cgi-bin/showip.pl';

my $ip = get($url);
print $ip;
# print 'Your external (routers internet facing) IP: ', $ip;
