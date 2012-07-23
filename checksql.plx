#------------------------------------------------------
# checksql.plx: Check that daily maintenance on EUPSMS servers has run
#
# version:   1.0
# created:   Fri Nov 17 15:03:40 2000
# Author:    Farley Balasuriya, UBS AG, Basel, Schweiz
# Revision:	
#            1.0 - script created
#------------------------------------------------------
#------------------------------------------------------

$myret = smsCheckIndxRebuild();

print "\n the return value is:$myret";


sub smsCheckIndxRebuild()
#return values
# 0 - All is ok
# 1 - The report has not run today
# 2 - The report did run today but failed
{
my ($status, $datelr, $ret, $date);
$ret=0;

@date=`isql -S s01aaakw -P"" -d MSDB -Q "select lastruncompletionlevel, lastrundate  from systasks where name = 'SMS
 Daily Automated Maintenance'"`;

($status, $datelr) = split (' ', $date[2]);

#first we check the date is todays. Make a string fortoday, SQL example: - 20001117
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year+=1900;
$mon+=1;
$todaystr = $year.$mon.$mday;

# print "\nstatus: $status\nlast run: $datelr\ntodaystr=$todaystr";

if ($todaystr ne $datelr){
	$ret=1;
	}

if ($status != 1){
	$ret=2;
	}

$ret;
}