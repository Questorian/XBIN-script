rem @echo off
rem -------------------------------------------------------------------------
rem Farley Balasuriya, Questor Systems GmbH (qs10001) - http://www.questor.ch
rem -------------------------------------------------------------------------

rem TBD's
rem -----
rem * Check that the WORKFLOWDIR is empty first?
rem * Copy logfile to the server INBOX
rem * Add this batch and perl script to the CVS system
rem * And then make the BIN directory read only!
:SETS
rem check the QSCDE has been called and if not invoke it to set the variables 
rem that we need in this CMD shell
if %QS_QSCDEBuildNo%.==. echo invoking QSCDE & call QSCDE	
set QS_DEFAULT_PHOTO_LOCATION=F:\DCIM
set QS_PHOTO_WORKFLOW_DIR=C:\qscde\data\PhotoWorkflow\inbox
set QS_SERVER_INBOX=\\%QS_ResourceServer%\INBOX
set QS_TARGET_ALBUM=\\%QS_ResourceServer%\PhotoAlbum
set QS_PHOTO_BKUP_DIR=C:\TEMP\_ready_to_delete\PHOTOS
set LOG=%QS_PHOTO_BKUP_DIR%\ImportPhotos.log

:START
echo ******************* > %LOG%
echo %0 starting user:%USERNAME%, computer:%COMPUTERNAME%, date:%date% time:%time% >> %LOG%

set PHOTODIR=%QS_DEFAULT_PHOTO_LOCATION%
if not %1.==. set PHOTODIR=%1

echo 1. Make a backup of the source location. Just in case
echo -----------------------------------------------------
echo source of new photos: %PHOTODIR%
set STR=%date%
if not exist "%QS_PHOTO_BKUP_DIR%\%STR%" md "%QS_PHOTO_BKUP_DIR%\%STR%"
xcopy %PHOTODIR%\*.* "%QS_PHOTO_BKUP_DIR%\%STR%" /f /y /s /e /v /i /h /c >> %LOG%
ir errorlevel 1 goto ERR1

echo 2. Check that we have an exact copy of the soure in %QS_PHOTO_BKUP_DIR%
echo -----------------------------------------------------------------------
rem windiff  "%QS_PHOTO_BKUP_DIR%\%STR%" %PHOTODIR%


echo 3. Now we scan the existing album and move/rename any 
echo ------------------------------------------------------
echo new files onto this worksttation ready for workflow proceessing to 
echo copy %QS_TARGET_ALBUM%  - %QS_PHOTO_WORKFLOW_DIR%
rem call the perl script...
echo Importing Photos. This could take some time...
perl %QS_DRV_Bin%\scripts\import_photos.pl  >> %LOG%



echo 5. Delete the Files from the source
echo ------------------------------------
rm /s /q  %PHOTODIR%


echo 6. Start the photo-processing sofware
echo --------------------------------------
type %LOG%
if exist "C:\Program Files\BreezeSys\BreezeBrowser\BreezeBrowser.exe"  "C:\Program Files\BreezeSys\BreezeBrowser\BreezeBrowser.exe"  %QS_PHOTO_WORKFLOW_DIR%


echo 7. Copy log to the INBOX on file server
echo ---------------------------------------


goto END

:ERR1
echo %0: ERR1: problem with the XCOPY. Probably not all the files copied.
echo Please check and run again...
echo.
goto END

:ERR2
echo %0: ERR2: 
echo.
goto END


:END