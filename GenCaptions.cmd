@echo off


:PROCESS_DIR
echo. > header.txt
echo. > footer.txt
for  %%f in (*.jpg) do echo %%f	%%f >> captions.txt
if %1.==--f. (for  %%F in (*.jpg) do echo.	>> %%~nF.txt)
call ed header.txt footer.txt captions.txt