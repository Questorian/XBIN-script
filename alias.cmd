@echo off
if %1.==-e. goto edit
if %1.==e. goto edit
if %1.==-E. goto edit
if %1.==E. goto edit

:start
doskey /listsize=1000 /macrofile=%Q_DRV_XBIN%\_data\alias.txt
goto end

:edit
call ed %Q_DRV_XBIN%\_data\alias.txt

:end