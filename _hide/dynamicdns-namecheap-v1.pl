#!/usr/bin/perl
#Perl script to update Dynamic DNS for Namecheap.com
#dynamicdns-namecheap-v1.pl
use strict;
use LWP::Simple;
my($ip, @hosts, $host, $domain, $domainpw, $url, $content);

@hosts = ("www","*");
$domain = "yourdynamicdnsdomainname.com";
$domainpw = "yourdynamicdnsdomainpassword";
$ip = `ifconfig eth0 |grep inet | awk \-F \: \'\{print \$2\}\' | awk \'\{print \$1\}\'`;

foreach $host (@hosts) {

        $url = "http://dynamicdns.park-your-domain.com/update?host=".$host."&domain=".$domain."&password=".$domainpw."&ip=".$ip;
        $content = get($url);
        die "cant connect to dubdubdub" unless defined $content;
        print $content."\n"; # uncomment for output
}
