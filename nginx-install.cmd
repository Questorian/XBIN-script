@echo off

::------------------------------------------------------------------------
:: nginx-install.cmd
::------------------------------------------------------------------------
::
:: nginx-install.cmd: whatever
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2010-06-04T00:55:02
:: History:
::		v0.2 - 
::		v0.1 - 2010-06-04 - initial version created
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
echo Installing nginx as a service

sc create nginx binPath= v:\rktools\srvany.exe DisplayName= "NginX HTTP Server"
echo now create a new key called Parameters for your service
echo creat a new STRING value therein called Application and add the path to nginX - v:\nginx\nginx.exe


:usage

:end