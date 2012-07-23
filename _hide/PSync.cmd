@echo off
::Sync files 

:SETS
if %QS_PATH_Mirror%.==. echo QS_PATH_Mirror variable not set. settting to default value: d:\DATA\BKUP\PERSONA  && set QS_PATH_Mirror=d:\DATA\BKUP\PERSONA


set QS_ROBO_Options=/MIR /R:3 /W:4 /LOG+:%QS_PATH_LLog%\%0.log
if %QS_Persona%.==. goto ERR1

::clean up the old log file if it exists
if exist %QS_PATH_LLog%\%0.log del %QS_PATH_LLog%\%0.log

echo moving to Mirror Directory: %QS_PATH_Mirror%
echo log file:%QS_PATH_LLog%\%0.log
pushd %QS_PATH_Mirror%\%QS_Persona%

for /D %%a in (*.*) DO for /D %%b in (%%a\*.*) DO echo syncing: \\%%b to %QS_PATH_Mirror%\%QS_Persona%\%%b && robocopy \\%%b %%b %QS_ROBO_Options%


net send %computername% %0: completed
::play notify sound to let user know psync has finished
call playsound Bassoon
::view the output log generated
call vlog %0
popd
goto END

:ERR1
echo no QS_Persona variable set
goto END
:ERR2


:END