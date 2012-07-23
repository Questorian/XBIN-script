@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: ppmpack.cmd: Add or remove the standard selection of packages from our 'prefered' location
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Tue Apr 26 16:55:58 2005
:: History:
::		v0.2 - 
::		v0.1 - 26/04/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 116 $
set svn_id=$Id: ppmpack.cmd 116 2005-04-26 15:34:17Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-26 17:34:17 +0200 (Tue, 26 Apr 2005) $
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
::-----------------------------------------------------------------

:QSCDEInit
if not %QS_Init%.==1. call QSCDE

set repository=%QS_DRV_Bin%\installers\ppm
set repository_url=http://www.questor.ch/html/bkup/ppm


:ARGS
if  %1.==-h. goto USAGE
if  %1.==-H. goto USAGE
if  %1.==-?. goto USAGE
if  %1.==--help. goto USAGE
if  %1.==--HELP. goto USAGE
if  %1.==-v. goto VERSION
if  %1.==-V. goto VERSION
if  %1.==--version. goto VERSION
if  %1.==--VERSION. goto VERSION
if  %1.==. goto USAGE
if %1.==-install. goto SETS
if %1.==-INSTALL. goto SETS
if %1.==-remove. goto SETS
if %1.==-REMOVE. goto SETS
goto USAGE

:SETS
if %1.==-remove. goto REMOVE
if %1.==-REMOVE. goto REMOVE

:START
call ppm repository off ActiveState Package Repository
call ppm repository off ActiveState PPM2 Repository
call ppm repository add bin %repository%
call ppm repository add QS_INTERNET %repository_url%
echo Installing following Perl packages found on repoitory: %repository%
dir /b %repository%\*.ppd
for  %%F in (%repository%\*.ppd) do (call ppm install %%~nF)
call ppm repository on ActiveState Package Repository
call ppm repository on ActiveState ppm2 Repository
echo %0: newly installed packages...
call ppm query * 
echo calling test script (may not work if there is no Audiotron on the LAN!)
perl %repository%\test.pl
goto END


:REMOVE
echo Removing following Perl packages found on repoitory: %repository%
dir /b %repository%\*.ppd
for  %%F in (%repository%\*.ppd) do (call ppm remove %%~nF)
goto END

:USAGE
echo usage: %0, %svn_rev%
echo	%0 -install add all the packages in the current repository
echo	%0 -remove  remove all the packages in the current repository
echo ----------------------------------------------------------------
echo Packages currently in repository: (%repository%)
echo (internet backup: %repository_url%)
dir %repository%\*.ppd /b
echo ----------------------------------------------------------------
echo Description:
echo Add or remove the standard selection of packages from our 'prefered' location
echo You can add extra packages to the repository at any time.
echo simply download the ZIP files from ActiveState.com, unzip and copy 
echo PPD file into the PPM directory and the gzip file goes into the
echo MSWin32-x86-multi-thread-5.8 suddirectory.
echo This script will simply install/deinstall all that are found in this
echo directory.
goto END

:VERSION
echo filename: %0
echo $Id: ppmpack.cmd 116 2005-04-26 15:34:17Z farley $
echo $Rev: 116 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END