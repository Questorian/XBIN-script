@echo off
echo Configuring Perl to run on this node, %computername%. Please wait...

rem note: this will not change the real environment. Find a better way

assoc .plx=Perl
assoc .pl=Perl
assoc .pm=Perl
assoc .t=Perl
ftype Perl="%Q_DRV_XBin%\Perl\bin\perl.exe" "%%1" %%*
perl -e "use Time::Piece;$t=localtime;print $t->datetime, \" - Perl installation is complete: \@INC=\", join(';',@INC);"

rem NOTE: fix the PPM thing. Does not work like this!
echo Now set these variables in the registry:
echo set PATHEXT=%PATHEXT%;.PL;.PLX;.PM;.T
echo set PERL5LIB