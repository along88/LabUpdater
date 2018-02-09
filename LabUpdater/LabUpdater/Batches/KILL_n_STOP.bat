@ECHO off
::
:: APTOS DEPLOYMENT SCRIPT - Stop Services-Kill POS
:: WRITTEN BY - PETER M
:: LAST MODIFIED - Feb 7th, 2018
::
SET LOGFILE=c:\temp\SERVICESTOPPER.log
SET JIRAID=none
COLOR 0A
ECHO ******************** >> %logfile%
ECHO * Coach Deployment * >> %logfile%
ECHO ******************** >> %logfile%
ECHO DEPLOYMENT IN PROGRESS... >> %logfile%
ECHO TIME: %time% >> %logfile%
ECHO DATE: %date% >> %logfile%
TITLE WHO IS RUNNING THIS DEPLOYMENT??
ECHO HALT! Who goes there?
ECHO.
ECHO [Please enter your name - NO SPACES]
SET /p Deployer=
ECHO. >> %logfile%
ECHO %deployer% is running this deployment. >> %logfile%
ECHO. >> %logfile%
ECHO - NOW THAT WE'RE FRIENDS, WE CAN CONTINUE -
TIMEOUT 3
ECHO This deployment will stop services and kill POS on a specific ISP and REGISTER lab. >> %logfile%
ECHO. >> %logfile%
ECHO The JIRAs included are - %JIRAID% >> %logfile%
ECHO. >> %logfile%

:start
TITLE WHAT LAB IS THIS BEING RUN ON??
ECHO Please enter 4 digit lab number
ECHO.
ECHO [i.e.: 9106 or 9228]
SET /p STORENUM=
ECHO. >> %logfile%
ECHO This deployment is being run on %storenum%. >> %logfile%
ECHO. >> %logfile%
cd c:\pstools
pskill \\s0%storenum%isp000\ nsb.desktop.client.exe >> %logfile%
pskill \\s0%storenum%reg001\ nsb.pos.client.exe >> %logfile%
pskill \\s0%storenum%reg002\ nsb.pos.client.exe >> %logfile%
TIMEOUT 3
psexec \\s0%storenum%isp000\ c:\nsb\stopservices.bat >> %logfile%
psexec \\s0%storenum%reg001\ c:\nsb\stopservices.bat >> %logfile%
psexec \\s0%storenum%reg002\ c:\nsb\stopservices.bat >> %logfile%
ECHO The deployment has completed in %storenum% >> %logfile%
ECHO and will now be exited... >> %logfile%
GOTO :start
EXIT