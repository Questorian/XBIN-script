@echo off
::------------------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::------------------------------------------------------------------------
::
:: v:\scripts\USBUnmount.cmd: Safely unmount a USB drive or device from the command line after syncing
::
:: Project:	
:: Author:	Farley Balasuriya,  (qs10001@QUESTOR.INTRA)
:: Created:	Sun May  8 11:20:28 2005
:: History:
::		    v0.2 - 
::		    v0.1 - 08/05/05 - initial version created
::			    from note one -> http://www.uwe-sieber.de/usbstick_e.html
::            
::------------------------------------------------------------------------
::------------------------------------------------------------------------
set svn_id=$Id: t.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
set svn_rev=$Rev: 114 $
::------------------------------------------------------------------------

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
set drive=U:

:START
@echo off
if not exist %drive% goto end
sync %drive%
unmount -l %drive%
DevEject -EjectDrive:%drive%
if errorlevel 1 pause
:end
set drive=
goto END


:USAGE
echo usage: %0 (%svn_rev%)
echo	%0 
echo Description:
echo Safely unmount a USB drive or device from the command line after syncing
goto END

:VERSION
echo filename: %0
echo svn_id: %svn_id%
echo svn_LastChangedDate: %svn_LastChangedDate%
echo svn_rev: %svn_rev%
goto END

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END