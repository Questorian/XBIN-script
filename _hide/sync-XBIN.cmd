:: @echo off
:: $Id$
:: What: PACK-XBIN sync tool to keep XBIN REFERENCE and REPLICAS up to date

:check
if %1.==. goto err1


:sets
set Q_REFERENCE=LQSAAA06

if %COMPUTERNAME%.==%Q_REFERENCE%. goto REFERENCE

:TARGET
::This is not the REFERENCE machine
::therefore we can only import from PACK-XBIN


:REFERENCE
::This is the REFERENCE
::outbound copying only from here to XBIN replica
echo %Q_REFERENCE%: This is the REFERENCE machine
echo will copy files from here to target as source
set source=v:\
set target=%1

:goto start
:: make a few SANITY checks first
if not exist %source%\xbin\xbin.cmd goto err2


:copy
robocopy %source% %target%\PACK-XBIN /MIR /R:2 /W:3 /xd d:\$RECYCLE.BIN
goto end


:err1
echo %0: err1 - target drive must specified on command line
goto end

:err2
echo %0: err2 - source drive %source% does not seem correct
goto end


:end
