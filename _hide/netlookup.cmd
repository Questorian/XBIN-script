REM Set up variables to use for script.
REM Begin Callout A

set dhcpdump=%temp%\dhcpdump.txt
set lookupresults=%temp%\lookupresults.txt
set winsclinput=%temp%\winscl.input

REM End Callout A
REM Grab the information from the DHCP scopes.
REM Begin Callout B
dhcpcmd 10.0.1.5 enumclients 10.0.1.0 -h > %dhcpdump%
REM End Callout B
REM Write info to results file.


echo DHCP: > %lookupresults%
echo ---- >> %lookupresults%
REM Search for line containing lookup parameter and write to
REM results file.
REM Begin Callout C
findstr -i %1 %dhcpdump% >> %lookupresults%
REM End Callout C
echo. >> %lookupresults%
REM Write info to results file for WINS.
REM Begin Callout D
echo WINS: >> %lookupresults%
echo ---- >> %lookupresults%
REM Write input file for WINS database query.
echo 1 > %winscl.input%
echo nt-netsvcsprod1 >> %winsclinput%
echo QN >> %winscl.input%
echo %1 >> %winscl.input%
echo 0 >> %winscl.input%echo EX >> %winscl.input% 
REM End Callout D
REM Query the WINS database and write to results file.
REM Begin callout E
winscl.exe < %winscl.input% | findstr -i /c:Name= /c:"Address is"
>> %lookupresults%
REM End callout E
REM Write information to results file for DNS.
echo DNS: >> %lookupresults%
echo --- >> %lookupresults%
REM Query DNS server with lookup parameter
REM and write to results file.
REM Begin Callout F
nslookup %1 >> %lookupresults%
REM End Callout F
REM Ping the parameter and write to results file.
REM Begin Callout G
if "%2"=="-p" ping %1 >> %lookupresults%
REM End Callout G
REM Print results to screen.
cls
REM Begin callout H
type %lookupresults%
REM End callout H
echo.
echo -- Note: WINS lookup only done with name, not IP
REM Clean up the files created during the script's execution.
del %dhcpdump%
del %lookupresults%
del %winscl.input%
