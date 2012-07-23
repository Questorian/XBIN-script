@echo off
:: Quickly sync the CF-Card from the server

D:\SHRDATA\PROD\PROJECTS\BIN\RKTools\robocopy \\sqsaaa01\Audio\inbox  f:\  /MIR /R:3 /W:1
