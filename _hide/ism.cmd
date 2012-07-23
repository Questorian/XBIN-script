rem @echo off

::------------------------------------------------------------------------
:: ism.cmd
::------------------------------------------------------------------------
::
:: ism.cmd: whatever
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2010-03-18T06:49:01
:: History:
::		v0.2 - 
::		v0.1 - 2010-03-18 - initial version created
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


:start
start "ISM Server" CMD.exe /K perl.exe %Q_DRV_XBIN%\ism\script\myapp_server.pl
sleep 5
"http://localhost:3000/ism"


:usage

:end