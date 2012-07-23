@echo off
rem send a message to your audiotron..
if not %3.==. goto TWO_LINES
:ONE_LINE
atmsg -h 192.168.0.10 -p admin -t %1 -1 %2
goto END

:TWO_LINES
atmsg -h 192.168.0.10  -p admin -t %1 -1 %2 -2 %3 

:END