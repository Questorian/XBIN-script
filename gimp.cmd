@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: gimp.cmd: Start up the gimp application. "Bring-out the gimp!"
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Mon Apr 25 14:31:22 2005
:: History:
::		v0.2 - 
::		v0.1 - 25/04/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: gimp.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
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

:START
set PATH=%PATH%;%QS_DRV_Bin%\lib\GTK\bin;%QS_DRV_Bin%\GIMP-2.2.6\bin
%QS_DRV_Bin%\GIMP-2.2.6\bin\gimp-2.2.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Start up the gimp application. "Bring-out the gimp!"
goto END

:VERSION
echo filename: %0
echo $Id: gimp.cmd 114 2005-04-25 13:59:09Z farley $
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