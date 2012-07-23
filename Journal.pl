#-------------------------------------------------------------------------
#
# journal.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# journal.pl: Manage, merge, and back-up the FJB Journals
#
# Project:
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2008-10-26T12:54:53
# History:
#       v0.3 - 2010-02-09 - added the -review option - real power!
#		v0.2 - 2008-12-04 - updated SVN keyword for this file
#		v0.1 - 2008-10-26 - initial version created
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

use DateTime;
use Getopt::Long;
use File::Spec;
use File::Copy;

#use Config::Std;
#use Config::Tiny;

# global variables - evetually move to INI file
my $journal_relative_path = '\\DATA\\DOCS\\documentation\\Journals\\';
my $journal_bakcup_dir    = '_backups';
my $journal_QS_backup_dir = 'D:\\QS\\EO\\QUESTOR\\BKUP\\journal';
# my @review_days = (1,3,7,14,21,90);
my @review_days = (1,3,7,21,90,182,365);

# global variables - maybe get rid of these eventualy
# ----------------
my %journals;            # a list of all the journals we have found
my %all_journal_conent;  # the content from all of the found and loaded journals
my $content;             # The rendered content of selected journals

# variables for the command line arguments
my ( $review, $rd, $rw, $rf, $rm, $rq, $rh, $ry, $backup, $dump, $help, $search );

my $result = GetOptions(
    "review" => \$review,
    "rd"     => \$rd,
    "rw"     => \$rw,
    "rf"     => \$rf,
    "rm"     => \$rm,
    "rq"     => \$rq,
    "rh"     => \$rh,
    "ry"     => \$ry,
    "backup" => \$backup,
    "dump"   => \$dump,
    "help"   => \$help,
    "s=s"    => \$search,
);

# now lets works out what the user wants to do

# if it's help they want give them that before anything else
if ($help) {
    help_journal();
    exit(0);
}

# first lets find some journals by looking in the right places
find_journals( \%journals );

# backup - always first - safest and the only action possible if specified
if ($backup) {

    # lets make a quick backup of our valuable journals
    backup_journals(%journals);
    exit(0);
}

if ($dump) {

    # lets dump what we found - to see if we got anything at all
    dump_journals(%journals);
    exit(0);
}

# we need to now open the journals - they want some real stuff
open_journals(%journals);

# define a variable to get some results into
my %subset_articles;

if ($review) {
  %subset_articles = get_articles_for_review(@review_days)
	}

if ($rd) {

    # would like to review the day
    my $yesterday = DateTime->now->subtract( days => 1 );
    %subset_articles = get_articles_until_now_starting_from($yesterday);

}

if ($rw) {

    # we would like to review a whole weeks stuff
    my $last_week = DateTime->now->subtract( weeks => 1 );
    %subset_articles = get_articles_until_now_starting_from($last_week);

}

if ($rf) {

    # we would like to review a whole weeks stuff
    my $fortnight_ago = DateTime->now->subtract( weeks => 2 );
    %subset_articles = get_articles_until_now_starting_from($fortnight_ago);

}

if ($rm) {

    # would like to review a whole  month - normal at month end
    my $last_month = DateTime->now->subtract( months => 1 );
    %subset_articles = get_articles_until_now_starting_from($last_month);

}

if ($rq) {

    # My God - They want to review a whole quarter at once
    my $last_quarter = DateTime->now->subtract( months => 3 );
    %subset_articles = get_articles_until_now_starting_from($last_quarter);

}

if ($rh) {

    # 6 months ago - a bit long ago
    my $half_a_year_ago = DateTime->now->subtract( months => 6 );
    %subset_articles = get_articles_until_now_starting_from($half_a_year_ago);

}

if ($ry) {

    # My God - They want to review a whole quarter at once
    my $a_year_ago = DateTime->now->subtract( years => 1 );
    %subset_articles = get_articles_until_now_starting_from($a_year_ago);

}

