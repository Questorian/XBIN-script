@echo off

:: play some music

set MUSIC_CMD=%Q_DRV_XBIN%\foobar2000\foobar2000

:: lets check the parameters here
if %1.==. goto INBOX
if %1.==inbox. goto INBOX

:INBOX
start  %MUSIC_CMD% %Q_PATH_ROOT%\_td\cache\AUDIO\music
goto END

start  %MUSIC_CMD% "\\sqsaaa03\audio\playlists\music\APL\APL - inbox.m3u"
goto END

:DESERT
start  %MUSIC_CMD% "\\sqsaaa03\audio\playlists\music\Desert Island CDs.m3u"
goto END


:END