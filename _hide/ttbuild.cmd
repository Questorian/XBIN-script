@echo off

::------------------------------------------------------------------------
:: ttbuild.cmd
::------------------------------------------------------------------------
::
:: ttbuild.cmd: Build a wft site from the templates provided
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2009-11-12T18:50:51
:: History:
::		v0.2 - 
::		v0.1 - 2009-11-12 - initial version created
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
ttree -f tt2.cfg %*


:usage

:end