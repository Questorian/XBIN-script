rem @echo off
set VER=1.0

::-----------------------------------------------------------------
::-----------------------------------------------------------------
:: RestartSystem.cmd: Restart a reomte NT box but with a ping check to see when it came back up again
::
:: version:   1.0
:: created:   Thu Nov  1 18:22:34 2001
:: Author:    Farley Balasuriya, (T007593/SSRFBL), UBS AG, Basel, Schweiz.
:: Revision:	
::            01/10/01 - v1.0 created
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, Schweiz
:: http://www.questor.ch	
:: mailto:info@questor.ch
::-----------------------------------------------------------------


:SETS

:START
if %1.==. goto ERR1
shutdown \\%1 /R  /T:5 "RestartSystem: system %1 will be restarted ..." /Y /C
ping -t %1




goto END
:: ERRORS
:: ------
:ERR1
echo %0: Err1: you must specify the name of the machine to restart
goto END

:ERR2
echo %0: Err2:
goto END

:END