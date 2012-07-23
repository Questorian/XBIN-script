# backup files localy

use strict;
use Time::Piece;

my $target = "c:\\temp\\bkup";
my @bkup_list = qw {
  Q:\EO\BALAFUND\DATA\DOCS\documentation\journals\BalaFund.txt
  Q:\EO\FJB\DATA\DOCS\documentation\journals\FJB.txt
  Q:\EO\Ipanema\DATA\DOCS\documentation\journals\Ipanema.txt
  Q:\EO\Lavinia\DATA\DOCS\documentation\Journals\Lavinia.txt
  Q:\EO\QUESTOR\DATA\DOCS\documentation\Journals\Questor.txt
  bookmarks.htm*
  FileZilla.xm*
  *.psafe3
  *.plk
  *.pst
};

system("pushd %Q_DRV_ROOT%");
system("if not exist $target md $target");

my $now = localtime;
$target .= "\\bkup-" . $now->ymd;
system("if not exist $target md $target");

foreach my $spec (@bkup_list) {
  print "backing up: $spec\n";
  system("xcopy $spec $target /S /V /Y");
	}

#clean up properly
system("popd");
