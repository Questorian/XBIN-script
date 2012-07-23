@echo off

::------------------------------------------------------------------------
:: sqlms.cmd
::------------------------------------------------------------------------
::
:: sqlms.cmd: kick-off the SQL Server Management Studio
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-12-22T22:44:39
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


:sets


:start
:: SQL Server 2005
:: start "sqlms" "C:\Program Files\Microsoft SQL Server\90\Tools\Binn\VSShell\Common7\IDE\SqlWb.exe"


:: SQL Server 2008
:: start "sqlms" "C:\Program Files\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Ssms.exe"
start "sqlms" "C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Ssms.exe"

:usage

:end