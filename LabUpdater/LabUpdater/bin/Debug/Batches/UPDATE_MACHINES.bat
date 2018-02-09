@ECHO off
:: For any section to be excluded from this deployment,
:: you will need to place "REM " before the word "start /wait" below.
::
:: i.e.: REM start /wait c:\temp\updater\9106.bat
:: will prevent the update script running in 9106
::
:DEPLOY
set var=%cd%
set LOGFILE=%var%\Aptos_Deployment.log
:: - CREATING LOG HEADER -
ECHO.
ECHO ******************** >> %logfile%
ECHO * Aptos Deployment * >> %logfile%
ECHO ******************** >> %logfile%
ECHO Run On: >> %logfile%
ECHO %time% >> %logfile%
ECHO %date% >> %logfile%
ECHO ************************************ >> %logfile%
ECHO. >> %logfile%
ECHO. >> %logfile%
ECHO ************************************** >> %logfile%
ECHO * THE FOLLOWING LABS WILL BE UPDATED * >> %logfile%
ECHO ************************************** >> %logfile%
ECHO. >> %logfile%
ECHO US >> %logfile%
ECHO. >> %logfile%






::
ECHO. >> %logfile%
ECHO CANADA >> %logfile%
ECHO. >> %logfile%




::
ECHO. >> %logfile%
ECHO SAM and ANITA >> %logfile%
ECHO. >> %logfile%

start %var%\Batches\9553.bat >> %logfile%
::
ECHO. >> %logfile%
ECHO SMOKE LAB >> %logfile%
ECHO. >> %logfile%
start %var%\Batches\9204.bat >> %logfile%
::
GOTO :EXIT

:exit
EXIT /B 0