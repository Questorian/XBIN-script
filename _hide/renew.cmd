@echo off
ipconfig /release
sleep 1
ipconfig /renew
call inetcheck
call getextip