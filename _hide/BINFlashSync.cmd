@echo off
set src=d:\bin
set trg=v:\

if not %computername%.==WQSAAA01. goto ERR1
if not exist %src%\cmdhere.inf goto ERR2
if not exist %trg%\cmdhere.inf goto ERR3
robocopy %src% %trg% /MIR /W:2 /R:2 /xd srvbin
goto END
:ERR1
echo This is not the main QS PC.
echo You can only run this script from machine WQSAAA01
goto END
:ERR2
echo %src% path does not appear to be the master source bin.
echo Please check the USB drive allocation and check that it matches
echo the drive path.  If not this could seriously screw up the BIN 
echo directory!
goto END
echo %trg% path does not appear to be the server target bin.
echo Please check the remote drive allocation and check that it matches
echo the drive path.  If not this could seriously screw up the BIN 
echo directory!
goto END

:END