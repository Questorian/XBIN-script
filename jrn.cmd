@echo off

::------------------------------------------------------------------------
:: jrn.cmd
::------------------------------------------------------------------------
::
:: jrn.cmd: Wrapper script to call the journal program because of SNOW2 issue
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-11-14T15:16:59
:: History:
::		v0.2 - 
::		v0.1 - 2008-11-14 - initial version created
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
perl v:\scripts\journal.pl %1 %2 %3 %4 %5 %6 %7 %8 %9


:usage

:end