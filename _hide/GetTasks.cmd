@echo off

if %1.==. goto err1
if not exist %1. goto err2

:start
perl -n  -e " print if m/^T:/" %1
goto end

:err1
echo %0 - search for tasks in a given (journal) file
echo note: a task is any text file that contains the following single line entry
eho   T:blah, blah, blah
echo.
echo regex -> m/^T:(.*)/
echo this will seperate the tasks from the text
echo you need to specify the filename to search for a list of tasks
echo e.g. %0 journal.txt

:err2
echo %0: error - the passed file %1 cannot be found
echo please check and try again

:end