if ($search) {

    # search all the articles for the search string
    %subset_articles = search_articles($search);
}

# lets get a subset of those articles
# my %subset_articles = get_articles_by_date_range( 2008, 10, 1, 2008, 10, 26 );

# now lets print out the content - if there is any
if (%subset_articles) {
    journal_render( \$content, %subset_articles );
    editor_view($content);
}

exit 0;

sub search_articles {
    my ($searched) = @_;

# cycle through all articles searching and if there is a match, push onto return stack
    my %results;
    my $string;
    my $option = 'i';

    foreach my $lkey ( keys(%all_journal_conent) ) {

        my $entry_ref = $all_journal_conent{$lkey};

        # clear the string
        undef($string);

        # add the title, if there is one - we should search this too for now
        if ( (@$entry_ref)[3] ) {
            $string .= (@$entry_ref)[3];
        }

        my $entry = (@$entry_ref)[4];
        foreach my $line (@$entry) {
            $string .= $line;
        }

        if ($string) {
            if ( $string =~ m/$searched/i ) {

                # copy it across to the result set
                $results{$lkey} = $all_journal_conent{$lkey};
            }

        }

    }

    # return the results
    %results;

}

### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub editor_view {
    my ($buff) = @_;

    my $filepath = "c:\\temp\\temp-journal-out.txt";

    open F, ">$filepath";
    print F "$buff\n";
    close F;

    system("ed $filepath");

}

### INTERFACE SUB ###
# Usage     : ???
# Purpose   : make backup copies of all the journals in the passed hash
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub backup_journals {
    my (%j) = @_;

    foreach my $journal ( sort keys(%j) ) {
        backup_journal( $journal, $j{$journal} );
    }

}

### INTERFACE SUB/INTERNAL UTILITY/CLASS METHOD/INSTANCE METHOD ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub backup_journal {
    my ( $journal, $journal_filepath ) = @_;

    # work out name of directory for the backup file
    my ( $volume, $directories, $file ) =
      File::Spec->splitpath($journal_filepath);
    my $backup_path = $volume . $directories . $journal_bakcup_dir;

    # create the backup target filename
    my $dt = DateTime->now( time_zone => '+0100' );
    my $backup_filename = $journal . '-' . $dt->ymd . '.bkup.txt';

    # check the backup directory exists - create it if not
    if ( !-d $backup_path ) {
        print "bakcup dir: $backup_path does not exist - creating\n";
        mkdir($backup_path);
    }

    # backup the file - to journals '_backups' directory
    print "backing up: $journal ($journal_filepath) -> $backup_filename\n";
    copy( $journal_filepath, $backup_path . '\\' . $backup_filename );

    # make the 'current' backup  - in same directory as journal
    copy( $journal_filepath, $journal_filepath . '.bkup' );

    # and make a further backup to c:\temp
    copy( $journal_filepath, 'c:\\temp' );

    # and finally a copy to the QS Backup directory in the EO
    copy( $journal_filepath, $journal_QS_backup_dir );

}

### INTERFACE SUB ###
# Usage     : dump_journals(%master_journal_list_hash)
# Purpose   : Quick and dirty dump of the journal list
# Returns   : nothing
# Parameters: master journal list hash
# Comments  : none
# See Also  : n/a
sub dump_journals {
    my (%j) = @_;

    print "\n";

    # print a nice header
    printf( "%-3s %-12s    %-50s\n", "Jid", "Journal", "Full Journal Path" );
    printf( "%-3s %-12s    %-50s\n", "---", "-------", "-----------------" );

    my $Jid = 0;

    # now lets list the journals we have found
    foreach my $journal ( sort keys(%j) ) {

        printf( "%-0.2d  %-12s -> %50s\n", ++$Jid, $journal, $j{$journal} );
    }

    return;
}

