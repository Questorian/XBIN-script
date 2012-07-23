@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: CDBurn.cmd: Burn the target directly onto a CD / DVD
::
:: Project:	
:: Author:	Farley Balasuriya
::		(QSSysadm@questor.intra)
:: Created:	Sat Jun 11 13:42:41 2005
:: History:
::		v0.2 - 
::		v0.1 - 11/06/05 - initial version created
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
::
:: TBD's
:: * remove the --real if the QS_Debug flag is defined, or even better
::      options for the batch
:: * --publisher "Questor Systems GmbH" seems to cause a problem..
:: * use the @param file?

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
call GetDate
echo return from GetDate: %v_date%
set BURN_DRV=Z
set BURN_CMD="C:\Program Files\ahead\Nero\nerocmd.exe"

:START
if not exist %BURN_CMD% goto ERR1
:: !TBD!if not exist %1 goto ERR2
set BURN_OPTS=--real --verify --underrun_prot --create_iso_fs --recursive --publisher "Questor Systems GmbH" --drivename %BURN_DRV%  --write --iso BURN-%v_date%
%BURN_CMD% %BURN_OPTS% %*
::now we check it again ...
:: %BURN_CMD% --load --drivename %BURN_DRV%
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 --dvd file1 [file2] ...
echo.
echo    --dvd    burn to DVD instead of CD
echo.
echo Description:
echo Burn the target directly onto a CD / DVD
echo.
goto END

:VERSION
echo filename: %0
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: %BURN_CMD% not found
echo is NERO installed on this machine?
goto END

:ERR2
echo %0: Err2: path "%1" does not exist. Please try again
goto END

:END