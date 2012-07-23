@echo off

set VPN_HOST=10.8.0.1
set VML_HOST1=192.168.219.23
set VML_HOST2=192.168.219.24
set VML1_MAC=00:1B:21:60:14:7B
set VML2_MAC=00:1B:21:A3:61:B2

if %1.==. goto err2
if %1.==1. goto wake1
if %1.==2. goto wake2
goto err2

:check_vml
::check that we are actually connected to QNET VML
ping -n 1 %VPN_HOST%
if errorlevel 1 goto err1

:wake1
@wakeonlan %VML1_MAC%
ping -n 120 %VML1_HOST%
goto end


:wake2
@wakeonlan %VML2_MAC%
ping -n 120 %VML2_HOST%
goto end

:err1
echo %0: cannot ping %VPN_HOST% (QNet VPN server)
echo are you sure that you are connected to QNET over VPN?
echo tip: if you are on the QNet localy use the '-local' option
goto end

:err2
echo %0: error: unsupported parameter: %1

:usage
echo %0 vmlhost (1 or 2)
echo eg
echo %0 2 - boot VML host 2a

:end