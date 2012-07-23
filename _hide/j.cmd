@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: j.cmd: journal - Call the system journal utitlity to record and make notes
::
:: Project:	
:: Author:	Farley Balasuriya
::		(qs10001@QUESTOR.INTRA)
:: Created:	Mon Apr 25 15:00:32 2005
:: History:
::		v0.2 - 
::		v0.1 - 25/04/05 - initial version created
::            
::-----------------------------------------------------------------
set svn_rev=$Rev: 114 $
set svn_id=$Id: j.cmd 114 2005-04-25 13:59:09Z farley $
set svn_LastChangedDate=$LastChangedDate: 2005-04-25 15:59:09 +0200 (Mon, 25 Apr 2005) $
::-----------------------------------------------------------------
:: Questor Sytesms GmbH, Basel, CH-4053, Schweiz
:: http://www.questor.ch,  mailto:tools@questor.ch
::-----------------------------------------------------------------

:QSCDEInit
:: if not %QS_Init%.==1. call QSCDE


:SETS
:: The default journal to use if none was specified on command line
set _DEF_JOURNAL=FJB

:ARGS
if %1.==. (set Q_EO=%_DEF_JOURNAL%) ELSE (set Q_EO=%1)
set _JRNL=%Q_PATH_ROOT%\EO\%Q_EO%\data\docs\documentation\journals\%Q_EO%.txt
if not exist %_JRNL% goto ERR1


:START
call ed %_JRNL%
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo journal - Call the system journal utitlity to record and make notes
goto END

:VERSION
echo filename: %0
echo $Id: j.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: unable to find journal %_JRNL%. Please check and try again.
goto END

:ERR2
echo %0: Err2:
goto END

:END
set Q_EO=
set _DEF_JOURNAL=
set _JRNL=