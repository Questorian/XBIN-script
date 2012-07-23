@echo off

::------------------------------------------------------------------------
:: NewPerlModule.cmd
::------------------------------------------------------------------------
::
:: NewPerlModule.cmd: whatever
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-11-29T20:00:49
:: History:
::		v0.2 - 
::		v0.1 - 2008-11-29 - initial version created
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

:: set MODULE_STARTER_DIR=%Q_DRV_XBIN%\_data\Perl\.module-starter
set MODULE_STARTER_DIR=%Q_DRV_XBIN%\_app_config\.module-starter

%PATH%=%PATH%;%Q_DRV_XBIN%\perl\site\bin

:start
echo MODULE_STARTER_DIR=%Q_DRV_XBIN%\_data\Perl\.module-starter
perl -MModule::Starter::PBP=setup

:usage

:end