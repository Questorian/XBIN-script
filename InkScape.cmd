@echo off
::------------------------------------------------------------------------
:: InkScape.cmd
::------------------------------------------------------------------------
::
:: InkScape.cmd: whatever
::
:: Project:	
:: Author:	Farley Balasuriya (developer@QuestorSystems.com)
:: Created:	2008-06-24T17:49:34
:: History:
::		v0.2 - 
::		v0.1 - 2008-06-24 - initial version created
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
set T_INKSCAPE_DIR=%Q_DRV_XBIN%\inkscape

:START
pushd %T_INKSCAPE_DIR%
if not exist inkscape.exe goto ERR1
start inkscape.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
goto END


:USAGE
echo usage: %0 (%svn_rev%)
echo	%0 
echo Description:
echo {$description}
goto END

:VERSION
echo filename: %0
echo svn_id: %svn_id%
echo svn_LastChangedDate: %svn_LastChangedDate%
echo svn_rev: %svn_rev%
goto END

:ERR1
echo %0: Err1: Inscape.exe not found in directory - %T_INKSCAPE_DIR%
echo please check your installation
goto END

:ERR2
echo %0: Err2:
goto END

:END
set T_INKSCAPE_DIR=