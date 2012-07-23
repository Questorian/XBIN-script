@echo off

::------------------------------------------------------------------------
:: sucmd.cmd
::------------------------------------------------------------------------
::
:: sucmd.cmd: SU CMD - run cmd shell as a super-user
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-12-22T15:27:10
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
set uid=QSSysAdm
:: qset cmd=cmd /k "title su - %uid%" && color 43
set cmd=cmd 

runas /profile /user:%computername%\%uid% "%cmd%"

:start



:usage

:end