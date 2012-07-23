@echo off
setlocal

REM ##############################
REM WINDOWS-VERSION PRÜFEN
;
if not "%os%"=="Windows_NT" goto Hilfe
ver | find "NT" >nul
if not errorlevel 1 goto Hilfe

REM #######################
REM HILFE NÖTIG?
;
if /i not "%1"=="um" if not "%1"=="in" goto Hilfe
if "%2"=="" goto Hilfe

REM #######################
REM Weckzeit errechnen
;
set Eingabe=%2
if "%Eingabe:~4,1%"=="" goto Hilfe
set /a Weckzeit=(%Eingabe:~0,1%*600)+(%Eingabe:~1,1%*60)+(%Eingabe:~3,1%*10)+(%Eingabe:~4,1%)
set Zeit=%time%
if /i "%1"=="in" set /a Weckzeit=%Weckzeit%+(%Zeit:~0,2%*60)+(%Zeit:~3,1%*10)+(%Zeit:~4,1%)

REM #######################
REM WECKZEIT WIEDER IN STUNDEN UND MINUTEN UMRECHNEN
;
set /a Stunde="(Weckzeit / 60) %% 24"
set /a Minute="Weckzeit %% 60"

REM #######################
REM KOMMENTAR ERSTELLEN
;
set Kommentar=
if "%~3"=="" set Kommentar=Aufstehen
:Sammeln
set Kommentar=%Kommentar% %~3
shift
if not "%3"=="" goto Sammeln

REM #######################
REM WECKAUFTRAG ERSTELLEN
;
at %Stunde%:%Minute% /interactive cmd /c "start /min sndrec32.exe /play /close %windir%\Media\tada.wav & net send %computername% %Kommentar:~0,100%"

REM #######################
REM ALTERNATIVER WECKAUFTRAG, HÄSSLICHER, SETZT ABER KEINEN AKTIVIERTEN NACHRICHTENDIENST VORAUS
;
REM at %Stunde%:%Minute% /interactive cmd /t:e0 /k "mode 102,3 & start /min sndrec32.exe /play /close %windir%\Media\tada.wav & cls & echo. & echo %Kommentar:~0,100% & Pause >nul"


REM #######################
REM NOCH EIN ALTERNATIVER WECKAUFTRAG, KLAPPT AUCH OHNE SERVICE PACK
;
REM echo cmd /t:e0 /k "del %TEMP%\wecken%Stunde%%Minute%.bat & mode 102,3 & start /min sndrec32.exe /play /close %windir%\Media\tada.wav & cls & echo. & echo %Kommentar:~0,100% & Pause >nul" >%TEMP%\wecken%Stunde%%Minute%.bat


REM #######################
REM RAUS
;
set Stunde=0%Stunde%
set Minute=0%Minute%
echo Er wird um %Stunde:~-2%:%Minute:~-2% ausgefuehrt
exit /b

REM #######################
REM HILFE
:Hilfe
echo.
echo Die %~nx0 laesst sich auf zwei Arten aufrufen:
echo.
echo %~n0 um xx:xx [Kommentar]
echo (weckt um xx:xx Uhr)
echo.
echo oder
echo.
echo %~n0 in xx:xx [Kommentar]
echo (weckt in xx:xx Stunden)
echo.
echo Die Zeitangabe muss im Format xx:xx erfolgen
echo Beispiele: 10:30, 07:15
echo Zeitangaben ueber 24 Stunden sind ungueltig
echo.
echo Der Kommentar ist optional
echo.
echo %~nx0 funktioniert nur unter Windows 2000 und XP!
echo.





