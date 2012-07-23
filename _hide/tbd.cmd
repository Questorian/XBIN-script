rem @echo off
title TBD

::set HOME variable - required for Windows
if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
if not exist "%HOME%" @set HOME=%USERPROFILE%

set TBDFILE=%Q_DRV_XBIN%\_data\apps\tbd\tbd.txt
set UPFILE=%Q_DRV_XBIN%\_data\apps\tbd\tbd-upload.txt
:: make a new emptly tasks template
if not exist %TBDFILE% perl %Q_DRV_XBIN%\script\gen-empty-tbd.pl > %TBDFILE%
:: edit it
notepad %TBDFILE%
:: format it for Hiveminder
:: perl %Q_DRV_XBIN%\script\tbd2.pl %TBDFILE% > %UPFILE%
perl %Q_DRV_XBIN%\script\tbd3.pl %TBDFILE% > %UPFILE%


:: upload it and merge with existing tasks
SET /P UPLOAD=Do you wish to upload the file now?
if %UPLOAD%.==y. goto upload
if %UPLOAD%.==Y. goto upload
goto end

:UPLOAD
echo We are uploading the file now...
call todo upload %UPFILE%
:: delete it - ready for next run
del /Q %TBDFILE%


:end

