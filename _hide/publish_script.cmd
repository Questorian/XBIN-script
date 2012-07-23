@echo off

::------------------------------------------------------------------------
:: publish_script.cmd
::------------------------------------------------------------------------
::
:: publish_script.cmd: whatever
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2012-02-11T18:16:20
:: History:
::		v0.2 - 
::		v0.1 - 2012-02-11 - initial version created
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
if NOT %COMPUTERNAME%.==LQSAAA06. goto err1
robocopy D:\QS\PACK\PACK-REPO\script  v:\script /MIR /XD .git /R:3 /W:2 


:err1
echo this script must be run on script master machine LQSAAA06
goto end

:usage

:end