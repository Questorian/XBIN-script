rem @echo off

::------------------------------------------------------------------------
:: LoadPhotos.cmd
::------------------------------------------------------------------------
::
:: LoadPhotos.cmd: whatever
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2009-06-25T14:40:26
:: History:
::		v0.2 - 
::		v0.1 - 2009-06-25 - initial version created
::            
::------------------------------------------------------------------------
:: QuestorSystems.com - Gempenstrasse 46, CH-4053, Basel, Switzerland
::------------------------------------------------------------------------
set svn_id=$Id: t.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
set svn_rev=$Rev: 114 $
::------------------------------------------------------------------------


:args
if %1.==. goto err1


:sets
:: set target=c:\temp\Photo-test-import
set target=D:\QS\_td\inbox\PHOTOS

:start
copyphotos %1 %target% %*
goto end

:err1
echo please specify the source of the photos
goto end

:usage

:end