rem @echo off
set REPORT=c:\temp\quote.txt
perl %Q_DRV_XBIN%\script\quote.pl > %REPORT%
notepad %REPORT%


::Print
::net use LPT1: \\NQSAAA01\NQSAAA01PR3
::copy %REPORT% PRN

:end
set REPORT=