@echo off

::-----------------------------------------------------------------
:: QUESTOR - Questor Systems GmbH, http://www.questor.ch (info@questor.ch)
::-----------------------------------------------------------------
::
:: PlaySound.cmd: Play a sound thorught the system for some event or other. Looks in well known places for the sound to be played.
::
:: Project:	
:: Author:	Farley Balasuriya
::		(QSSysAdm@)
:: Created:	Sat Apr 30 12:26:27 2005
:: History:
::		v0.2 - 
::		v0.1 - 30/04/05 - initial version created
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

:SETS

:START
@echo off
if %1.==. set SOUND=%windir%\Media\TADA.wav & goto PLAY:
rem really try and find that sound file
if exist c:\qscde\data\bin\media\%1.wav set SOUND=c:\qscde\data\bin\media\%1.wav
if exist %QS_DRV_Bin%\media\%1.wav set SOUND=%QS_DRV_Bin%\media\%1.wav
if exist %windir%\Media\%1.wav set SOUND=%windir%\Media\%1.wav
if %SOUND%.==. set SOUND=%windir%\Media\TADA.wav
:PLAY
start /min sndrec32.exe /play /close %SOUND%
goto END


:USAGE
echo usage: %0, %svn_rev%
echo	%0 
echo Description:
echo Play a sound thorught the system for some event or other. Looks in well known places for the sound to be played.
echo play an alert sound either from the windows\media directory or from the BIN\media dir
echo specify sound file without .WAV extension
echo defaults to TADA.wav found in system dir %SystemRoot%\media
goto END

:VERSION
echo filename: %0
echo $Id: tq.cmd 114 2005-04-25 13:59:09Z farley $
echo $Rev: 114 $
echo $LastChangedDate%
goto END

:ERR1
echo %0: Err1: 
goto END

:ERR2
echo %0: Err2:
goto END

:END
set SOUND=