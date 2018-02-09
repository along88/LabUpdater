REM @ECHO off
::
:: APTOS DEPLOYMENT SCRIPT
:: WRITTEN BY - PETER M
:: LAST MODIFIED - Feb 6th, 2018
::
:: ------------- SECTIONS OF THIS DEPLOYMENT -------------
:: :EXITAPTOS
:: :STOPSERVICES
:: :COPYFILES
:: :STARTSERVICES
:: :REBOOTREGISTERS
:: :EXIT
:: ------------- BEGIN DEPLOYMENT SCRIPT HERE -------------
COLOR 0A
set var=%cd%
call %var%\PROJECTLOCATION.bat
set REGNUM=9107
set LOGFILE=c:\temp\Aptos_Build_Version_%VersionNum%.log
ECHO.
ECHO Aptos Build Version %VersionNum% >> %logfile%
ECHO Run Time %time% %date% >> %logfile%
ECHO %REGNUM% >> %logfile%
ECHO. >> %logfile%
ECHO. >> %logfile%
::
:: START DEPLOYMENT HERE
:EXITAPTOS
cd \pstools >> %logfile%
ECHO ************************************** >> %logfile%
ECHO *                                    * >> %logfile%
ECHO * EXITING APTOS                      * >> %logfile%
ECHO *                                    * >> %logfile%
ECHO ************************************** >> %logfile%
pskill \\s09107isp000 nsb.desktop.client.exe >> %logfile%
pskill \\s09107REG001 nsb.pos.client.exe >> %logfile%
pskill \\s09107REG002 nsb.pos.client.exe >> %logfile%
ECHO. >> %logfile%
ECHO EXITING APTOS SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
GOTO :STOPSERVICES

:STOPSERVICES
ECHO ************************************** >> %logfile%
ECHO *                                    * >> %logfile%
ECHO * STOPPING SERVICES                  * >> %logfile%
ECHO *                                    * >> %logfile%
ECHO ************************************** >> %logfile%
psexec \\s09107isp000 c:\nsb\stopservices.bat >> %logfile%
psexec \\s09107REG001 c:\nsb\stopservices.bat >> %logfile%
psexec \\s09107REG002 c:\nsb\stopservices.bat >> %logfile%

ECHO ************************************** >> %logfile%
ECHO *                                    * >> %logfile%
ECHO * STOPPING SERVICES                  * >> %logfile%
ECHO *                                    * >> %logfile%
ECHO * SECOND  PASS                       * >> %logfile%
ECHO *                                    * >> %logfile%
ECHO ************************************** >> %logfile%
psexec \\s09107isp000 c:\nsb\stopservices.bat >> %logfile%
psexec \\s09107REG001 c:\nsb\stopservices.bat >> %logfile%
psexec \\s09107REG002 c:\nsb\stopservices.bat >> %logfile%
ECHO. >> %logfile%
ECHO SERVICES STOPPING SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
GOTO :COPYFILES

:COPYFILES
ECHO ************************************** >> %logfile%
ECHO *                                    * >> %logfile%
ECHO * COPYING FILES                      * >> %logfile%
ECHO *                                    * >> %logfile%
ECHO ************************************** >> %logfile%
xcopy /s %PROJECTLOCATION%\CANADA\ISP\* 		\\s09107isp000\c$\ /E /H /I /V /Y >> %logfile%
xcopy /s %PROJECTLOCATION%\CANADA\REGISTERS\* 	\\s09107REG001\c$\ /E /H /I /V /Y >> %logfile%
xcopy /s %PROJECTLOCATION%\CANADA\REGISTERS\* 	\\s09107REG002\c$\ /E /H /I /V /Y >> %logfile%
ECHO. >> %logfile%
ECHO COPY SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
psexec \\s09107isp000 c:\streams.exe -d -s C:\nsb\coalition\dotnet\
psexec \\s09107reg001 c:\streams.exe -d -s C:\nsb\coalition\dotnet\
psexec \\s09107reg002 c:\streams.exe -d -s C:\nsb\coalition\dotnet\

GOTO :STARTSERVICES

:STARTSERVICES
ECHO ************************************** >> %logfile%
ECHO *                                    * >> %logfile%
ECHO * STARTING SERVICES                  * >> %logfile%
ECHO *                                    * >> %logfile%
ECHO ************************************** >> %logfile%
psexec \\s09107isp000 c:\nsb\startservices.bat >> %logfile%
ECHO. >> %logfile%
ECHO SERVICES STARTING SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
GOTO :REBOOTREGISTERS

:REBOOTREGISTERS
ECHO ************************************** >> %logfile%
ECHO *                                    * >> %logfile%
ECHO * REBOOTING SYSTEMS                  * >> %logfile%
ECHO *                                    * >> %logfile%
ECHO ************************************** >> %logfile%
psexec \\s09107isp000 shutdown /r /f /t 300 >> %logfile%
psexec \\s09107REG001 shutdown /r /f /t 600 >> %logfile%
psexec \\s09107REG002 shutdown /r /f /t 600 >> %logfile%
ECHO. >> %logfile%
ECHO REBOOTING SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
ECHO. >> %logfile%
ECHO DONE! >> %logfile%
ECHO. >> %logfile%
GOTO :EXIT

:EXIT
ECHO Exiting... %REGNUM% Complete >> %logfile%
EXIT /B 0
EXIT