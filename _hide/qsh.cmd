@echo off

if %1.==. goto default



:default
call ed %Q_DRV_XBIN%\qsh\qsh.txt
goto end



:end