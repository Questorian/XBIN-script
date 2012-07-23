@echo off

::------------------------------------------------------------------------
:: chkdskOnReboot.cmd
::------------------------------------------------------------------------
::
:: chkdskOnReboot.cmd: Check all the local drives on the next system restart
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-12-22T12:20:37
:: History:
::		v0.2 - 
::		v0.1 - 2008-12-22 - initial version created
::            
::------------------------------------------------------------------------
:: QuestorSystems.com - Gempenstrasse 46, CH-4053, Basel, Switzerland
::------------------------------------------------------------------------
set svn_id=$Id: t.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
set svn_rev=$Rev: 114 $
::------------------------------------------------------------------------


:args


:checks
::check that we are a member  of the administrators group
:: or this will not work
call :checkAdmin



:sets
:: EDIT: qj<uadd all the localdrives on your system to 'drives_to_check'
set drives_to_check=C D

:start
:: reset anything that may be pending
chkntfs /d
:: exclude the QSCDE XBIN drive - if running under QSCDE
if %Q_DRV_XBIN%.==. chkntfs /x %Q_DRV_XBIN%
:: check the bootime countdown to zero
chkntfs /t:0

:: now schedule each drive that is present in 'drives_to_check
for %%d in (%drives_to_check%) do chkntfs /c %%d:

echo *************************************************************
echo * Chkdsk tasks have  been scheduled for next system restart *
echo * Please check the eventlog for errors after the restart    *
echo *************************************************************
goto end




:checkAdmin
:: ----- Check we have admin rights -----
net localgroup administrators | more +6 > %temp%\usercheck.tmp
rem check useranme with the returned list
find "%USERNAME%" %temp%\usercheck.tmp >nul
if not errorlevel 1 (

    :: We have the right! - return
	goto :eof
)
:: we do not have right - error message and quit
goto err1

:usage


:err1
echo error: you must be a member of the local administrators group
echo to run this script - %0
echo Logon or use runas to execute this script with the correct 
echo user rights
goto ERR2

:ERR2
:end
:end2