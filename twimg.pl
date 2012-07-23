# produce a set of links for TW for all images in a directory
# of the form: [img[images/pic1.png]], etc.
# note: there is also an extended form:  [img[alternate text|filename or URL][link]]

use strict;
use warnings;

use File::Copy;
use Questor::QSCDE;

my $target = shift;
my @files;
my $path;

my $configmgr07_dir = '\\\\nqsaaa01\\shrdata\\PROD\\PROJECTS\\PACK\\PACK-ConfigMgr07\\doc\\wikis\\images';
my $configmgr12_dir = '\\\\nqsaaa01\\shrdata\\PROD\\PROJECTS\\PACK\\PACK-ConfigMgr12\\doc\\wikis\\images';
my $azure_dir = 'D:\\QS\\EO\\IPANEMA\\DATA\\projects\\Azure\\project\\wiki\\images';

# list the files - for HTML swipe code                                                       
foreach my $file ( sort glob('*.png *.jpg *.gif') ) {
    push( @files, $file );

    print "[img[images/$file]]\n";

}

#move the files - if requested - to the correct directory
if ( defined($target) && @files ) {

    # exception configmgr07
    if ($target eq 'configmgr07') {
        foreach my $file (@files) {
            move( $file, $configmgr07_dir . '\\' . $file );
            }

    	}


    # exception configmgr12
    if ($target eq 'configmgr12') {
        foreach my $file (@files) {
            move( $file, $configmgr12_dir . '\\' . $file );
            }

    	}


    # exception azure
    if ($target eq 'azure') {
        foreach my $file (@files) {
            move( $file, $azure_dir . '\\' . $file );
            }

    	}


    #find the target directory
    my $qs = Questor::QSCDE->new();

    if ( my $eo = $qs->get_EO($target) ) {

        print( "moving files to: ", $eo->path_twiki_images, "\n" )
          if ( -d $eo->path_twiki_images );

        foreach my $file (@files) {
            move( $file, $eo->path_twiki_images . '\\' . $file );
        }

    }
    else {
        print "cannot find EO or PROJECT: $target - please check.\n";
    }

}

__END__

=pod

=head1 NAME

twimg.pl - generate HTML image links for TiddlyWiki

=head1 VERSION

version 0.1 (beta software)

=head1 SYNOPSIS

twimg         - generate [img[images/pic1.png]] TiddlyWiki link for files in dir
twimg Questor - generate links and move the images to the Questor Twiki dir


=head1 DESCRIPTION

=head1 TBD (To Be Done)
* add -alt option - add alt text to all of the generated tags
=head1 History
2012-01-23
* added floating image (to left) as standard e.g. [<img[images/pic1.png]]

2011-11-30 
* first version created

=head1 SEE ALSO
* C<http://www.blogjones.com/TiddlyWikiTutorial.html#HowToEmbedImages>
* QSCDE
* PACK-XBIN

=over 4

=back

=cut