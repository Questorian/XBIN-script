rem @echo off

::------------------------------------------------------------------------
:: qbkup2.cmd
::------------------------------------------------------------------------
::
:: qbkup2.cmd: backup device to QNAP - nice and secure your data
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2010-02-21T21:10:12
:: History:
::		v0.2 - 
::		v0.1 - 2010-02-21 - initial version created
::            
::------------------------------------------------------------------------
:: QuestorSystems.com - Gempenstrasse 46, CH-4053, Basel, Switzerland
::------------------------------------------------------------------------
set svn_id=$Id: t.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
set svn_rev=$Rev: 114 $
::------------------------------------------------------------------------


:args
set QNAP=NQSAAA01

:sets
set target=\\%QNAP%\bkup\hosts\%computername%


:start
if not exist \\%QNAP%\bkup\hosts md \\%QNAP%\bkup\hosts
if not exist  %target%  md %target%
if not exist  %target%\QS  md %target%\QS

:copy
robocopy %Q_PATH_ROOT% %target%\QS /MIR /R:5 /W:4 



:usage

:end