@echo off
if not exist e:\shrdata goto ERR
if not exist e:\shrdata\dev goto ERR
if not exist e:\shrdata\prod goto ERR
robocopy  \\sqsaaa01\shrdata E:\SHRDATA /MIR /W:2 /R:3
goto END

:ERR
echo e:\ is probably not the XFER-HDD drive letter.
echo Please try again.

:END