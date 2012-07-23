##############################################################
# purpose: Tidy-up the FJB Journal files - used as stream filter
# created: 2006-09-09 12:18
# usage (as stream filter): perl -n JournalTidy.pl jrn_file.txt
#
# Farley Balasuriya  - farley@questor.ch
#
##############################################################

use strict;
use warnings;

my ($input);

$input = $_;

# transform type 1 dates - notepad format
# hh.mm dd.mm.yyyy
if (/^(\d\d):(\d\d) (\d\d)\.(\d\d)\.(\d\d\d\d)(.*)/) {
    $input = "$5-$4-$3 $1:$2$6\n";
}

# transform type 2 dates - EditPlus default format - This is much better than the notepad effort
# hh:mm yyyy-mm-dd
if (/^(\d\d):(\d\d) (\d\d\d\d)\-(\d\d)\-(\d\d)(.*)/) {
    $input = "$3-$4-$5 $1:$2$6\n";
}



# transform type 2 dates - EditPlus default format - This is much better than the notepad effort
# hh:mm:ss yyyy-mm-dd
if (/^(\d\d):(\d\d):(\d\d) (\d\d\d\d)\-(\d\d)\-(\d\d)(.*)/) {
    $input = "$4-$5-$6 $1:$2:$3\n";
}


# type 3
#  hh:mm dd/mm/yyyy - example - 15:33 20/03/2007
# this is a hack! should be rewritten, but who has the time?
if (/^(\d\d):(\d\d) (\d\d)\/(\d\d)\/(\d\d\d\d)(.*)/) {
    $input = "$5-$4-$3 $1:$2$6\n";
}


# type 4
# hh:mm AM yyyy-mm-dd
# this is really crap!
# if (/^(\d\d):(\d\d) AM (\d\d\d\d)\-(\d\d)\-(\d\d)(.*)/) {
#     $input = "$3-$4-$5 $1:$2:00\n";
# }



print "$input";
