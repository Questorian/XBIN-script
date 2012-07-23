@echo off

::-----------------------------------------------------------------
:: HP - Hewlett-Packard (Schweiz) GmbH, http://www.hp.com
::-----------------------------------------------------------------
::
:: GetAccToc.cmd: Get an admin user access token to server provided on the command line, using %QS_ACC_Admin_Dom%\%QS_ACC_Admin_Acc%
::
:: Project:	
:: Author:	Farley Balasuriya
::		(u213150@EAME.SYNGENTA.ORG)
:: Created:	Wed Jul 27 10:56:17 2005
:: History:
::		v0.2 - 
::		v0.1 - 27/07/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
::-----------------------------------------------------------------
::  ___                  _               ____            _
:: / _ \ _   _  ___  ___| |_ ___  _ __  / ___| _   _ ___| |_ ___ _ __ ___  ___
::| | | | | | |/ _ \/ __| __/ _ \| '__| \___ \| | | / __| __/ _ \ '_ ` _ \/ __|
::| |_| | |_| |  __/\__ \ || (_) | |     ___) | |_| \__ \ ||  __/ | | | | \__ \
:: \__\_\\__,_|\___||___/\__\___/|_|    |____/ \__, |___/\__\___|_| |_| |_|___/
::                                             |___/
::
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
if not %QS_ACC_Admin_Pass%.==. set pass=%QS_ACC_Admin_Pass%

echo using credentials: %QS_ACC_Admin_Dom%\%QS_ACC_Admin_Acc%
:START
if %pass%.==. set /p pass=Enter password:
echo connecting to server: %1
net use \\%1\ipc$ %pass% /user:%QS_ACC_Admin_Dom%\%QS_ACC_Admin_Acc%
shift
if not %1.==. goto START
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Get an admin user access token to server provided on the command line, using %QS_ACC_Admin_Dom%\%QS_ACC_Admin_Acc%
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
set pass=