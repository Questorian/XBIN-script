@echo off
set VER=1.0

::-----------------------------------------------------------------
::-----------------------------------------------------------------
:: Ed.cmd: Call the default QS Editor
::
:: version:   1.0
:: created:   Mon Oct 15 15:50:19 2001
:: Author:    Farley Balasuriya, (T007593/SSRFBL), UBS AG, Basel, Schweiz.
:: Revision:	
::            15/09/01 - v1.0 created
::-----------------------------------------------------------------
::-----------------------------------------------------------------


:SETS
rem if "%Q_Editor%"=="" goto Err1
if "%Q_Editor%"=="" set Q_Editor=EditPlus.exe

:START
start %Q_Editor% %1 %2 %3 %4 %5 %6 %7 %8 %9


goto END
:: ERRORS
:: ------
:ERR1
echo %0: Err1: variable "Q_Editor" not defined. Please define and restart
goto END

:ERR2
echo %0: Err2:
goto END

:END
set VER=