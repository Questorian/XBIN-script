@echo off 
rem SAR: Search and Replace
perl -n -e "s/%1/%2/g;" -e "print ;" %3 %4 %5
