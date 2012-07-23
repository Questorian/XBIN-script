rem @echo off
set queue=%Q_DRV_XBIN%\_data\Q\%1.txt
if not exist %queue% goto missing

:start
call ed %queue%
goto end

:missing
echo error: no such queue %1 ((%queue% file does not exist)

:end