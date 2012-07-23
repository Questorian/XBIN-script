@echo off

::------------------------------------------------------------------------
:: vi.cmd
::------------------------------------------------------------------------
::
:: vi.cmd: invoke GVIM with whatever parameters etc
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-12-18T16:51:31
:: History:
::		v0.2 - 
::		v0.1 - 2008-12-18 - initial version created
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
set LKANG=en_UK
set PATH=%Q_DRV_XBIN%\vim\vim72;%PATH%


:start
start gvim %1 %2 %3 %4 %5 %6 %7 %8 %9 


:usage

:end
