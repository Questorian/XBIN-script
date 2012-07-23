@echo off

:: what: sync PACK-XBIN onto the USB key to ensure that it is uptodate
:: tag: xbin 

if %1.==. goto err4

:sets
set Q_REFERENCE_HOST=LQSAAA06
set Q_PATH_XBIN=%Q_PATH_ROOT%\PACK\PACK-XBIN
set target=%1

if %computername%.==%Q_REFERENCE_HOST%. goto checks
goto end


:checks
if not exist %Q_PATH_XBIN%\_data\ini\Questor.ini goto err2
if not exist %target%\PACK-XBIN\_data\ini\Questor.ini goto err3



:start
call timestamp starting PACK-XBIN sync 
robocopy %Q_PATH_XBIN% %target%\PACK-XBIN /MIR /R:2 /w:3
goto end



:err1
echo %0: This is not the MASTER reference machine!
echo this script can only be run from machine: %Q_REFERENCE_HOST%
goto end


:err2
echo %0: err2: source directory unreadable: %Q_PATH_XBIN%\_data\ini\Questor.ini 
goto end


:err3
echo %0: err3: target directory unreadable: %target%\PACK-XBIN\_data\ini\Questor.ini 
echo are you sure that this is the PACK-XBIN USB thumb drive letter?
echo please check and try again
goto end


:err4
echo %0: err4: missing command line parameter - specify destingation drive letter
echo e.g %0 e:
echo e.g %0 k:
goto end


:end