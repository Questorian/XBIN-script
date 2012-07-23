@echo off

::------------------------------------------------------------------------
:: x2u.cmd
::------------------------------------------------------------------------
::
:: x2u.cmd: Copy the master XBIN directory
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-12-26T13:41:46
:: History:
::		v0.2 - 
::		v0.1 - 2008-12-26 - initial version created
::            
::------------------------------------------------------------------------
:: QuestorSystems.com - Gempenstrasse 46, CH-4053, Basel, Switzerland
::------------------------------------------------------------------------
set svn_id=$Id: t.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
set svn_rev=$Rev: 114 $
::------------------------------------------------------------------------


:args


:sets
set host=NQSAAA01
set source=D:\QS\PACK\PACK-XBIN
set target=H:\PACK-XBIN

:start
if not %computername%.==%host%. goto err1
if not exist %source% goto err2
if not exist %target% goto err3
robocopy %source% %target% /MIR /R:2 /W:2


:usage
goto end

:err1
echo - This script can only be run on machine: %host%
goto end

:err2
echo - cannot find source: %source%
goto end

:err2
echo - cannot find target - %target% - is USB device installed for copy?
goto end

:end