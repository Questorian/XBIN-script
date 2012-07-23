$version="1.0";
#------------------------------------------------------
# GenRDP.plx: Generate an XP RD file for each of the 
# systems found in the local systems.cfg file
#
# created:   Fri Aug  2 19:19:41 2002
# Author:    Farley Balasuriya
# Revision:	
#            02/07/02 - v1.0 created
#-------------------------------------------------------
# Questor Systems GmbH, Schweiz. Copyright(C), 1997-2002
#    http://www.questor.ch
#    mailto:info@questor.ch
#-------------------------------------------------------

#modules
#-------
#use Net::Ping;
#use Win32::ODBC;
#use GPSnotify;
use Getopt::Std;

#variables
#---------

# format NETBIOS: FQDB: P/S: Site Code: Site Name: Services: ...
# e.g.
# 0          1          2 3   4                  5   6   7
# USARSMSS3S:USARSMSS3S:P:S3S:Syngenta Root Site:SMS:SQL:IIS

# 0          1          2    3    4   5                        6              7                      8                 9    10  11 
# CHBSSMSCH0;CHBSSMSCH0;EAME;SMSP;CH0;Switzerland Country Site;2.00.1493.3010;E:\SMS;168.246.161.123;00:02:A5:3F:96:2A;SMSP;SQL;IIS 

getopt('u');
my ($userid, $domain, $fname);
$userid = "balasfa1-adm";
$domain = "NAFTA";
$fname = "\\\\CHBSSMSCH0\\SMSTools\$\\SMS\\SMSServers.cfg";

if (defined $Getopt::Std::opt_u){
	$userid = uc $Getopt::Std::opt_u;
} else {
	print "Must specify Actual useraccount using -u";
}

open(IN,$fname);
@buff=<IN>;
foreach $line (@buff){
	# print "found: $line";
	(@b) = split (';',$line);
	if ($b[4] eq "S3S"){ $b[4] = "_S3S"; }
	$fname = $b[4]." (".($b[3])[3].") - ".$b[5].".RDP";
	CreateRDPFile($fname,$b[1]);
	}

sub CreateRDPFile()
{
my ($newfile, $fqdn)=@_;

print "\ncreating RDP file: $newfile";
open(OUT, ">>".$newfile);

print OUT <<EOF
screen mode id:i:2
desktopwidth:i:1280
desktopheight:i:1024
session bpp:i:24
winposstr:s:0,1,0,0,800,600
auto connect:i:0
full address:s:$fqdn
compression:i:1
keyboardhook:i:2
audiomode:i:0
redirectdrives:i:0
redirectprinters:i:1
redirectcomports:i:0
redirectsmartcards:i:1
displayconnectionbar:i:1
username:s:$userid
domain:s:$domain
alternate shell:s:
shell working directory:s:
disable wallpaper:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
bitmapcachepersistenable:i:1



EOF
;
close(OUT);


}
