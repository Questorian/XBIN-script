@echo off
set FNAME=%TEMP%\dasquery.txt
echo ---- new query: %1  ---
perl -n -e "if (/%1/i) {print };"  %QS_SHR_AUDIO%\Catalog_MUSIC.txt  > %FNAME%
if %2.==-e. goto EXTENDED
type %FNAME% | more
goto END
:EXTENDED
for /F  "delims=;" %%a in (%FNAME%) DO dir "%%a" | findstr "%%a"
:END
echo -----------------------