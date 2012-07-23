#-------------------------------------------------------------------------
#
# template.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# template.pl: Generate scripts and template text for rapid development
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-11-22T13:01:55
# History:
#		v0.2 -
#		v0.1 - 2008-11-22 - refactored from origianl version - new template
#
#-------------------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-------------------------------------------------------------------------
# (c)1997 - 2008, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

use strict;
use warnings;
use Getopt::Long;
use DateTime;
use Template;
use Config::Tiny;
use File::Basename;

my $template_config = 'V:\\_data\\ini\\Questor.ini';
my $template_directory;
my $template  = 't.pl';
my $directory = '.';
my $new_file;
my $new_filename;
my $basename;
my $dir;
my $ext;
my $list;    # show me what templates we have
my $eo;      # Entity Object - Quetsor, Nestle, etc
my $help;

# call the main function
template(@ARGV);

### Main Function ###
# Usage     : template()
# Purpose   : template -> main function  - drives program
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub template {
    my ($v) = @_;

    # no arguments - then print an error message
    if ( @_ == 0 ) {
        usage();
    }

    # read the command line arguemts - maybe they just want help message
    my $results = GetOptions(
        "template=s"  => \$template,
        "directory=s" => \$directory,
        "list"        => \$list,
        "eo=s"        => \$eo,
        "help"        => \$help,
    );

    if ($help) {
        usage();
    }

    # lets get some config informatation
    my $Config = Config::Tiny->new();

    # Open the config
    $Config             = Config::Tiny->read($template_config);
    $template_directory = $Config->{Template}->{TemplateFolder};

    # check if we have the list option
    if ($list) { list_templates(); }

    # now get the filename of the new file that should be generated
    $new_filename = $ARGV[0];
    ( $basename, $dir, $ext ) = fileparse( $new_filename, '\..*' );

    # set the configuration options for the template
    my $tt2_config = {
        DELIMITER    => ';',
        INCLUDE_PATH => $template_directory,

        # ABSOLUTE => 1,
    };

    # get the current date and time and initialise a DateTime object
    my $dt = DateTime->now;
    $dt->set_time_zone("+0200");

    # populate the TT2 data structure with data
    # this will eventually come from QSCDE
    my $vars = {
        companyname    => 'QuestorSystems.com',
        companyaddress => 'Gempenstrasse 46, CH-4053, Basel, Switzerland',
        url            => 'www.QuestorSystems.com',
        name           => 'Farley Balasuriya',
        email          => 'developer@QuestorSystems.com',
        filename       => $basename . $ext,
        basename       => $basename,
        year           => $dt->year,
        phone          => '+41 79 285 6482',
        date           => $dt->ymd,
        timestamp      => $dt->iso8601(),
    };

    # check if 'eo' is Nestle or not

    if ($eo) {

        if ( $eo eq 'nestle' ) {

            $vars = {
                companyname => 'Nestlé',
                companyaddress =>
                  'Nestlé SA, Avenue Nestlé 55, CH-1800 Vevey, Switzerland',
                url       => 'www.nestle.com',
                email     => 'FarleyJason.Balasuriya@nestle.com',
                filename  => $basename . $ext,
                basename  => $basename,
                year      => $dt->year,
                phone     => '+41 79 285 6482',
                date      => $dt->ymd,
                timestamp => $dt->iso8601(),
            };
        }
    }

    # create a new template TT2 object
    my $tt = Template->new($tt2_config);

    # build the new files pathame
    # $new_file = $directory . '\\' . $new_filename;
    $new_file = $new_filename;

    # determine which template to use
    if ( $template = $ARGV[1] ) {

        # use the 2nd parameter - as a template
        $template = $ARGV[1];
    }
    else {

        # we only got one parameter, thus use default template
        # if there is one, for file type
        $template = 't' . $ext;
        print "using default template: $template\n";
    }

    # process the template, along with it's variables data structure
    $tt->process( $template, $vars, $new_file, { binmode => 1 } )
      || die $tt->error();

    # lets go!
    # system "ed $new_filename";
    system "ed $new_file";

    return;
}

### INTERNAL UTILITY ###
# Purpose   : Lists all of the currently available templates
# Returns   : n/a - exits
# Parameters: none
# Comments  : none
# See Also  : n/a
sub list_templates {

    # unpack subroutine arguments
    my ($v) = @_;

    print "Available Templates: $template_directory\n";

    # get a list of all the templates
    foreach $template ( sort glob( $template_directory . "\\*.*" ) ) {

# make sure the filename is not a 'hidden', special file (i.e. files with '_*.*' are  hidden)
        my ( $base, $dir, $ext ) = fileparse( $template, '\..*' );
        if ( $base !~ /_/ ) {
            print "$base$ext\n";
        }
    }
    exit 0;
}

sub usage {

    # unpack subroutine arguments
    my ($v) = @_;

    print <<'END_USAGE';

template new_file_name  [optional_template_filename]

options:

    -list       list available templates
    -directory  output directory to create new file
    -template   template file to use for new file
    -eo         Entity Object (Questor, Nestle, UBS, HP, etc.)

If you do not specify a specific template for your new file then
the default will be used for the specific type, depending on the 
file extension - all default template files are called t.* - for
example t.pl, t.cmd. t.sql, t.py, etc just create and add to your
template directory.

The new_file_name can optionaly include the path to the directory
where you wish the new file to be created
    
END_USAGE

    exit 0;
}

