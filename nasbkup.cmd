
::------------------------------------------------------------------------
:: nasbkup.cmd
::------------------------------------------------------------------------
::
:: nasbkup.cmd: Quick and dirty backup of the local (QSCDE) system to NAS
::
:: Project:            
:: Author:             Farley Balasuriya (developer@QuestorSystems.com)
:: Created:           2012-05-31T08:05:45
:: History:
::                             v0.2 - 
::                             v0.1 - 2012-05-31 - initial version created
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
set nas=nqsaaa01
set base_dir=\\%nas%\shrdata\PROD\PROJECTS\BKUP\_sys\%computername%\_data
set robocopy_args=/R:5 /W:1 /FFT


:start

if not exist %base_dir% md %base_dir%
robocopy %Q_PATH_ROOT%  %base_dir% /MIR %robocopy_args%


:usage


:end