### INTERFACE SUB/INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub find_journals {
    my ($journal_ref) = @_;

    # ??? - move to qs_enum_EOs() library to enumerate EOs on a machine
    # ??? - enumerate out of database
    my $root = $ENV{'Q_PATH_ROOT'} . '\\EO';

    # lets find all the EO's in the $root directory
    foreach my $path_found ( glob( $root . '\\*' ) ) {

        # test if this is a directory
        if ( -d $path_found ) {

        # now get the last directory component of this path string using a regex
            $path_found =~ m/.\\(\w*)$/g;

            # save the possible EO, and upper-case it too
            my $possible_EO = "\U$1";

            # now test if there is a journal for this EO
            my $journal_path =
              $path_found . $journal_relative_path . $possible_EO . '.txt';

            if ( -e $journal_path ) {

                # found journal so let's add it to hash ref list
                # $possible_EO is a real EO Journal
                $journal_ref->{$possible_EO} = $journal_path;

            }

        }
    }

    # now lets do the same for all the PERSONAS that are on this host - if any:
    # my $root = $ENV{'Q_PATH_ROOT'} . '\\PERSONA';
    $root = $ENV{'Q_PATH_ROOT'} . '\\PERSONA';

    # lets find all the EO's in the $root directory
    foreach my $path_found ( glob( $root . '\\*' ) ) {

        # test if this is a directory
        if ( -d $path_found ) {

        # now get the last directory component of this path string using a regex
            $path_found =~ m/.\\(\w*)$/g;

            # save the possible EO, and upper-case it too
            my $possible_EO = "\U$1";

            # now test if there is a journal for this EO
            my $journal_path =
              $path_found . $journal_relative_path . $possible_EO . '.txt';

            if ( -e $journal_path ) {

                # found journal so let's add it to hash ref list
                # $possible_EO is a real EO Journal
                $journal_ref->{$possible_EO} = $journal_path;

            }

        }
    }

}

### INTERFACE SUB/INTERNAL UTILITY/CLASS METHOD/INSTANCE METHOD ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub open_journals {
    my (%j) = @_;

    foreach my $journal ( sort keys(%j) ) {

        #open up the journal
        open_journal( $journal, $j{$journal} );
    }

}

# note - the journal must already be in standard format!
# ie yyyy-mm-dd hh:mm -e.g. 2006-06-26 16:04 gs46
# for this stuff to work
sub open_journal {
    my ( $journal_name, $journal_filepath ) = @_;

    my $TimeStamp;
    my $LocationString;
    my $Title;
    my @BodyText     = "";
    my $num_articles = 0;

    open( F, $journal_filepath );

    while (<F>) {

        # tidy-up - Force the date and time to the correct format
        $_ = enforce_dateformat($_);

# is this a new journal entry? - It is if we have a valid ISO datetime stamp at the start of the line
        if (/^(\d+-\d+-\d+ \d+:\d+)(.*)$/) {

            # we have found a new journal entry

            # close the last entry
            if ( $num_articles > 0 ) {

# except if this is the very first entry in journal (there would be no previous entry)
                ($LocationString) = trim($LocationString);
                add_journal_entry( $journal_name, $TimeStamp, $LocationString,
                    @BodyText );
                @BodyText = ();

            }

            # New Article
            $num_articles++;
            $TimeStamp      = $1;
            $LocationString = $2;

            # print "found entry:$TimeStamp, location $LocationString\n";

        }
        else {

            # line belonging to an existing article
            push( @BodyText, $_ );

        }

    }

    # do the last journal entry - or we will be missing one
    add_journal_entry( $journal_name, $TimeStamp, $LocationString, @BodyText );
    @BodyText = ();

    # close the file - we are done with it
    close F;

    # return the number of articles found
    $num_articles;
}

