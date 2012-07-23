@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: qbkup.cmd: Quick backup of FF bookmarks, Outlook PST file, and Password safe PWS file
::             And other valuable files too
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Mon Jun 27 16:08:45 2005
:: History:
::		v0.2 - 
::		v0.1 - 27/06/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
::-----------------------------------------------------------------
::  ___                  _               ____            _
:: / _ \ _   _  ___  ___| |_ ___  _ __  / ___| _   _ ___| |_ ___ _ __ ___  ___
::| | | | | | |/ _ \/ __| __/ _ \| '__| \___ \| | | / __| __/ _ \ '_ ` _ \/ __|
::| |_| | |_| |  __/\__ \ || (_) | |     ___) | |_| \__ \ ||  __/ | | | | \__ \
:: \__\_\\__,_|\___||___/\__\___/|_|    |____/ \__, |___/\__\___|_| |_| |_|___/
::                                             |___/
::
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
::-----------------------------------------------------------------

:QSCDEInit
if not %QS_Init%.==1. call QSCDE

:ARGS
if  %1.==-h. goto USAGE
if  %1.==-H. goto USAGE
if  %1.==-?. goto USAGE
if  %1.==--help. goto USAGE
if  %1.==--HELP. goto USAGE
if  %1.==-v goto VERSION
if  %1.==-V goto VERSION
if  %1.==--version goto VERSION
if  %1.==--VERSION goto VERSION
:: if  %1.==. goto USAGE

:SETS
:: 
set TARGET=\\%QS_ResourceServer%\INBOX\MISC\_bkup

:START
::Outlook check - make sure that it is not running
pstat |  find /i "outlook"  > nul
if errorlevel 1 goto NEXT
goto ERR1
:NEXT
:: OK is not running so we can now backup the PST file
echo backing up: PST file
if exist %TARGET%\QSContax.pst del %TARGET%\QSContax.pst
copy P:\usr\outlook\QSContax.pst %TARGET%

::FireFox Bookmarks
:FF
echo backing up: bookmark file
if exist %TARGET%\bookmarks.html del %TARGET%\bookmarks.html 
copy "%APPDATA%\Mozilla\Firefox\Profiles\mz45nbh0.default\bookmarks.html" %TARGET%

:: Password Safe file  - make a nice copy
echo backing up: Password Safe file
if exist %TARGET%\pwsdata.dat  del %TARGET%\pwsdata.dat
copy P:\usr\QS_MasterMachineName\DataSafe\PWSData.dat %TARGET%

echo %TARGET%
echo ----------------
dir %TARGET%

echo All done!
echo Plese ensure that %TARGET% is bunred onto DVD/CD archive storrrage!


goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Quick backup of FF bookmarks, Outlook PST file, and Password safe PWS file
goto END

:VERSION
echo filename: %0
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: Outlook is running. Not possible to  back-up PST while it is running
echo Please quite Outlook and try again.
goto END

:ERR2
echo %0: Err2:
goto END

:END