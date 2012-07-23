@echo off 
cls
setlocal
set startwert=1000
echo Finden Sie eine Zahl zwischen 0 und %startwert%!
set versuche=
set /a ziel=%random%%%%startwert%
:Start
set /a Versuche=%versuche%+1
set /p eingabe=Bitte Zahl eintippen: 
if %ziel% gtr %eingabe% (
  echo zu klein!
  goto start
)
if %ziel% lss %eingabe% (
  echo zu gross!
  goto start
)
echo Treffer! Sie haben %versuche% Versuche benoetigt.



