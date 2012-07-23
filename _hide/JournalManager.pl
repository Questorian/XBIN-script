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

my $file = 'C:\\temp\\Questor-test.txt';
my $count = 0;
my ($datetime, $title, $body);
my %articles;


open J, $file;
while (my $line = <J>) {

  # print "$line";

  # <start-of-line>YYYY-MM-DD HH:MM
  # the start of an article pattern
  if ($line =~ m/^(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)(.*)/) {
    
     # we found the start of an article
     $datetime = $line;
     
     # save off the current aricle - before starting next
     if ($count ++ > 0) {
       # we need to ensure that this is not the very first article

       # square brackets - anonymous arrays - really useful here
       $articles{$datetime} = [$title, $body];
       undef ($title);
       $body = "";
     	}

     # increment the number of articles that we have found
     


    }

    # we are in the body of the text of the article
    if (! defined $title ) {
      $title = $line;
    	}
    else {
      $body = $body . $line;
    }




}

print "Total Articles: $count\n";
print "now we print out the titles:\n";
foreach (my $key = keys  (%articles)) {
  print "$key:\n";
	}