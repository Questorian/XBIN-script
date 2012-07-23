##############################################################
# purpose: GenDBRestore.pl - generate a DB backup restore script
#            from files in a directory
#
# created: 2007-01-22 21:59
#
# Farley Balasuriya  - farley@questor.ch
#
##############################################################

use strict;
use warnings;
use Cwd;
use File::Spec;

# our default extensions
my $ext_db_bkup = "*.sql.bak";
my $ext_log_bkup = "*.sql.trn";


my $db_name = $ARGV[0];
my $dir = getcwd();
my $date = localtime;

# get the database, and log filename from the directory
my @in_buff = glob($ext_db_bkup);
push @in_buff, glob($ext_log_bkup);
# sort them to get the correct restore order of log files
my @buff = sort @in_buff;


print <<EOF
/*
 * Farley Balasuriya (farley\@questor.ch)
 * created: $date
 *
 * script to restore database: $db_name
 */

-- switch to master database
USE [master];
GO

-- Longtail: Attempt to backup the longtail
--           This may or may not matter depending on which database
--           In any case this will fail on SIMPLE recovery model databaes
backup log $db_name
    to disk = 'c:\\temp\\$db_name-longtail.sql.trn'
    with norecovery
GO
EOF
  ;

foreach (@buff){
	chomp();
	if (/\.bak/i) {print_statement('database', $_);}
	else{
		print_statement('log', $_);
		}
	}

print "\n-- Please check this restore script carefully before execution";
print "\n-- check if you want the NORECOVERY, STOPAT, POINT, etc options";
print "\n-- check also the log files are listed in the correct sequence!\n\n";


print "\n-- Remember to backup long-tail of current transaction log";
print "\n-- if required, before starting the backup !!";
print "\n-- Use BACKUP LOG ... WITH NORECOVERY to backup the log if it ";
print "\n-- contains work you do not want to lose";


sub print_statement()
{
my ($type, $file) = @_;

	my $path = File::Spec->catfile($dir, $file);
	print "\nRestore $type $db_name\n\tfrom disk = '$path'";
	print "\n\twith STATS, NORECOVERY;\nGO\n\n\n";

}
