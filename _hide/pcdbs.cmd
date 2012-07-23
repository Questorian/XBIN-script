@echo off

::------------------------------------------------------------------------
:: pcdbs.cmd
::------------------------------------------------------------------------
::
:: pcdbs.cmd: Load the Perl CD Bookshelf
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-11-04T11:45:15
:: History:
::		v0.2 - 
::		v0.1 - 2008-11-04 - initial version created
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
set PCDBS_PATH=%Q_DRV_XBIN%\qsh\PerlCDBookShelf2\index2.htm


:start
start %PCDBS_PATH%


:usage

:end
set PCDBS_PATH=