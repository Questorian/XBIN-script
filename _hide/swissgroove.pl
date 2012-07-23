#!perl -s

# get the current play track on Swissgroove.ch and
# optionally add to my buy list

#tbd:
## document in correct POD format
## include a lookup in discogs.com?
## include other inputs - Giles, other shows?
## re-write with a good, correct template
## star rating (1-5) how good it is - these get ordered first
## Add a version that deals with Giles Peterson
## music Q - parse and search in Newzbin
## get best price in various locations - CH, UK, DE - preise search
## deveop these into useful, cool, "internet tools"
## get record label

# history - done:
# 2012-02-09
## commandl line parameters -solved with '#!perl -s' option - work on Windows!
## option to open the Q file in the editor after posting - for comments etc
## option to add/not add to music Q file
## note these comments will migrate to POD - when we get round to it
## wrapped file print handles in braces, eg: print {$fh} "hello world!\n" - PBP

use strict;
use warnings;

use LWP::Simple;
use URI::Escape;
use DateTime;

our ( $help, $tune, $edit, $goog );    # cmdline switches
my ( $track, $artist, $album, $label, $year, $stars );    # tune attributes

my $url    = "http://swissgroove.ch/php/getCurrentlyPlaying.php";
my $orders = "v:\\_data\\Q\\music.txt";

# my $orders = "music.txt";

give_help() if $help;

my $source     = 'swissgroove.ch';
my $_delimeter = '~';

# get a timestamp
my $now = DateTime->now->ymd();

# set some defaults
$stars = 3;
$label = 'label-unknown';

# This is the sequence in the source HTML that we look for:
#
#  <strong>Künstler:</strong> Ian Pooley<br />
#  <strong>Lied:</strong> All About You (ft Tami Bokay)<br />
#  <strong>CD:</strong> Souvenirs<br />
#  <strong>Jahr:</strong> 2004<br />
#

my $buff = get($url);

#get artist
if ( $buff =~ /nstler:<\/strong> (.*)<br \/>/ ) {
    $artist = $1;

}

#get track
if ( $buff =~ /Lied:<\/strong>(.*)<br \/>/ ) {
    $track = $1;
}

#get album
if ( $buff =~ /CD:<\/strong>(.*)<br \/>/ ) {
    $album = $1;
}

#get year
if ( $buff =~ /Jahr:<\/strong>(.*)<br \/>/ ) {
    $year = $1;
}

$artist = trim($artist);
$track  = trim($track);
$album  = trim($album);
$year   = trim($year);

# prepare the delimited string for easy reading and parsing
# other scripts and processes of te "bag2" music system
my $display =
      "$artist $_delimeter $track $_delimeter $album $_delimeter "
    . "$label $_delimeter $year $_delimeter $stars star $_delimeter "
    . "$now $_delimeter $source $_delimeter";

print "$display \n ";
append_file($display) if ( !$tune );
edit_file()           if $edit;
goog_track()          if $goog;

sub trim {

    # my $string = 'Truth &amp; Simplicity &amp; Love';
    my $string = shift;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;

    # Bonus - clean-up the HTML Character Entity '&amp;' (escape sequences)
    $string =~ s/&amp;/\&/gi;

    $string;
}

sub goog_track {

    # pack up the args - escape the spaces, etc
    my $args =
          uri_escape($artist) . '+'
        . uri_escape($track) . '+'
        . uri_escape($album) . '+'
        . uri_escape($year);

    # call the Oracle...I mean Google...
    `start http://www.google.com/search?q=$args`;

}

sub append_file {
    my $new = shift;
    my $fh;

    # open the old file and read it in
    open( $fh, '<', $orders );
    my @buff = <$fh>;
    close($fh);

    # apend the contents again
    if (@buff) {
        open( $fh, '>', $orders );
        print {$fh} $new . "\n ", @buff;
        close($fh);
    }

}

sub edit_file {

    `ed $orders`;
    exit 0;

}



sub give_help
{

print <<"END_OF_HELP"
Display/Log the current tune being played on swissgroove.ch:

source url:     $url
target file:    $orders

Command line switches:
  -help     give this help
  -edit     open the tunes file ($orders) for editing afterwards
  -tune     dump track info to STDOUT (but no logging)
  -goog     google the tune (Turk-right-sucker-to-Seth)
END_OF_HELP
  ;

exit 1;


}


__END__

=pod

Check out the URL for more Google search url patterns

* http://googlesystem.blogspot.com/2006/07/meaning-of-parameters-in-google-query.html

=cut