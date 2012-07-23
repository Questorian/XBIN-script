@echo off
rem install the blat program
rem if %Q_EmailPOOut%. ==. goto ERR1

::sets
set Q_FromEmail=contracts@QuestorSystems.com
set Q_EmailPOOut=mail.QuestorSystems.com

blat -install %Q_EmailPOOut% %Q_FromEmail%
goto END

:ERR1
echo you need to run QSCDE and check the environment variables;
echo %%Q_EmailPOOut%% 
echo %%Q_FromEmail%%
echo have been set

:END