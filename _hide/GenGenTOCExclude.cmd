@echo off
echo %0: Generate an exclude file for the current directory
echo so thatTOCMaker.exe will not include these files into
echo the TOC file created

if exist exclude.txt del exclude.txt
dir /b > %TEMP%\exclude.txt
copy %TEMP%\exclude.txt .
start notepad exclude.txt