sub add_journal_entry {
    my ( $journal, $datetime, $location, @text ) = @_;

    my @temp;

    # get the titel of the article
    my $title = $text[0];
    for ( my $i = 1 ; $i < @text ; $i++ ) {
        push( @temp, $text[$i] );
    }
    @text = @temp;

    #convert the time to a serial number  - for sorting and working
    my ( $year, $month, $day, $hour, $minute ) =
      ( $datetime =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+)/ );

    # sanity check on the date paramters to catch errors in the journals
    # ??? - we need more checks here on all datetime components
    if ( ( $year < 2005 ) || ( $year > 2015 ) ) {
        die
"ERROR: Invalid date in journal: $journal\nDate:$datetime\nlocation:$location\nEntry:@text";
    }

    # convert the date & time into a serial number
    # my $serial = timelocal( 0, $minute, $hour, $day, $month, $year );
    # create a new DateTime object
    my $dt = DateTime->new(
        year       => $year,
        month      => $month,
        day        => $day,
        hour       => $hour,
        minute     => $minute,
        second     => 0,
        nanosecond => 500000000,
        time_zone  => '+0200',
    );

    my $serial = $dt->epoch;

# debug and checking only - convert it back again just to check
# my $str = localtime($serial);
# print "$year, $month, $day, $hour, $minute  - EPOCH seconds $serial - and string $str\n";

    # add to the master Articles entry - tidy up data a little
    if ( $location eq "" ) { $location = 'none'; }

    # if we have a title string - chomp it
    if ($title) { chomp($title); }

# create a so called 'Anonymous array constructor' - yet another use of Perl square brackets
# - thus we do not need to create a temporary array variable
    $all_journal_conent{$serial} =
      [ $journal, $datetime, $location, $title, \@text ];

}

sub get_articles_for_review
{
my (@days)=@_;

my %articles;

    print "we are reviewing the following days: @days\n";

    foreach my $day (@days) {

        # 24 hour period from that date range
        my $start_date = DateTime->now->subtract( days => $day );
        my $end_date = DateTime->now->subtract( days => ($day - 1));

        print "start date:", $start_date->ymd, " - end date:", $end_date->ymd, "\n";
               
        my %new_articles = get_articles_by_range(  $start_date, $end_date );

        %articles = (%articles, %new_articles);

    	}

    %articles;
}



sub get_articles_until_now_starting_from {
    my ($start_date) = @_;

    # end date is now
    my $end_date = DateTime->now();

    # get the articles and pass them back
    return get_articles_by_range( $start_date, $end_date );

}

sub get_articles_by_range {
    my ( $start_date, $end_date ) = @_;

    my %results;

    foreach my $lkey ( keys(%all_journal_conent) ) {

        if ( ( $lkey >= $start_date->epoch ) && ( $lkey <= $end_date->epoch ) )
        {

            # copy it across to the result set
            $results{$lkey} = $all_journal_conent{$lkey};
        }
    }

    # return the results
    %results;
}

sub get_articles_by_date_range {
    my ( $start_year, $start_month, $start_day, $end_year, $end_month,
        $end_day ) = @_;

    my %results;

    # calculate the start datetime serial
    my $dt_start = DateTime->new(
        year       => $start_year,
        month      => $start_month,
        day        => $start_day,
        hour       => 0,
        minute     => 0,
        second     => 0,
        nanosecond => 500000000,
        time_zone  => '+0200',
    );
    my $start_serial = $dt_start->epoch;

    # calcluate the end datetime serial
    my $dt_end = DateTime->new(
        year       => $end_year,
        month      => $end_month,
        day        => $end_day,
        hour       => 0,
        minute     => 0,
        second     => 0,
        nanosecond => 500000000,
        time_zone  => '+0200',
    );
    my $end_serial = $dt_end->epoch;

    foreach my $lkey ( keys(%all_journal_conent) ) {

        if ( ( $lkey >= $start_serial ) && ( $lkey <= $end_serial ) ) {

            # copy it across to the result set
            $results{$lkey} = $all_journal_conent{$lkey};
        }
    }

    # return the results
    %results;
}

sub trim {
    my @out = @_;
    for (@out) {
        s/^\s+//;
        s/\s+$//;
    }
    return wantarray ? @out : $out[0];
}

### INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : Converts a date like '2007-10-14 11:07' into 'Monday 14th July 2007'
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a
sub journal_format_datestr {
    my ($datestr) = @_;

    # break-it down datetime string with a regex
    my ( $year, $month, $day, $hour, $minute ) =
      ( $datestr =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+)/ );

    # create a new DateTime object
    my $dt = DateTime->new(
        year       => $year,
        month      => $month,
        day        => $day,
        hour       => $hour,
        minute     => $minute,
        second     => 0,
        nanosecond => 500000000,
        time_zone  => '+0200',
    );

    # construct long date time string
    my $return_datestr =
      $dt->day_name . " " . $day . " " . $dt->month_name . " " . $year;

    # return the newly formed string
    return $return_datestr;

}

### INTERFACE SUB ###
# Usage     : journal_render(\$content, %subset_articles)
# Purpose   : convert the passed articles into a rendered format ready for printing
# Returns   : nothing
# Parameters: \$content - refernce to scalar storrage, %subset_articles - hash of articles
# Comments  : none
# See Also  : journal_render_contents(), journal_render_articles
sub journal_render {
    my ( $rendered_ref, %journal_articles ) = @_;

    # generate the table of contents first ...
    journal_render_contents( $rendered_ref, %subset_articles );

    # ... and print the main articles page
    journal_render_articles( $rendered_ref, %subset_articles );

    return;
}

sub journal_render_contents {
    my ( $rendered_ref, %my_articles ) = @_;

    my $count = 1;

    $$rendered_ref .= "  TABLE OF CONTENTS\n";
    $$rendered_ref .= "  -----------------\n";
    foreach my $key ( sort keys(%my_articles) ) {

        # derefence the array
        my $article_ref = $my_articles{$key};

        # -= [ $journal, $datetime, $location, $title, \@text];

        $$rendered_ref .= sprintf(
            " %0.3d %-46.46s (%-11.11s) - %s\n",
            $count++,         @$article_ref[3], @$article_ref[0] . '/' . @$article_ref[2], 
          @$article_ref[1]
        );
    }

    $$rendered_ref .= "\n";
}

sub journal_render_articles {
    my ( $rendered_ref, %my_articles ) = @_;

    my $datestr = "";

    foreach my $key ( sort keys(%my_articles) ) {

        # get a reference to the array
        my $ref = $my_articles{$key};

# $all_journal_conent{$serial} = [ $journal, $datetime, $location, $title, \@text];
#get the date of this new article
        if ( $datestr ne ( my $check_date = journal_format_datestr( @$ref[1] ) )
          )
        {
            $datestr = $check_date;
            $$rendered_ref .=
"[------------------------- $datestr ----------------------------]\n";
        }

        # print out like time, journal, location, title
        my $dt = DateTime->from_epoch( epoch => $key, time_zone => '+0200', );
        my $time = $dt->hms;

        $$rendered_ref .= "\n$time [@$ref[0]\] @$ref[2] - @$ref[3]\n";
        $$rendered_ref .= "--------\n";

        # print the article
        my $buff = @$ref[4];
        foreach my $line (@$buff) {
            $$rendered_ref .= $line;
        }

    }

}

### INTERNAL UTILITY ###
# Usage     : ???
# Purpose   : ???
# Returns   : ???
# Parameters: ???
# Comments  : none
# See Also  : n/a

sub enforce_dateformat {
    my ($input_line) = @_;

    # print "checking $input_line\n";

    # transform type 1 dates - notepad format
    # hh.mm dd.mm.yyyy
    if ( $input_line =~ /^(\d\d):(\d\d) (\d\d)\.(\d\d)\.(\d\d\d\d)(.*)/ ) {
        $input_line = "$5-$4-$3 $1:$2$6\n";
    }

# transform type 2 dates - EditPlus default format - This is much better than the notepad effort
# hh.mm yyyy-mm-dd
    if ( $input_line =~ /^(\d\d):(\d\d) (\d\d\d\d)\-(\d\d)\-(\d\d)(.*)/ ) {
        $input_line = "$3-$4-$5 $1:$2$6\n";
    }

    # type 3
    #  hh:mm dd/mm/yyyy - example - 15:33 20/03/2007
    # this is a hack! should be rewritten, but who has the time?
    if ( $input_line =~ /^(\d\d):(\d\d) (\d\d)\/(\d\d)\/(\d\d\d\d)(.*)/ ) {
        $input_line = "$5-$4-$3 $1:$2$6\n";
    }

    # print "$input_line";

    # return the value - if altered
    $input_line;

}

