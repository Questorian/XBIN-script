@echo off
set VER=1.0

::-----------------------------------------------------------------
::-----------------------------------------------------------------
:: cping.cmd: Continuous-Pin a client, or clients
::
:: version:   1.0
:: created:   Tue Nov 12 16:04:04 2002
:: Author:    Farley Balasuriya, Questor Systems GmbH
:: Revision:	
::            12/10/02 - v1.0 created
::-----------------------------------------------------------------
:: 
:: SYNGENTA, Basel, Switzerland
:: -----------------------------
::
:: SMSTools
:: 
::-----------------------------------------------------------------

:SETS
:CHECKS

:START
if %1.==. goto END
start "%0 %1" cmd /T:fc /k ping %1 -l 1 -t
SHIFT
goto START

:END