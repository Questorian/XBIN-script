@echo off

::------------------------------------------------------------------------
:: set-ntp.cmd
::------------------------------------------------------------------------
::
:: set-ntp.cmd: set the NTP servers on this client to enable time synch
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2009-05-22T03:13:07
:: History:
::		v0.2 - 
::		v0.1 - 2009-05-22 - initial version created
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
net time /setsntp:"0.ch.pool.ntp.org 1.ch.pool.ntp.org 2.ch.pool.ntp.org 3.ch.pool.ntp.org"
net time /QUERYSNTP



:usage

:end