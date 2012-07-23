#!/usr/bin/perl

# turn on perl's safety features
use strict;
use warnings;

# work out the name of the module we're looking for
my $module_name = $ARGV[0]
  or die "Must specify module name on command line";

# create a new browser
use WWW::Mechanize;
my $browser = WWW::Mechanize->new();

# tell it to get the main page
$browser->get("http://search.cpan.org/");

# okay, fill in the box with the name of the
# module we want to look up
$browser->form(1);
$browser->field( "query", $module_name );
$browser->click();

# click on the link that matches the module name
$browser->follow($module_name);

my $url = $browser->uri;

# launch a browser...
system( 'C:\Program Files\Mozilla Firefox\firefox.exe', $url );

exit(0);
