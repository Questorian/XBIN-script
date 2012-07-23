@echo off

:: http://gearbox.maem.umr.edu/batch/nt.specific.html

 if %1!==! goto end
 if %1!==}{! goto pass2
 dir %1\*.* /b /a:-d /o:n /s > %temp%\}{.dat
 set count=0
 for /F "tokens=*" %%a in (%temp%\}{.dat) do call %0 }{ "%%a"
 del %temp%\}{.dat
 goto end
 :pass2
 set /a count+=1
 set fname=%count%.txt
 if %count% LSS 1000 set fname=0%count%.txt
 if %count% LSS 100 set fname=00%count%.txt
 if %count% LSS 10 set fname=000%count%.txt
 ren %2 %fname%
 :end
