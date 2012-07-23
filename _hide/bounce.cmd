@echo off

::------------------------------------------------------------------------
:: bounce.cmd
::------------------------------------------------------------------------
::
:: bounce.cmd: restart a Windows Server somewhere - you need admin rights
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2010-02-16T20:50:39
:: History:
::		v0.2 - 
::		v0.1 - 2010-02-16 - initial version created
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
set timeout=60


:start
echo bouncing: %1
ping %1 
if errorlevel 1 goto not_found


:bounce
start cping %1
shutdown /r /t %timeout% /m \\%1

:not_found
echo server %1 was not found on the network - check name or use fqdn

:end



:usage

:end