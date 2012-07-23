rem @echo off

:: /--------------------------------------------------------------------------/
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
:: /--------------------------------------------------------------------------/
::
:: burn.cmd: Burn files and directories from the command line using NERO
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Mon Jun 13 15:48:26 2005
:: History:
::		v0.2 - 
::		v0.1 - 13/06/05 - initial version created
::            
:: /--------------------------------------------------------------------------/
:: /--------------------------------------------------------------------------/
::  ___                  _               ____            _
:: / _ \ _   _  ___  ___| |_ ___  _ __  / ___| _   _ ___| |_ ___ _ __ ___  ___
::| | | | | | |/ _ \/ __| __/ _ \| '__| \___ \| | | / __| __/ _ \ '_ ` _ \/ __|
::| |_| | |_| |  __/\__ \ || (_) | |     ___) | |_| \__ \ ||  __/ | | | | \__ \
:: \__\_\\__,_|\___||___/\__\___/|_|    |____/ \__, |___/\__\___|_| |_| |_|___/
::                                             |___/
::
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
:: /--------------------------------------------------------------------------/

@if not "%ECHO%"=="" echo %ECHO%
@if not "%OS%"=="Windows_NT" goto DOSEXIT

:: Set local scope and call MAIN procedure
setlocal & pushd & set RET=
:: /--------------------------------------------------------------------------/
set svn_rev=$Rev: 114 $
set svn_id=$Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
set SCRIPTNAME=%~n0
set SCRIPTPATH=%~f0
:: /--------------------------------------------------------------------------/

if "%QS_Debug%"=="1" (set TRACE=echo) else (set TRACE=rem)

call _CMDLib :INIT %SCRIPTPATH%

:QSCDEInit
if not %QS_Init%.==1. (call QSCDE & if defined TRACE %TRACE% calling: QSCDEInit)
:ARGS
if /i {%1}=={/help} (call :HELP %2) & (goto :HELPEXIT)
if /i {%1}=={/h} (call :HELP %2) & (goto :HELPEXIT)
if /i {%1}=={/?} (call :HELP %2) & (goto :HELPEXIT)
if /i {%1}=={--help} (call :HELP %2) & (goto :HELPEXIT)
if /i {%1}=={-h} (call :HELP %2) & (goto :HELPEXIT)
if /i {%1}=={-?} (call :HELP %2) & (goto :HELPEXIT)
if /i %1.==. (call :USAGE %2) & (goto :HELPEXIT)
:VERSION
if /i {%1}=={/v} (call :VERSION %2) & (goto :HELPEXIT)
if /i {%1}=={/version} (call :VERSION %2) & (goto :HELPEXIT)
if /i {%1}=={-v} (call :VERSION %2) & (goto :HELPEXIT)
if /i {%1}=={--version} (call :VERSION %2) & (goto :HELPEXIT)
call :MAIN %*
echo this is main...
:HELPEXIT
popd & endlocal & set RET=%RET%
goto :EOF


:: /--------------------------------------------------------------------------/
::  MAIN procedure
:: /--------------------------------------------------------------------------/
:MAIN
if defined TRACE %TRACE% [proc %0 %*]

:SETS
:: call _CMDLib GetDate
echo we are here...
set BURN_DRV=Z
set BURN_CMD="C:\Program Files\ahead\Nero\nerocmd.exe"

:START
if not exist %BURN_CMD% goto ERR1
:: !TBD!if not exist %1 goto ERR2
set BURN_OPTS=--real --verify --underrun_prot --create_iso_fs --recursive --publisher "Questor Systems GmbH" --drivename %BURN_DRV%  --write --iso BURN-%v_date%

%BURN_CMD% %BURN_OPTS% %*
::now we check it again ...
:: %BURN_CMD% --load --drivename %BURN_DRV%

:: End of main
goto :EOF


:: /--------------------------------------------------------------------------/
::  HELP procedure
:: /--------------------------------------------------------------------------/
:HELP
:USAGE
if defined TRACE %TRACE% [proc %0 %*]
echo usage: %0, %svn_rev%
echo	%0 --dvd file1 [file2] ...
echo.
echo    --dvd    burn to DVD instead of CD
echo.
echo Description:
echo Burn the target directly onto a CD / DVD
echo.
goto :EOF


:: /--------------------------------------------------------------------------/
::  VERSION procedure
:: /--------------------------------------------------------------------------/
:VERSION
echo filename: %SCRIPTNAME%
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
perl -v 
goto END

:ERR1
echo %0: Err1: %BURN_CMD% not found
echo is NERO installed on this machine?
goto :EOF

:ERR2
echo %0: Err2: path "%1" does not exist. Please try again
goto :EOF

:END
:DOSEXIT
echo This script requires Windows NT or later
