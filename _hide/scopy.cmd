@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: scopy.cmd: Secure-Copy, copies a file and does a few checks on it for you
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Wed May 18 18:59:08 2005
:: History:
::		v0.2 - 
::		v0.1 - 18/05/05 - initial version created
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
:: if  %1.==. goto USAGE

:SETS

:START
if not exist %2 goto ERR1
if exist %2\%1 goto ERR2
copy /v %1 %2
dir %2\%1
rem windiff %1 %2\%1
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Secure-Copy, copies a file and does a few checks on it for you
goto END

:VERSION
echo filename: %0
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: target %2 does not exist
goto END

:ERR2
echo %0: Err2: target already exists. Please check and delete manually and then try again.
goto END

:END