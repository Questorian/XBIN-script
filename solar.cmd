@echo off

:: Play solar radio man!

set Solar="http://www.txradica.net/tune.php?c=solar2&.wvx"

start "%ProgramFiles%\windows Media Player\wmplayer.exe"  %solar%
rem start %QS_DRV_Bin%\winamp\winamp %solar%
