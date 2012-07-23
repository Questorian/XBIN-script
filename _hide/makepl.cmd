@echo off
echo GenPL: Generate Play List
echo add current directory to current playlist file and optionally (-e) load into notepad
set PLFILE=%TEMP%\NewPL.m3u
dir /b /s *.* >> %PLFILE%
rem now convert the path to a UNC version
call sar D:\\SHRDATA\\prod\\PROJECTS \\\\SQSAAA01 %PLFILE% > %PLFILE%1
type %PLFILE%1 
type %PLFILE%1 > %PLFILE%
del %PLFILE%1
if %1.==-e. notepad %PLFILE%

