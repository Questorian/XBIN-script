@echo OFF
@if not “%ECHO%”==”” echo %ECHO%
@if not “%OS%”==”Windows_NT” goto DOSEXIT

rem If no arguments, show version information and exit
^ if “%1”==”” (
(echo Script MTP Script Library [%0] $Revision: 2 $)
(goto :EOF)
)

rem At least one argument, so dispatch to procedure
set _PROC=%1
shift /1
goto %_PROC%

rem //////////////////////////////////////////////////////////////////////
rem INIT procedure
rem Must be called in local state before other procs are used
rem
:INIT
if defined TRACE %TRACE% [proc %0 %*]

goto :EOF

rem /////////////////////////////////////////Part II: Real-World Scripting
rem VARDEL procedure
rem Delete multiple variables by prefix
rem
rem Arguments:    %1=variable name prefix
rem
:VARDEL
if defined TRACE %TRACE% [proc %0 %*]
    for /f “tokens=1 delims==” %%I in (‘set %1 2^>nul’) do set %%I=
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem PARSECMDLINE procedure
rem Parse a command line into switches and args
rem
rem Arguments:    CMDLINE=command text to parse
rem        %1=0 for new parse (def) or 1 to append to existing
rem
rem Returns:    CMDARG_n=arguments, CMDSW_n=switches
rem        CMDARGCOUNT=arg count, CMDSWCOUNT=switch count
rem        RET=total number of args processed
rem
:PARSECMDLINE
if defined TRACE %TRACE% [proc %0 %*]
if not {%1}=={1} (
(call :VARDEL CMDARG_)
(call :VARDEL CMDSW_)
(set /a CMDARGCOUNT=0)
(set /a CMDSWCOUNT=0)
)
set /a RET=0
call :PARSECMDLINE1 %CMDLINE%
set _MTPLIB_T1=
goto :EOF
:PARSECMDLINE1
if {%1}=={} goto :EOF
set _MTPLIB_T1=%1
set _MTPLIB_T1=%_MTPLIB_T1:”=%
set /a RET+=1
shift /1
if “%_MTPLIB_T1:~0,1%”==”/” goto :PARSECMDLINESW
if “%_MTPLIB_T1:~0,1%”==”-” goto :PARSECMDLINESW
set /a CMDARGCOUNT+=1
set CMDARG_%CMDARGCOUNT%=%_MTPLIB_T1%
goto :PARSECMDLINE1
:PARSECMDLINESW
set /a CMDSWCOUNT+=1
set CMDSW_%CMDSWCOUNT%=%_MTPLIB_T1%
goto :PARSECMDLINE1
goto :EOF  Chapter 5: A Scripting Toolkit

