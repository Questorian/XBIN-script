@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: dbbkup.cmd: MS SQL Generic database backup script. Dumps passed database
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Thu Apr 28 01:10:11 2005
:: History:
::		v0.2 - 
::		v0.1 - 28/04/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
::-----------------------------------------------------------------
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
if  %1.==. goto USAGE

:SETS
if not %2.==. (set host=%1&& set db=%2)
if %2.==. (set host=%computername%&&set db=%1&& echo WARNING: Assuming current machine as host: %computername%)
set log=%QS_PATH_LLog%\dbbkup.log
set logt=%QS_PATH_LLog%\dbbkup-last.log
set fname=%QS_PATH_SQL_BKUP%\dbbkup-%host%-%db%-%date%.bak

:START
echo. > %logt%
echo *** %date%-%time%: \\%host%-%db%  operator:(%username%@%userdnsdomain%) >> %logt%

:phase1
echo phase 1: dbcc checkdb
echo phase 1: dbcc checkdb >> %logt%
osql -E -S %host% -d %db% -w 200 -Q "dbcc checkdb"  >> %logt%
find /i "CHECKDB found 0 allocation errors and 0 consistency errors in database '%db%'."  %logt% > nul
if errorlevel 1 goto ERR1

:phase2
echo phase 2: dbcc checkcatalog
echo phase 2: dbcc checkcatalog >> %logt%
osql -E -S %host% -d %db% -w 200 -Q "dbcc checkcatalog" >> %logt%
rem checks go here..

:phase3
echo phase 3: dbcc newalloc
echo phase 3: dbcc newalloc >> %logt%
osql -E -S %host% -d %db% -w 200 -Q "dbcc newalloc" >> %logt%
find /i "CHECKALLOC found 0 allocation errors and 0 consistency errors in database '%db%'."  %logt% > nul
if errorlevel 1 goto ERR3
rem 

:phase4
echo phase 4: backup database %db% to disk = '%fname%'
echo phase 4: backup database %db% to disk = '%fname%' >> %logt%
osql -E -S %host% -w 200 -Q "backup database %db% to disk = '%fname%'" >> %logt%
find "BACKUP DATABASE successfully processed"  %logt% > nul
if errorlevel 1 goto ERR3

:phase5
echo phase 5: check hosts database records in msdb.bkupset
rem  >> %logt%
osql -E -S %host% -d msdb -w 2000 -Q "select database_name, user_name, backup_start_date, backup_finish_date, database_creation_date from backupset where (database_name = '%db%') and (datediff(dd, backup_start_date, getdate()) < 1)"
echo 
goto END


:USAGE
echo usage: %0, %svn_rev%
echo.
echo	%0 [host] [database_to_be_dumped]
echo or
echo	%0 [database_to_be_dumped]
echo		if database is on this host
echo.
echo Description:
echo.
echo MS SQL Generic database backup script. Dumps passed database
echo.
echo note: You must have a trusted connection to the host for this
echo script to work.  You can map a drive and create an access token
echo to the server before running the script
goto END

:VERSION
echo filename: %0
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: dbcc checkdb check failed
pause
type %logt%
goto END

:ERR2
echo %0: Err2:
goto END

:ERR3
echo %0: Err3: dbcc check/newalloc failed
pause
type %logt%
goto END

:ERR4
echo %0: Err4: backup database failed
pause
type %logt%
goto END

:END
if exist %logt% type %logt% >> %log%
set log=
set logt=
set db=
set host=
set fname=