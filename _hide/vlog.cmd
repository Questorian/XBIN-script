@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: vlog.cmd: View logs from the QSCDE environment
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Sun May  8 10:34:11 2005
:: History:
::		v0.2 - 
::		v0.1 - 08/05/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
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
if  %1.==. goto USAGE

:SETS
set viewer=tail -100 
if %1.==-e set viewer=ed -r & shift


:START
::rem first we check the local logs
if exist %QS_PATH_LLog%\%1.log call %viewer% %QS_PATH_LLog%\%1.log
if exist %QS_SHR_GLog%\%1.log call %viewer% %QS_SHR_GLog%\%1.log 
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo View logs from the QSCDE environment
echo --Local logs---
dir %QS_PATH_LLog% /b
echo --Global logs---
dir %QS_SHR_GLog% /b
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