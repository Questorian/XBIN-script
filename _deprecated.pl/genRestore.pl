##############################################################
# purpose: generate a SQL restore script from directory full of 
#  SQL dump files
# created: 2006-11-03 19:27
#
# Farley Balasuriya  - farley@questor.ch
#
##############################################################

use strict;
use warnings;
use Cwd;

my $default_extension = ".sql.bak";
my $cwd = getdcwd();

my @dumps = glob("*" . $default_extension );
foreach my $file (@dumps) {
  $file =~ /(.*)_backup_/m;
  my $db = $1;
  print "restore database [$db] from disk = '$cwd" . "\\$file'\ngo\n";
	}

