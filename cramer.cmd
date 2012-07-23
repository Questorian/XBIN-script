@echo off
if %1.==. goto HELP
start "c:\Program Files\Windows Media Player\wmplayer.exe" http://www.thestreet.com/audiowaxgen/waxFile.jsp?clip=cramer%1.wax
rem perl -e "$date = sprintf \"%02s%02s%02s \", (localtime)[4]+1, (localtime)[3]-1, (localtime)[5]-100";
goto END

:HELP
echo %0 date
echo where date is of format - mmddyyyy