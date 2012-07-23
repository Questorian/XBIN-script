@echo off

set HM_DRV=%Q_DRV_ROOT%\
:: set HM_DRV=%Q_PATH_ROOT%

if not %1.==. goto subdir
pushd %HM_DRV%
goto end

:subdir
if %1.==eo. pushd %HM_DRV%\EO
if %1.==pack. pushd %HM_DRV%\PACK
if %1.==persona. pushd %HM_DRV%\PERSONA
if %1.==td. pushd %HM_DRV%\_td

if exist %HM_DRV%\EO\%1 pushd %HM_DRV%\EO\%1
if exist %HM_DRV%\PACK\%1 pushd %HM_DRV%\PACK\%1
if exist %HM_DRV%\_td\%1 pushd %HM_DRV%\_td\%1

:end