@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: ff.cmd: startup the portable firefox  program from the bin directory
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Mon Apr 25 01:30:10 2005
:: History:
::		v0.2 - 
::		v0.1 - 25/04/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 110 $
set svn_id=$Id: ff.cmd 110 2005-04-25 02:40:51Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
::-----------------------------------------------------------------

:QSCDEInit
if not %QS_Init%.==1. call QSCDE

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

:SETS
set ff_ver=portable_firefox_1.0.4_rc2

:START
%QS_DRV_Bin%\%ff_ver%\PortableFirefox\PortableFirefox.exe %*
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo startup the portable firefox  program from the bin directory
goto END

:VERSION
echo filename: %0
echo $Id: ff.cmd 110 2005-04-25 02:40:51Z farley $
echo $Rev: 110 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END