@echo off
:: restart.cmd: Restart various Windows services
:: farley@questor.ch, v0.1, 2005-06-25T11:34:22

:start
if %1.==. goto end
net stop %1
net start %1
shift

:end