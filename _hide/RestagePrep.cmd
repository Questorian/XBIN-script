@echo  off

set TDIR=c:\TEMP\_saveinfo_%computername%
set fname=%tdir%\%computername%-config.txt
set fname2=%tdir%\%computername%-config-winmsd.txt

echo making directory structure...
:: Make the standard directory structure
if not exist c:\TEMP md c:\TEMP
if not exist %tdir% md %tdir%
if not exist %tdir%\Hardware md %tdir%\Hardware
if not exist %tdir%\Data md %tdir%\Data
if not exist %tdir%\Apps md %tdir%\Apps
if not exist %tdir%\Settings md %tdir%\Settings


::save configuration information
echo Saving System Configuration information
net share > %fname%
ipconfig /all >> %fname%
net user >> %fname%
winmsd /category +all /report %fname2%
echo finished!
echo Note: You may have to wait some time for the WinMSD report to finish 
echo writing it's output to the file %fname2%