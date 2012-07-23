rem @echo off
set PATH=%Q_DRV_XBIN%\vCLI\perl\site\bin;%Q_DRV_XBIN%\vCLI\perl\bin;%PATH%
title vCLI
:: C:\Windows\SysWOW64\cmd.exe /K ""C:\Program Files (x86)\VMware\VMware vSphere CLI\bin\vcli.bat" "C:\Program Files (x86)\VMware\VMware vSphere CLI\perl\bin" "C:\Program Files (x86)\VMware\VMware vSphere CLI\bin""
C:\Windows\SysWOW64\cmd.exe /K ""%Q_DRV_XBIN%\vCLI\bin\vcli.bat" "%Q_DRV_XBIN%\vCLI\perl\bin" "%Q_DRV_XBIN%\vCLI\bin""

prompt [vCLI] $p$g
