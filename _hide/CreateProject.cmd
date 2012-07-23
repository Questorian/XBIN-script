@echo off
::------------------------------------------------------------------------
:: Questor - Questor Systems GmbH
::------------------------------------------------------------------------
::
:: v:\scripts\CreateProject.cmd: Create a new project directory, with relevant directory strucutres and blank templae files
::
:: Project:	
:: Author:	Farley Balasuriya - (farley@questor.ch)
:: Created:	2007-02-26T21:18:53 - (Mon Feb 26 21:19:48 2007)
:: History:
::		v0.2 - 
::		v0.1 - 2007-02-26T21:18:53 - initial version created
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
if  %1.==. goto USAGE

:SETS
set SVN_WORKING_DIR=D:\QS\_td\Workspace
set pjournal=%1-journal.txt
:START
pushd %SVN_WORKING_DIR%
if exist %1 goto err1
md %1
cd %1
md trunk
md branches
md tags
echo .LOG > %pjournal%
call TimeStamp - Project created. >> %pjournal%
cd trunk
:: now we check if it is a Perl Project
if %2.==-pm. goto PERLMODULE
if %2.==-p. goto PERLSCRIPT
goto END
:PERLMODULE
set MODULE_STARTER_DIR=v:\_data\.module-starter
call module-starter --module=%1
echo project '%1' created. You should now import this project into your select SVN repository.
goto END
:PERLSCRIPT
new %1.pl
goto END

:USAGE
echo usage: %0 (%svn_rev%)
echo	%0 new_project_name
echo.
echo Description:
echo Create a new project directory, with relevant directory strucutres and blank templae files
echo note: New project will be created with a SVN project tree directory structure:
echo.
echo new_project_name
echo            - branch
echo            - tags
echo            - trunk
goto END

:VERSION
echo filename: %0
echo svn_id: %svn_id%
echo svn_LastChangedDate: %svn_LastChangedDate%
echo svn_rev: %svn_rev%
goto END

:ERR1
echo %0: Err1: %1 project already exists!

goto END

:ERR2
echo %0: Err2:
goto END

:END
set SVN_WORKING_DIR=
set pjournal=