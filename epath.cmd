@echo off

::set emergeny values here
set e_drv=V:
set e_path=D:\QS\PERSONA\QUESTOR\DATA\bin


echo %0: setting emergency path
net use %e_drv% /del
subst %e_drv% %e_path%
