@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: PathPrint.cmd: Print out the PATH environment variable and 
:: optionally search each of these directories for a given file name
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Thu May 19 18:07:53 2005
:: History:
::		v0.2 - 
::		v0.1 - 19/05/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
::-----------------------------------------------------------------


set FILE_TYPES=exe com pl plx pm cmd bat sql vbs js py inf dll

:ARGS
if  %1.==-h. goto USAGE
if  %1.==-H. goto USAGE
if  %1.==-?. goto USAGE
if  %1.==--help. goto USAGE
if  %1.==--HELP. goto USAGE
if  %1.==-v goto VERSION
if  %1.==-V goto VERSION
if  %1.==--version goto VERSION
if  %1.==--VERSION goto VERSION
:: if  %1.==. goto USAGE

:SETS
:: types of file that we want to search for along the path
:: list them here


:START
echo PATH=
perl  -e "$i=0; foreach $var (split(/;/,$ENV{\"PATH\"})){" -e "printf \"\L%%2d) $var\n\",$i++;}" | more
if %1.==. goto END
echo --------- %1 --------------
rem perl -e "$i=0;@found;@exts=qw(%FILE_TYPES%);" -e "foreach $var (split(/;/,$ENV{\"PATH\"})){" -e "foreach (@exts){ if (-e \"$var\\%1.$_\"){ push(@found,\"$var\\%1.$_\");}}}" -e "if(@found){ print join(\"\n\",@found)}"
perl -e "$i=0;@found;@exts=qw(%FILE_TYPES%);$path=$ENV{\"PATH\"}.\";.\";" -e "foreach $var (split(/;/,$path)){" -e "foreach (@exts){ if (-e \"$var\\%1.$_\"){ push(@found,\"$var\\%1.$_\");}}}" -e "if(@found){ print join(\"\n\",@found)}"
echo.
echo --------- %1 --------------
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0  [filesspec]  [further extensions]
echo Description:
echo Print out the PATH environment variable and 
echo optionally walk each of these directories looking for a given 
echo basefile name, and with some preselected executable extensions.
echo.
echo By default we look for the following extensions:
echo %FILE_TYPES%
echo you can further extensions on the command line
echo.
goto END

:VERSION
echo filename: %0
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END
set FILE_TYPES=