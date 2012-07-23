@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: _CMDLib.cmd: Standard library of utility routines for CMD, and batch 
::  Idea and concept created by F. J. Balasuriya
::
:: Project:	
:: Author:	Farley Balasuriya, (QSSysadm@questor.intra)
:: Created:	Sat May 28 16:31:08 2005
:: History:
::		v0.2 - 
::		v0.1 - 28/05/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
::-----------------------------------------------------------------
:: _     _ _                            __  __           _       _
::| |   (_) |__  _ __ __ _ _ __ _   _  |  \/  | ___   __| |_   _| | ___
::| |   | | '_ \| '__/ _` | '__| | | | | |\/| |/ _ \ / _` | | | | |/ _ \
::| |___| | |_) | | | (_| | |  | |_| | | |  | | (_) | (_| | |_| | |  __/
::|_____|_|_.__/|_|  \__,_|_|   \__, | |_|  |_|\___/ \__,_|\__,_|_|\___|
::                              |___/
::
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
::-----------------------------------------------------------------


::-------------------------------------------------------------------------------
:: NOTE : !!! THIS LIBRARY REQUIRES A WORKING VERSION OF PERL TO BE INSTALLED !!!
::-------------------------------------------------------------------------------


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
:: -----------------------------------------------------------------------------
::  ____ __  __ ____    ____        _                     _   _
:: / ___|  \/  |  _ \  / ___| _   _| |__  _ __ ___  _   _| |_(_)_ __   ___  ___
::| |   | |\/| | | | | \___ \| | | | '_ \| '__/ _ \| | | | __| | '_ \ / _ \/ __|
::| |___| |  | | |_| |  ___) | |_| | |_) | | | (_) | |_| | |_| | | | |  __/\__ \
:: \____|_|  |_|____/  |____/ \__,_|_.__/|_|  \___/ \__,_|\__|_|_| |_|\___||___/
::
:: -----------------------------------------------------------------------------

rem If no arguments, show version information and exit
if %1.==. (goto VERSION) & (Goto :EOF)

rem At least one argument, so dispatch to procedure
set _PROC=%1
shift /1
goto %_PROC%


:: New CODE-----------------------------------------------------------------------
:INIT
if defined TRACE %TRACE% [proc %0 %*]
:: startup code for all scripts that call the library goes here
goto :EOF


:GetDatetime
for /f %%i in ('perl -MTime::Piece -e "print localtime->datetime";') do set v_datetime=%%i
goto :EOF

:GetDate
for /f %%i in ('perl -MTime::Piece -e "print localtime->date";') do set v_date=%%i
goto :EOF

:GetTime
for /f %%i in ('perl -MTime::Piece -e "print localtime->time";') do set v_time=%%i
goto :EOF



:: Variable functions 
:DelVars
if defined TRACE %TRACE% [proc %0 %*]
    for /f “tokens=1 delims==” %%I in (‘set %1 2^>nul’) do set %%I=
goto :EOF



:: LEGACY CODE--------------------------------------------------------------------
:GetDate
for /F "tokens=1-4 delims=. " %%i in ('date /t') do (
  set QS_VAR_DOW=%%i
  set QS_VAR_DD=%%j
  set QS_VAR_MM=%%k
  set QS_VAR_YY=%%l
)

:GetTime
REM Get time variables.
for /F "tokens=1-2 delims=: " %%i in ('time /t') do (
  set QS_VAR_HOUR=%%i
  set QS_VAR_MIN=%%j
  set QS_VAR_SEC=%%k
  set QS_VAR_TIME=%%i:%%j:%%k
)

REM Get minutes without A.M. or P.M.
set ZMin=%min:~0,2%


::DATETIME
:: create a quick and dirty ISO 8601 datetime datatype
set QS_VAR_DATETIME=%QS_VAR_YY%%QS_VAR_MM%%QS_VAR_DD%T%QS_VAR_HOUR%%QS_VAR_MIN%%QS_VAR_SEC%





goto END

:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Standard library of utility routines for CMD, and batch files. F. J. Balasuriya
goto :EOF

:VERSION
echo filename: %0
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto :EOF

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END




::-------------------------------------------------------------------------------
:: NOTE : !!! THIS LIBRARY REQUIRES A WORKING VERSION OF PERL TO BE INSTALLED !!!
::-------------------------------------------------------------------------------


::-----------------------------------------------------------------
:: _     _ _                            __  __           _       _
::| |   (_) |__  _ __ __ _ _ __ _   _  |  \/  | ___   __| |_   _| | ___
::| |   | | '_ \| '__/ _` | '__| | | | | |\/| |/ _ \ / _` | | | | |/ _ \
::| |___| | |_) | | | (_| | |  | |_| | | |  | | (_) | (_| | |_| | |  __/
::|_____|_|_.__/|_|  \__,_|_|   \__, | |_|  |_|\___/ \__,_|\__,_|_|\___|
::                              |___/
::
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
::-----------------------------------------------------------------
:END