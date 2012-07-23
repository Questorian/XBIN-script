@echo off
set VER=1.0

::-----------------------------------------------------------------
::-----------------------------------------------------------------
:: makemonthdirs.cmd: Make all of the months of the year subdirectories in current dir
::
:: version:   1.0
:: created:   Thu May 30 12:01:57 2002
:: Author:    Farley Balasuriya, (QS10001), Questor Systems, Basel, Schweiz.
:: Revision:	
::            30/04/02 - v1.0 created
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, Schweiz
:: http://www.questor.ch	
:: mailto:info@questor.ch
::-----------------------------------------------------------------


:SETS

:START
md "01 - Jan"
md "02 - Feb"
md "03 - Mar"
md "04 - Apr"
md "05 - May"
md "06 - Jun"
md "07 - Jul"
md "08 - Aug"
md "09 - Sep"
md "10 - Oct"
md "11 - Nov"
md "12 - Dec"




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