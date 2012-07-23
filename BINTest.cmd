@echo off

echo testing various parts of the BIN installation

echo Testing: Perl
perl -v
perl -e "print \"Current time from Perl is: \", scalar localtime "
echo.

echo Testing: PHP
php -v 
:: <?php
:: echo "Hello World\n";
:: ?>