@echo off

set INBOX=C:\data\usr\PHOTOWORKFLOW\INBOX
set TARGET=%QS_SHR_INBOX%\PHOTOS
set POSTED_DIR=C:\TEMP\_ready_to_delete\PHOTOS\_posted

rem !! Think about using VCOPY.cmd, from c't magazine !!!
:START
echo Copying files
xcopy %INBOX%\*.*  %TARGET% /s /V /F /Y 

pause
echo Moving files out of INBOX to safe copy directory (%POSTED_DIR%)
move %INBOX%\*.*  %POSTED_DIR%
for /d %%d in (%INBOX%\*.*) do move %%d  %POSTED_DIR%

echo done!