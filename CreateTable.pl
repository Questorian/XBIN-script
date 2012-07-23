#
#-----------------------------------------------------------------
# Alcatel - Alcatel-Lucent(Schweiz)AG, Friesenberg Strasse 75
#-----------------------------------------------------------------
#
# v:\scripts\CreateTable.pl: Create a SQL table template script
#
# Project:	
# Author:	Farley Balasuriya,  (fbalasur@AD5.AD.ALCATEL.COM)
# Created:	Sun Feb 25 00:38:20 2007
# History:
#		v0.2 - 
#		v0.1 - 25/02/07 - initial version created
#            
#-----------------------------------------------------------------
$svn_rev='$Rev: 110 $';
$svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';
#-----------------------------------------------------------------
#-----------------------------------------------------------------
use strict;
use warnings;
# use Getopt::Long;

my $table = $ARGV[0];

print <<EOF

/*
 * Create table: $table
 */
IF object_id('dbo.$table') is NOT NULL
  DROP TABLE [dbo].[$table]
CREATE TABLE [dbo].[$table]
(

    -- contstraints
)
go



EOF
;
