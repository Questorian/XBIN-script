@echo off
title quote
color 18

:start
quote.pl
perl -e "print \"\n\", '*' x 50, \"\n\"

:sleep
:: perl -e "for( $i = 60 ; $i > 0; $i--){ printf (\"waiting: %02d seconds\n\", $i); sleep 1; }"
perl -e "sleep 60"
goto start
