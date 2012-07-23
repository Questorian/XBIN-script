@echo off
::@(#)="add Git XBIN path to the current shell path"

echo adding Git to PATH

::set the HOME variable - used by many tings - not just ssh
if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
if not exist "%HOME%" @set HOME=%USERPROFILE%

:: Set the LANG variable that will be used by gitk GitGUI
set LANG=en_US


::add to end of PATH variable
set PATH=%PATH%;%Q_DRV_XBIN%\git\cmd;%Q_DRV_XBIN%\git\bin
