@echo off
rem note: CF-CARD and NexAI - format the card with FAT (not FAT32 or NTFS) - This avoids
rem 	the corruption in the directory tree when picking tunes from the directory view
rem	e.g. format f: /fs:fat


:SETS
if not %QS_Init%.==1. goto ERR_NO_QS
set file_types=*.wma *.mp3 *.m3u *.wav
set source=%QS_SHR_AUDIO%\inbox
set target=F:
set forced=
if not %1.==. (set target=%1&&set forced=1)
set flag=%target%\ais.flg

:CHECK
if %forced%.==1. goto START
if exist %flag% goto START
goto HELP

:START
title %0 - %date%, %time%

echo AIS - Audio Inbox Sync
echo ----------------------
echo source    : %source%
echo target    : %target%
echo file types: %file_types%
echo ----------------------

rem create the 'flag' for next time to speed things up
if not exist %flag% echo. > %flag%


rem check for existing device (NEX Ia/iHP-100) recordings on the device
rem -------------------------------------------------------------------
rem if there any existing dictation notes, copy them into the %source%\_streams directory first.
rem We need to save these!
if not exist %source%\_streams md %source%\_streams
rem look for the older style NEX Ia rec_*.* fiels which they do not support any more, but just in case
for  %%a in (%target%\REC_*.*) do (copy %%a  %source%\_streams\%%~na.mp3 && echo NOTICE: Saving recording file:%%a)
rem look for the newer style NEX Ia VOICEnnn.mp3 files, and backup into INBOX\streams
for  %%a in (%target%\VOIC*.*) do (copy %%a  %source%\_streams\%%~na.mp3 && echo NOTICE: Saving recording file:%%a)

::check the disk - Seems to corrupt quite easily
chkdsk %target% /f /x
robocopy  %source% %target%   %file_types% /PURGE /S /R:2 /W:1
chkdsk %target% /f /x
sync -r %target%
sync -e %target%
net send %computername% "AIS - Audio INBOX synchronisation is complete. Please 'eject' the media now"
start /min sndrec32.exe /play /close %windir%\media\tada.wav
echo Done!
goto END


:ERR_NO_QS
echo WARNING: QSCDE environment has not been invoked
echo 	Please initiate the environment and try again
goto END


:HELP
echo WARNING: drive %target% does not seem to be setup for AIS (audio inbox sync)
echo 	if you really want to use this device for AIS, please rerun and specify
echo	explicitly the path to use for AIS
echo	e.g.
echo		ais f:
echo		ais c:\data\inbox2
echo		ais \\server2\audio\inbox
echo.
goto END

:END
set forced=0
title %windir%\system32\cmd.exe