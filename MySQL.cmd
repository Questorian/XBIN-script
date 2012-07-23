rem @echo off
::------------------------------------------------------------------------
::  - Questor Systems GmbH, http://www.QuestorSystems.com (info@QuestorSystems.com)
::------------------------------------------------------------------------
::
:: MySQL.cmd: start up the local installation of MySQL and logon a session
::
:: Project:	
:: Author:	Farley Balasuriya - (administrator@)
:: Created:	2008-05-26T10:00:22 - (Mon May 26 10:00:53 2008)
:: History:
::		v0.2 - 
::		v0.1 - 2008-05-26T10:00:22 - initial version created
::            
::------------------------------------------------------------------------
::------------------------------------------------------------------------
set svn_id=$Id: t.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
set svn_rev=$Rev: 114 $
::------------------------------------------------------------------------

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
set user=root
set pass=questor
set mysql=%Q_DRV_XBIN%\MySQL\bin

:START
if %1.==. goto START_MYSQL
if %1.==start. goto START_MYSQL
if %1.==stop. goto STOP_MYSQL


:START_MYSQL
title MySQL
::start-up MySQL Server
:: start "MySQL" /low %mysql%\mysqld-nt
start "MySQL" /low %mysql%\mysqld
pslist MySQL
: logon to the database engine with the monitor program
%mysql%\mysql --user=root  --password=questor

goto END

:STOP_MYSQL
%Q_DRV_XBIN%\MySQL\bin\mysqladmin --user=%user% --password=%pass% shutdown
goto END

:USAGE
echo usage: %0 (%svn_rev%)
echo	%0 
echo Description:
echo start up the local installation of MySQL and logon a session
goto END

:VERSION
echo filename: %0
echo svn_id: %svn_id%
echo svn_LastChangedDate: %svn_LastChangedDate%
echo svn_rev: %svn_rev%
goto END

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END