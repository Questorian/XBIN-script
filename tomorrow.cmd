:: @echo off

set FILE=c:\temp\tomorrow.txt

:start
if %1.==new. goto new
if %1.==NEW. goto new
::want to edit existing file
goto edit


:new
if exist %FILE% del %FILE%
copy %Q_DRV_XBIN%\_data\templates\text\tomorrow.txt %FILE%

:edit
call ed %FILE%

:end