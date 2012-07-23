@echo off

:: TBD 
:: check that user is an administrator (or elevated priveledges)
:: put the check in a CMD library file?
:: run the defrag - properly

if %Q_PATH_ROOT%.==. goto err1

set source=%Q_PATH_ROOT%
set target=\\nqsaaa01\SHRDATA\PROD\PROJECTS\BKUP\_sys\%computername%\_data
::set target=\\sqsaaa03\bkup\_sys\%computername%\_data

set USB_DIR1=k:\_bkup\%COMPUTERNAME%
set USB_DIR2=j:\_bkup\%COMPUTERNAME%

:: goto usb-bkup1

::checks
if not exist %target% (echo WARNING: the destination %target% does not exist - Is this correct? && pause)
if %Q_DRV_FLASH_USB%.==. (echo WARNING: the QSCDE parameter drive Q_DRV_FLASH_USB is not set  && pause)
if %Q_DRV_FLASH_USB%.==. goto flash-bkup
if not exist %Q_DRV_FLASH_USB%\PACK-XBIN (echo WARNING: there does not seem to be an existing backup of PACK-XBIN on %Q_DRV_FLASH_USB% && pause)

:: check the USB stick is ready - both backups at once
:: A small backup of just PACK-XBIN
:flash-bkup
title %0 - flash backup
if not exist %Q_DRV_FLASH_USB%\PACK-XBIN goto srv-bkup
echo backing up PACK-XBIN to %Q_DRV_FLASH_USB%\PACK-XBIN 
robocopy %source%\PACK\PACK-XBIN  %Q_DRV_FLASH_USB%\PACK-XBIN /MIR /R:2 /W:1


:: start the backup
:srv-bkup
if not exist %target%  goto usb-bkup1
title %0 - server backup
:: take a backup of all the journals
journal -backup
:: House-keeping tasks  - dump all the databases
osql -E -d DBA -Q"exec dbo.dumpAll"
robocopy %source% %target% /MIR /R:2 /W:1 /FFT



:: try the backup to the USB drive-1 as well
:usb-bkup1
if not exist %USB_DIR1% goto usb-bkup2
robocopy %source% %USB_DIR1% /MIR /R:2 /W:1


:: try the backup to the USB drive-2 as well
:usb-bkup2
if not exist %USB_DIR2% goto defrag
robocopy %source% %USB_DIR2% /MIR /R:2 /W:1



:: Defrag the disks
:defrag
defrag C:
Defrag D:
goto end


:err1
echo error: the variable %Q_PATH_ROOT% is not set - No backup can be made
echo is this a QSCDE client?
goto end

:end
set target=
set source=
title 