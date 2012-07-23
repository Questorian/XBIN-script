@echo off
setlocal

REM ##############################
REM WINDOWS-VERSION PRÜFEN
;
if not "%os%"=="Windows_NT" goto Hilfe
ver | find "NT" >nul
if not errorlevel 1 goto Hilfe

REM ##############################
REM HILFE ERWUENSCHT?
;
if "%1"=="" goto Hilfe
if %1=="/?" goto Hilfe
if %1=="-h" goto Hilfe
if %1=="--h" goto Hilfe

REM ##############################
REM WINDIFF VORHANDEN?
;
windiff nul nul -Sx nul 2>nul
if errorlevel 1 (
  echo Windiff nicht gefunden, bitte nachinstallieren!
  echo Weitere Infos in c't 16/03, S.146
  exit /b
)

REM ##############################
REM IST ÜBERHAUPT WAS ZU KOPIEREN?
;
dir /s /b /a-d %1 >nul 2>nul
if errorlevel 1 ( 
  echo Kann nichts zum Kopieren finden!
  exit /b
)

REM ##############################
REM VARIABLEN SETZEN
;
set Templog="%temp%\vcopy.log"
set Quelle=%1
if %Quelle:~-1%=="\" set Quelle=%Quelle:~0,-1%
shift
Set Ziel=%1

REM ##############################
REM AUSWERTEN DER PARAMETER
;
set Parameter=
:Sammeln
shift
if "%1"=="" goto Kopieren
set Parameter=%Parameter% %1
goto Sammeln

REM ##############################
REM KOPIEREN DER DATEIEN
;
:Kopieren
xcopy %Quelle% %ziel% %Parameter%

REM ##############################
REM WINDIFF KANN DATEIEN NICHT MIT ORDNERN VERGLEICHEN, DESHALB GEGEBENFALLS ANPASSEN VON %ZIEL%
;
if exist %Quelle%\nul if exist %Ziel%\nul goto Weiter
if not exist %Quelle%\nul if not exist %Ziel%\nul goto Weiter
if not exist %Quelle%\nul if exist %Ziel%\nul goto DatOrd
echo.
echo Sorry, Vergleich nicht moeglich.
echo.
echo Bei einer Kopie eines Ordners in eine Datei entstehen
echo keine durch Windiff vergleichbaren Kopien.
echo.
echo Weitere Infos in c't 16/03, S. 146
echo.
exit /b
;
:DatOrd
set Quelltemp=%Quelle%
:Anpassen
echo %Quelltemp% | find "\"
if errorlevel 1 (
  set Ziel=%Ziel%\%Quelltemp%
  goto Weiter
)
set Quelltemp=%Quelltemp:~1%
goto Anpassen
:Weiter

REM ##############################
REM DER VERGLEICH
;
start /w windiff.exe -Sdx %Templog% -T %Quelle% %Ziel%

REM ##############################
REM ANZAHL DER AUFGETRETENEN FEHLER ERRECHNEN
;
for /f "usebackq delims=?" %%a in (`find /c "different" %Templog%`) do set Verify=%%a 
for %%a in (%Verify%) do set Verify=%%a

REM ##############################
REM AUSGABE DES ERGBEBNISSES UND BEI BEDARF ANZEIGE DER TEMPLOG
;
echo Gefundene Fehler: %Verify%
if %Verify% gtr 0 (
  type %Templog%
  exit /b
)
del %templog%
exit /b

REM ##############################
REM HILFE
;
:Hilfe
echo.
echo Kopiert Dateien und Verzeichnisse mittels Xcopy und vergleicht 
echo anschliessend mit Windiff (siehe c't 16/03, S.146)
echo.
echo %~nx0 funktioniert nur unter Windows 2000 und XP!
echo.
echo Aufruf durch "%0 Quelle Ziel [Parameter]"
echo Die Parameter sind mit denen von Xcopy identisch. 
echo.
echo Einschraenkungen:
echo 1. Pfadangaben duerfen keine Leerzeichen enthalten
echo 2. Pfadangaben wie c:boot.ini (also ohne Backslash) sind nicht gestattet
echo.
echo Taste druecken zum Lesen der Xcopy-Hilfe:
pause >nul
xcopy /?

REM Erstellt 2003 von Axel Vahldiek / c't
REM mailto: axv@ctmagazin.de
