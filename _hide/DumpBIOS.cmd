@echo off
set VER=1.0

::-----------------------------------------------------------------
::-----------------------------------------------------------------
:: BIOSDump.cmd: Dump out the contents of the local machine using WMI.
:: (note that you can also use the IBM tool SMBIOS /g
::
:: version:   1.0
:: created:   Mon Oct 22 14:24:46 2001
:: Author:    Farley Balasuriya, (T007593/SSRFBL), UBS AG, Basel, Schweiz.
:: Revision:	
::            22/09/01 - v1.0 created
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, Schweiz
:: http://www.questor.ch	
:: mailto:info@questor.ch
::-----------------------------------------------------------------


:SETS

:START
echo dumping TYPE1 BIOS information ("wbemdump root\cimv2 win32_bios")
wbemdump root\cimv2 win32_bios
echo dumping TYPE3 BIOS information ("wbemdump root\cimv2 win32_SystemEnclosure")
wbemdump root\cimv2 win32_SystemEnclosure
echo dumping TYPE2 BIOS information ("wbemdump root\cimv2 win32_BaseBoard")
wbemdump root\cimv2 win32_BaseBoard


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