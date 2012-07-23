##############################################################
# purpose: generate a CREATE DATABASE script for one or more DB's on
# commmand  line with the standard QS features and settings
# created: 2006-09-26 23:19
#
# Farley Balasuriya  - Farley@QuestorSystems.com
#
# qstag: dba
##############################################################

use strict;
use warnings;
use Getopt::Long;

my ( $db, $dat_path, $log_path, $bkup_path, $bak_extension );
$dat_path = "C:\\Program Files\\Microsoft SQL Server\\MSSQL.1\\MSSQL\\Data";
$log_path = "C:\\Program Files\\Microsoft SQL Server\\MSSQL.1\\MSSQL\\Data";
$bak_extension = ".sql.bak";
$bkup_path = "D:\\QS\\PERSONA\\ALCATEL\\BKUP\\DBs\\DBMaint\\master";

# DEFAULTS
my $size_db  = 10;
my $size_log = 5;
my $recovery_model = "SIMPLE";
#IPTV versions
# my $dat_path  = "E:\\DB-DATA";
# my $log_path  = "L:\\DB-LOG";
# my $bkup_path = "F:\\DB-BKUP";


#these need to be canned in QS_stdlib.pm Perl lib, or we use the string time functions
my ( $day, $month, $year, $hours, $mins, $secs ) =
  ( localtime() )[ 3, 4, 5, 2, 1, 0 ];
$year  += 1900;
$month += 1;
my $date = sprintf( "%d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d",
    $year, $month, $day, $hours, $mins, $secs );
my $date_simple = $date;
$date_simple =~ s/[- :]//g;

# process the command line arguments
GetOptions(
    'dp=s' => \$dat_path,
    'ds=s' => \$size_db,
    'lp=s' => \$log_path,
    'ls=s' => \$size_log,
    'bp=s' => \$bkup_path,
    'r=s' => \$recovery_model
);

#print the file header
print <<EOF
/*
 * Purpose: Script to create database files
 * Author : Farley Balasuriya (Farley\@QuestorSystems.com)
 * created: $date
 */


-- switch to master database
USE [master];
backup database [master] to disk = '$bkup_path\\master-$date_simple-pre$bak_extension';
GO

EOF
  ;

#iterate for each DB name given on the command line
foreach $db (@ARGV) {
    print <<EOF

/*
 * Create Database: $db
 * ---------------
 */
IF DB_ID (N'$db') IS NOT NULL
 DROP DATABASE [$db];

create database [$db] on PRIMARY
(
 -- create the first data device
 NAME = N'${db}_D01',
 FILENAME = N'$dat_path\\${db}_D01.mdf',
 SIZE = ${size_db}MB,
 FILEGROWTH = 20%
)
LOG ON
(
 -- create the first log device
 NAME = N'${db}_L01',
 FILENAME = N'$log_path\\${db}_L01.ldf',
 SIZE = ${size_log}MB,
 FILEGROWTH = 20%
)
COLLATE Latin1_General_CI_AS;
GO

ALTER DATABASE [$db] 
    SET RECOVERY \U$recovery_model;
GO

-- Change the database ownership
-- EXEC $db..sp_changedbowner 'sa'
ALTER AUTHORIZATION ON DATABASE::[$db] to sa;
GO

EOF
      ;

}

#get another backup of master - after the new database(s) have been created
print <<EOF

/*
 * get backup of the new master database
 */

-- switch to master database
USE [master];
backup database [master] to disk = '$bkup_path\\master-$date_simple-post$bak_extension';
GO

EOF
  ;
