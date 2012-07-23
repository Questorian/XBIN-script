@echo off

set user=admin
set pass="v=DT>3kavg#h"
set drv=L:


net use %drv% /del
net use %drv% \\nqsaaa01\SHRDATA /user:%user% %pass%

set user=
set pass=
