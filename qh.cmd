@echo off
::qh.cmd - quick-help

:SETS
set qhdir=%QS_DRV_Bin%\qhelp
if %1.==. goto HELP


:: Core stuff first
if %1.==perl. (call ff %QS_DRV_Bin%\Perl\html\index.html & goto END)
if %1.==php. (start %QS_DRV_Bin%\qhelp\php_manual_en.chm & goto END)


::Switch through various help files
if exist %qhdir%\%1.txt list %qhdir%\%1.txt
if exist %qhdir%\%1.pl ed -r %qhdir%\%1.pl
if exist %qhdir%\%1.html  start %qhdir%\%1.html
if exist %qhdir%\%1.shtml start %qhdir%\%1.shtml
if exist %QS_DRV_Bin%\%1.hlp start winhelp %1
if exist %QS_DRV_Bin%\%1.chm start %QS_DRV_Bin%\%1.chm
if exist %windir%\help\%1.chm  hh %windir%\help\%1.chm
if exist "C:\Program Files\Microsoft SQL Server\80\Tools\Books\%1.chm" start hh "C:\Program Files\Microsoft SQL Server\80\Tools\Books\%1.chm"
goto END

:HELP
set PG=%TEMP%\qh.txt
echo qh: quick-help -list all the available help topics  > %PG%

echo     ---------------------------------------------- >> %PG%
echo			Help files >> %PG%
echo     ---------------------------------------------- >> %PG%
dir %qhdir% %QS_DRV_Bin%\*.hlp %windir%\help\*.hlp %windir%\help\*.chm /p /w >> %PG%

echo     ----------------------------------------------------- >> %PG%
echo		Bin Directory: installed sub-applets >> %PG%
echo     ----------------------------------------------------- >> %PG%
dir %QS_DRV_Bin% /ad /w /p >> %PG%

echo     ----------------------------------------------------- >> %PG%
echo		Bin Directory: bin >> %PG%
echo     -----------------------------------------------------  >> %PG%
dir %QS_DRV_Bin% /a-d /w /p >> %PG%
more %PG%

echo     ----------------------------------------------------- >> %PG%
echo		Bin Directory: scripts >> %PG%
echo     -----------------------------------------------------  >> %PG%
dir %QS_DRV_Bin%\scripts /a-d /w /p >> %PG%

::Optional modules that might not be there:
if exist "C:\Program Files\Microsoft SQL Server" call :ShowHelp "C:\Program Files\Microsoft SQL Server\80\Tools\Books\*.chm" "SQL Help"

goto END

:: -----------------------------------------------------------------
:: functions
:: -----------------------------------------------------------------
:ShowHelp %1 %2
echo     ---------------------------------------------- >> %PG%
echo			Help files: %2 >> %PG%
echo     ---------------------------------------------- >> %PG%
dir %1  /p /w >> %PG%
goto :eof



:END
set qhdir=
set PG=