#!/usr/bin/perl
#-----------------------------------------------------------------
# QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
#-----------------------------------------------------------------
#
# template.pl: Generate outline script ready for editing and load into default system editor
#
# Project:	
# Author:	Farley Balasuriya, (qs10001@QUESTOR.INTRA)
# Created:	Wed Apr 27 01:00:27 2005
# History:
#		v0.2 - 
#		v0.1 - 27/04/05 - initial version created
#            
#-----------------------------------------------------------------
$svn_rev='$Rev: 110 $';
$svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';
#-----------------------------------------------------------------
#-----------------------------------------------------------------
use Time::Piece;
use Text::Template;
use File::Basename;
use locale;

#Variables (mainly from QSCDE)
#-----------------------------
$version="0.1";
$me=@ENV{"QS_Ego"};
$sysid=@ENV{"USERNAME"}."@".@ENV{"USERDNSDOMAIN"};
$editor=@ENV{"QS_Editor"};
$t = localtime;
$templatedir=@ENV{"QS_DRV_Bin"}."\\_data\\templates";
#get a list of all the current templates as an aid
@templatelist= glob($templatedir."\\*.*");
$tmp_batch=$ENV{"TEMP"}."\\template_launch.cmd";

#check if we were called with filenames already
if(($#ARGV +1) == 2) {
	$fname = $ARGV[0];
	$tfile = $ARGV[1];
	chomp();
	}
else
	{	
	print "New scripts name (path\\to\\fname.ext): ";
	chomp($fname=<>);
	
	print "Which template to use?:\n";
	foreach $tname (@templatelist){
		($base, $dir, $ext) = fileparse($tname, '\..*');
		print "$base$ext, ";
		} print " :";
	chomp($tfile=<>);
	}

$template=$templatedir."\\".$tfile;
if (! -e $template){
	print "error: cannot find template file: $template";
	exit(1);
	}
	
if ( -e $fname ){
	print "error: file already exists. Rename and try again";
	exit(1);
	}
	
print "Description for new script: ";
chomp($description=<STDIN>);

#calculate the short date string
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$shortdate = sprintf("%02d/%02d/%02d", $mday, $mon+1, $year % 100);

#which company are we working for?
$persona=@ENV{"QS_Persona"};
$company=@ENV{"QS_Persona_Long"};

#create the other values
($base, $dir, $ext) = fileparse($fname, '\..*');
$envdir = $base."_DIR";
$envdir = uc($envdir);
$filename=$base.$ext;

$journal=$base."Journal.log";


#now we fill in the form
$templateo = new Text::Template (TYPE => FILE,  SOURCE => $template);
$text = $templateo->fill_in();  # fill it out man

#create the file and start editing
open(F,">".$fname);
print F $text;
close (F);

#create the callable CMD file to launch edititin
open(F, ">".$tmp_batch);
print F "\@start \%QS_EDITOR\% $fname";
close (F);

#$cmd="\"$editor\" $fname";
#system($cmd);