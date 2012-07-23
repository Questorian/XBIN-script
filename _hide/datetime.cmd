for /f "tokens=1,2,3* delims=.:/- " %%i in ('date /t') do (
 for /f "skip=1 tokens=2-4 delims=/-,()." %%x in ('echo.^|date') do (
 set %%x=%%i&set %%y=%%j&set yyyy=%%k))

for /f "tokens=1,2* delims=: " %%i in ('time /t') do (
  set hh=%%i&set min=%%j )

