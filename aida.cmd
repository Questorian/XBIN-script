rem @echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: aida.cmd: Call the Aida32 application from the BIN directory
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Mon Apr 25 00:49:05 2005
:: History:
::		v0.2 - 
::		v0.1 - 25/04/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 115 $
set svn_id=$Id: aida.cmd 115 2005-04-26 12:41:57Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-26 14:41:57 +0200 (Tue, 26 Apr 2005) $
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
%QS_DRV_Bin%\aida32pe_393\aida32
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Call the Aida32 application from the BIN directory
goto END

:VERSION
echo filename: %0
echo $Id: aida.cmd 115 2005-04-26 12:41:57Z farley $
echo $Rev: 115 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END