rem //////////////////////////////////////////////////////////////////////
rem GETARG procedure
rem Get a parsed argument by index
rem
rem Arguments:    %1=argument index (1st arg has index 1)
rem
rem Returns:    RET=argument text or empty if no argument
rem
:GETARG
if defined TRACE %TRACE% [proc %0 %*]
set RET=
if %1 GTR %CMDARGCOUNT% goto :EOF
if %1 EQU 0 goto :EOF
if not defined CMDARG_%1 goto :EOF
set RET=%%CMDARG_%1%%
call :RESOLVE
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem GETSWITCH procedure
rem Get a switch argument by index
rem
rem Arguments:    %1=switch index (1st switch has index 1)
rem
rem Returns:    RET=switch text or empty if none
rem        RETV=switch value (after colon char) or empty
rem
:GETSWITCH
if defined TRACE %TRACE% [proc %0 %*]
(set RET=) & (set RETV=)
if %1 GTR %CMDSWCOUNT% goto :EOF
if %1 EQU 0 goto :EOF
if not defined CMDSW_%1 goto :EOF
set RET=%%CMDSW_%1%%
call :RESOLVE
for /f “tokens=1* delims=:” %%I in (“%RET%”) do (set RET=%%I) & 
(set RETV=%%J)
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem FINDSWITCH procedure
rem Finds the index of the named switch
rem
rem Arguments:    %1=switch name
rem        %2=search start index (def: 1)
rem
rem Returns:    RET=index (0 if not found)
rem        RETV=switch value (text after colon) Part II: Real-World 
Scripting
rem
:FINDSWITCH
if defined TRACE %TRACE% [proc %0 %*]
if {%2}=={} (set /a _MTPLIB_T4=1) else (set /a _MTPLIB_T4=%2)
:FINDSWITCHLOOP
call :GETSWITCH %_MTPLIB_T4%
if “%RET%”==”” (set RET=0) & (goto :FINDSWITCHEND)
-if /i “%RET%”==”%1” (set RET=%_MTPLIB_T4%) & (goto :FINDSWITCHEND)
set /a _MTPLIB_T4+=1
goto :FINDSWITCHLOOP
:FINDSWITCHEND
set _MTPLIB_T4=
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem REGSETM and REGSETU procedures
rem Set registry values from variables
rem
rem Arguments:    %1=reg context (usually script name)
rem        %2=variable to save (or prefix to save set of vars)
rem
:REGSETM
if defined TRACE %TRACE% [proc %0 %*]
for /f “tokens=1* delims==” %%I in (‘set %2 2^>nul’) 
do call :REGSET1 HKLM %1 %%I “%%J”
goto :EOF
:REGSETU
if defined TRACE %TRACE% [proc %0 %*]
-for /f “tokens=1* delims==” %%I in (‘set %2 2^>nul’) 
do call :REGSET1 HKCU %1 %%I “%%J”
goto :EOF
:REGSET1
set _MTPLIB_T10=%4
set _MTPLIB_T10=%_MTPLIB_T10:\=\\%
reg add %1\Software\MTPScriptContexts\%2\%3=%_MTPLIB_T10% >nul
-reg update %1\Software\MTPScriptContexts\%2\%3=%_MTPLIB_T10% >nul
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem REGGETM and REGGETU procedures
rem Get registry value or values to variables
rem
rem Arguments:    %1=reg context (usually script name)
rem        %2=variable to restore (def: restore entire context)
rem
rem Returns:    RET=value of last variable loaded
rem
rem WARNING:    The “delims” value in the FOR commands below is a TAB  
Chapter 5: A Scripting Toolkit
rem        character, followed by a space. If this file is edited by
rem        an editor which converts tabs to spaces, this procedure
rem        will break!!!!!
rem
:REGGETM
if defined TRACE %TRACE% [proc %0 %*]
for /f “delims=     tokens=2*” %%I in 
(‘reg query HKLM\Software\MTPScriptContexts\%1\%2 ^|find “REG_SZ”’) 
do call :REGGETM1 %%I “%%J”
goto :EOF
:REGGETU
if defined TRACE %TRACE% [proc %0 %*]
for /f “delims=     tokens=2*” %%I in 
(‘reg query HKCU\Software\MTPScriptContexts\%1\%2 ^|find “REG_SZ”’) 
do call :REGGETM1 %%I “%%J”
goto :EOF
:REGGETM1
set _MTPLIB_T10=%2
set _MTPLIB_T10=%_MTPLIB_T10:\\=\%
set _MTPLIB_T10=%_MTPLIB_T10:”=%
set %1=%_MTPLIB_T10%
set RET=%_MTPLIB_T10%
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem REGDELM and REGDELU procedures
rem Delete registry values
rem
rem Arguments:    %1=reg context (usually script name)
rem        %2=variable to delete (def: delete entire context)
rem
:REGDELM
if defined TRACE %TRACE% [proc %0 %*]
call :GETTEMPNAME
echo y >%RET%
reg delete HKLM\Software\MTPScriptContexts\%1\%2 <%RET% >nul
del %RET%
goto :EOF
:REGDELU
if defined TRACE %TRACE% [proc %0 %*]
call :GETTEMPNAME
echo y >%RET%
reg delete HKCU\Software\MTPScriptContexts\%1\%2 <%RET% >nul
del %RET%
goto :EOF


