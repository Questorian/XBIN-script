use strict;
use warnings;


# valid tags - lower case only
my @valid_tags =
  qw /task ipanema @work @home urgent project call email errand waiting-for joana wellness goal someday-maybe trip /;


foreach my $tag (@valid_tags) {
  print "$tag:\n\n";
	}