##############################################################
# purpose:
# created:
#
# Farley Balasuriya  - farley@questor.ch
#
##############################################################


# note: we may need to migrate to something like:
#   http://search.cpan.org/~burak/MP3-M3U-Parser-2.20/lib/MP3/M3U/Parser.pm

use strict;
use warnings;

use File::Basename;
use File::Copy;
use Getopt::Long;

my ( $pl, $dest, @flist );
my ( $name, $path, $suffix, @suffixlist );
@suffixlist = qw( .wma  .WMA  .mp3  .MP3);

# command line switches
my $randomise
  ;  # do we want a random selection of music from the playlist? - Default is no
my $maxfiles = 0;    # limit the maximum number of files copied to the target
my $genplaylist = 0;    #generate a new playlist with the new absolute paths of the new device
my @new_playlist;

my $result = GetOptions(
    "randomise"    => \$randomise,
    "maxfiles=i" => \$maxfiles,
    "genplaylist"  => \$genplaylist
);

# get the command line arguments
$pl   = $ARGV[0];
$dest = $ARGV[1];



print "playlist: $pl";
@flist = pl_Open($pl);
print "\n";

print "copy to: $dest\n";

#do we need to randomise the Playlist copy?
if ($randomise) {

    #randomise the playlist
    @flist = pl_RandomPL(@flist);
}

#do we need to limit the number of files to copy?
if ( $maxfiles > 0 ) {
    if ( $maxfiles < @flist ) {
        @flist = @flist [ 0 .. ($maxfiles -1)];
    }
}

#start copying ...
foreach my $tune (@flist) {

    #generate the target name
    my $target_path = pl_GenTargetPath( $tune, $dest);

    print "\n$target_path";

    #make the path, in case it is not already there..
    my ( $name, $path, $suffix ) = fileparse( $target_path, @suffixlist );
    if ( !-r $path ) {
        system("md \"$path\"");
    }

    #do the copy
    my $exec_str = "copy \"$tune\" \"$target_path\" /B";
    if ( !-r $target_path ) {
        copy( $tune, $target_path );
    }

    # do we need to create a new playlist?
    if ($genplaylist) {
      push (@new_playlist, $target_path);
    	}
 }

# do we need to write the new playlist?
if (@new_playlist) {
    print "\nPlaylist follows:\n";
    print join "\n", @new_playlist;
	}


exit(0);

#return the playlist, but with the items randomised
sub pl_RandomPL() {
    my (@playlist) = @_;

    my @randomised_playlist;

    for ( my $i = 0 ; $i < @playlist ; $i++ ) {
        push @randomised_playlist, $playlist[ rand @playlist ];
    }
    @randomised_playlist;
}

sub pl_GenTargetPath() {
    my ( $source, $destination) = @_;

    my $target_path;
    
    # we need to split the path into it's components and take the last three elements, like this:
    # artist    len - 3
    # album     len - 2
    # track     len - 1
    # then we can build up a new target path and return it to the caller
    my ($artist, $album, $title ) = (split /\\/, $source)[-3, -2, -1];

    # build up the new destination path string
    $target_path = $destination . "\\$artist\\$album\\$title";
}

#open and parse a playlist file, remove the comments and get a certain amount of status information about it
#
sub pl_Open() {
    my ( $playlist, $lines ) = @_;

    # does not work
    my $size;
    my $lines = 0;
    my ( $blanks, $bytes, $media, $comments, @online, @offline );

    # process the playlist
    open( IN, $playlist ) || die "cannot open $playlist";
    while (<IN>) {
        $lines++;

        # is this a comment? - comment char '#' must be at start of line
        if (m/^#/) { $comments++; next }

        # is is a blank line?
        if (m/^$/) { $blanks++; next }

        #we have a media file
        $media++;
        chomp();
        if (-r) { push( @online, $_ ); $bytes += -s }
        else { push( @offline, $_ ) }

    }

    #return the list of online files
    @online;

}