rem ////////////////////////////////////////Part II: Real-World Scripting
rem SRAND procedure
rem Seed the random number generator
rem
rem Arguments:    %1=new seed value
rem
:SRAND
if defined TRACE %TRACE% [proc %0 %*]
set /a _MTPLIB_NEXTRAND=%1
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem RAND procedure
rem Get next random number (0 to 32767)
rem
rem Returns:    RET=next random number
rem
:RAND
if defined TRACE %TRACE% [proc %0 %*]
if not defined _MTPLIB_NEXTRAND set /a _MTPLIB_NEXTRAND=1
set /a _MTPLIB_NEXTRAND=_MTPLIB_NEXTRAND * 214013 + 2531011
set /a RET=_MTPLIB_NEXTRAND ^>^> 16 ^& 0x7FFF
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem RESOLVE procedure
rem Fully resolve all indirect variable references in RET variable
rem
rem Arguments:    RET=value to resolve
rem
rem Returns:    RET=as passed in, with references resolved
rem
:RESOLVE
if defined TRACE %TRACE% [proc %0 %*]
:RESOLVELOOP
if “%RET%”==”” goto :EOF
set RET1=%RET%
for /f “tokens=*” %%I in (‘echo %RET%’) do set RET=%%I
if not “%RET%”==”%RET1%” goto :RESOLVELOOP
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem GETINPUTLINE procedure
rem Get a single line of keyboard input
rem
rem Returns:    RET=Entered line
rem
:GETINPUTLINE
if defined TRACE %TRACE% [proc %0 %*]Chapter 5: A Scripting Toolkit
call :GETTEMPNAME
set _MTPLIB_T1=%RET%
copy con “%_MTPLIB_T1%” >nul
for /f “tokens=*” %%I in (‘type “%_MTPLIB_T1%”’) do set RET=%%I
if exist “%_MTPLIB_T1%” del “%_MTPLIB_T1%”
set _MTPLIB_T1=
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem GETSYNCFILE procedure
rem Get a sync file name (file will not exist)
rem
rem Returns:    RET=Name of sync file to use
rem
:GETSYNCFILE
if defined TRACE %TRACE% [proc %0 %*]
call :GETTEMPNAME
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem SETSYNCFILE procedure
rem Flag sync event (creates the file)
rem
rem Arguments:    %1=sync filename to flag
rem
:SETSYNCFILE
if defined TRACE %TRACE% [proc %0 %*]
echo . >%1
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem DELSYNCFILE procedure
rem Delete sync file
rem
rem Arguments:    %1=sync filename
rem
:DELSYNCFILE
if defined TRACE %TRACE% [proc %0 %*]
if exist %1 del %1
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem WAITSYNCFILE
rem Wait for sync file to flag
rem
rem Arguments:    %1=sync filename
rem        %2=timeout in seconds (def: 60)
rem   Part II: Real-World Scripting
rem Returns:    RET=Timeout remaining, or 0 if timeout
rem
:WAITSYNCFILE
if defined TRACE %TRACE% [proc %0 %*]
if {%2}=={} (set /a RET=60) else (set /a RET=%2)
if exist %1 goto :EOF
:WAITSYNCFILELOOP
sleep 1
set /a RET-=1
if %RET% GTR 0 if not exist %1 goto :WAITSYNCFILELOOP
goto :EOF

rem //////////////////////////////////////////////////////////////////////
rem GETTEMPNAME procedure
rem Create a temporary file name
rem
rem Returns:    RET=Temporary file name
rem
:GETTEMPNAME
if defined TRACE %TRACE% [proc %0 %*]
if not defined _MTPLIB_NEXTTEMP set /a _MTPLIB_NEXTTEMP=1
if defined TEMP (
(set RET=%TEMP%)
) else if defined TMP (
(set RET=%TMP%)
) else (set RET=%SystemRoot%)
:GETTEMPNAMELOOP
set /a _MTPLIB_NEXTTEMP=_MTPLIB_NEXTTEMP * 214013 + 2531011
set /a _MTPLIB_T1=_MTPLIB_NEXTTEMP ^>^> 16 ^& 0x7FFF
set RET=%RET%\~SH%_MTPLIB_T1%.tmp
if exist “%RET%” goto :GETTEMPNAMELOOP
set _MTPLIB_T1=
goto :EOF

rem These must be the FINAL LINES in the script...
:DOSEXIT
echo This script requires Windows NT



:: Done -------------------------------------------------------------------------------------------
