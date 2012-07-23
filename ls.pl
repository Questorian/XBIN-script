#
#-----------------------------------------------------------------
# Alcatel - Alcatel-Lucent(Schweiz)AG, Friesenberg Strasse 75
#-----------------------------------------------------------------
#
# v:\scripts\ls.pl: List with the full path all the files in a directory. Used mainly for cutting and pasting
#
# Project:
# Author:	Farley Balasuriya,  (fbalasur@AD5.AD.ALCATEL.COM)
# Created:	Mon Feb 26 23:09:35 2007
# History:
#		v0.2 -
#		v0.1 - 26/02/07 - initial version created
#
#-----------------------------------------------------------------
$svn_rev = '$Rev: 110 $';
$svn_id  = '$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate =
  '$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';

#-----------------------------------------------------------------
#-----------------------------------------------------------------
use Cwd;
use File::Spec;

my $dirname = getcwd;

opendir( DIR, $dirname ) or die "can't opendir $dirname: $!";
while ( defined( $file = readdir(DIR) ) ) {

    # do something with "$dirname/$file"
    if ( $file != /^\.*/) {
    print File::Spec->canonpath("$dirname\\$file"), "\n";
    	}

}
closedir(DIR);
