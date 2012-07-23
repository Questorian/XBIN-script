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

# get the database, and log filenames from the directory
my @in_buff = glob($ext_db_bkup);
push @in_buff, glob($ext_log_bkup);
# sort them to get the correct restore order of log files
my @buff = sort @in_buff;


print_header();

print_section_header("  2 - Restore Database and Logs");

#now for body of script
foreach (@buff){
	chomp();
	if (/\.bak/i) {print_statement('database', $_);}
	else{
		print_statement('log', $_);
		}
	}
print "\n--";
print "\n-- EOF: End of restore script for database: $db_name";
print "\n--";

sub print_header()
{

print <<EOF
/*
 * script:   restore-$db_name.sql
 * created:  $date
 * author:   Farley Balasuriya (farley\@questor.ch)
 *
 * script to restore database: $db_name
 */



-- Attention: Please check this restore script VERY carefully before execution!
-- check your restore options: NORECOVERY, STOPAT, POINT, etc options
-- check log files are listed in the correct sequence!

-- Remember to backup long-tail of current transaction log
-- if you need it, before starting the recovery !!
-- Use BACKUP LOG ... WITH NORECOVERY to backup the log if it
-- contains work you do not want to lose


-- master: switch context to master database
USE [master];
GO


-- Longtail: Attempt to backup the longtail
--           This may or may not matter depending on database config
--           In any case this will fail on SIMPLE recovery model databaes
backup log [$db_name]
    to disk = N'c:\\temp\\$db_name-longtail.sql.trn'
    with norecovery
GO


-- offline: Switch database off-line so that we can continue restore process unhindered
alter database [$db_name]
 set offline 
 with rollback immediate;
GO

EOF
  ;

}

sub print_section_header()
{
my ($section_header) = @_;

print <<EOF

/*
 * $section_header
 */

EOF
 ;
}


sub print_statement()
{
my ($type, $file) = @_;

	my $path = File::Spec->catfile($dir, $file);
	print "\nRestore $type [$db_name]\n\tfrom disk = N'$path'";
	print "\n\twith STATS, NORECOVERY;\nGO\n\n\n";

}