sub help_journal {
    my ($v) = @_;

    print <<"END_OF_HELP";

Journal Review options
    -rd     review day
    -rw     review week
    -rf     review fortnight (2 weeks)
    -rm     review month
    -rq     review quarter
    -rh     review half year
    -ry     review last year

  note: That all these ranges start from today.

Search Options
    -s  search articles for strings
    -sr Regex search of articles for items

Filter Options
    -location   only items from comma seperated list of locations
    -include    include this comma seperated list of explicit journals
    -exclude    exclude this comma seperated list of journals
    -history    include all history files (*2005, *2006, etc), or a SCL of years

Journal Management
    -backup     backup the journals
    -map        map location x with location y
    -copy       copy journals to specific location
    -help       give help on the journal system
    -dump       dump the list of journals found, and control information

END_OF_HELP

}

__END__


    # create a so called 'Anonymous array constructor' - yet another use of Perl square brackets
    # - thus we do not need to create a temporary array variable
    $journals{$serial} = [ $journal, $datetime, $location, $title, @text];

    Anonymous array constructor - The square brackets here are very useful for making an anonymous array, without having to resort to temporary variable just to instantiate the 
    object beingc created.
    We now have a hash item entry that has an EPOCH seconds as the key, and the array as the value, we can thus sort by the key to order them in correct time, and then have
    the value to contain all the data that we need for article.

    This does not work, because the @text array put into another list or array will merely 'flatten-out' and just add a variable number of elements to the list. 
    This is not what we want - Thus we have two options: 1, insert a reference to the array in the list and then dereffernce that latter, or create a hash, and add 
    a hash as the value to the master 'journals' has. This would give the added benefit that one could also use 'tags' for the item names instead of cryptic array indexed. 
    It would make the program a little more complex, but would probably be better in the long run

    $journals{$serial} = [ $journal, $datetime, $location, $title, \@text];
    Here is version one - With a reference to a Perl hash array - That means we now only have exactly 5 items in the list, and the last one is a list reference.
    And latter in the calling program, we can access it and dereference the array as such:
      my $buff = @$ref[4];
      print @$buff;
    And you have all your text back! Marvellous - Perl is just great!



    __END__
    This is a useful construct for Perl programs that allows one to add, embed, or just arse about with the soure code file. Very useful for keeping notes etc.

    if (/^(\d+-\d+-\d+ \d+:\d+) (.*)$/) {
      regex was not finding all occurences: Because there are currently plenty without a space at the end ( the original style)
    returned counts:
      We have found: 68 in journal_file1
      We have found: 66 in journal_file1
      We have found: 58 in journal_file3
    Changed regular exe expression to:
               if (/^(\d+-\d+-\d+ \d+:\d+)(.*)$/) {
    Artricle count now increases:
      We have found: 100 in journal_file1
      We have found: 88 in journal_file1
      We have found: 131 in journal_file3
    Added a new pre-filter to check all the dates before processing and tidied up a few more stragglers, now we have a few more
      We have found: 101 in D:\QS\BusRoot\QUESTOR\DATA\DOCS\documentation\Journals\Questor.txt
      We have found: 89 in D:\QS\BusRoot\FJB\DATA\DOCS\documentation\Journals\fjb.txt
      We have found: 139 in D:\QS\BusRoot\BalaFund\DATA\DOCS\documentation\Journals\BalaFund.txt
