@echo off

set user=QSGuest
set pass=Questor123
set drv=L:


net use %drv% /del
net use %drv% \\nqsaaa01\SHRDATA /user:%user% %pass%

set user=
set pass=
