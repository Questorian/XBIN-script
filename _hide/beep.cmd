@echo off

set count=1

if not "%1"=="" set /a count=%1
:start
echo 
set /a count=%count% - 1
if %count% gtr 0 goto start
