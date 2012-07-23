@echo off
set VER=1.0

::-----------------------------------------------------------------
::-----------------------------------------------------------------
:: setpass.cmd: set the password for various scripts in the %QS_Acc_Admin_Pass% variable
::
:: version:   1.0
:: created:   Fri Jun 28 15:53:06 2002
:: Author:    Farley Balasuriya, (QS10001), Questor Systems, Basel, Schweiz.
:: Revision:	
::            28/05/02 - v1.0 created
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, Schweiz
:: http://www.questor.ch	
:: mailto:info@questor.ch
::-----------------------------------------------------------------


:SETS
set QS_Acc_Admin_Pass=%1

:START


goto END
:: ERRORS
:: ------
:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END