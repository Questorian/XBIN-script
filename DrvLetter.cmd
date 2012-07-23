@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: DrvLetter.cmd: Set or change the drive letter of a certain disk drive in use
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Fri Jun 24 11:35:12 2005
:: History:
::		v0.2 - 
::		v0.1 - 24/06/05 - initial version created
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

:START
echo off
mountvol %1 /L>drive.mnt
Echo Deleting %1 drive
mountvol %1 /D
for /f %%I in (drive.mnt) do set changedrive=%%I
Echo Remounting %1 as %2 drive
mountvol %2 %changedrive%
set changedrive=
del drive.mnt
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Set or change the drive letter of a certain disk drive in use
echo see:
echo  http://www.msfn.org/board/index.php?showtopic=10905&hl=
echo  http://support.microsoft.com/default.aspx?scid=kb%3Ben-us%3BQ280297
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