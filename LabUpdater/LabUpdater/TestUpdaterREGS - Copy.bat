@Echo off
::
:: APTOS DEPLOYMENT SCRIPT
:: WRITTEN BY - PETER M
:: LAST MODIFIED - Jan 17th, 2018
::
:: SETTING PROJECT RUN LOCATION
:: Replace XXX with path of folder where package is located
set PROJECTLOCATION=xxx
set REG1=regNum1
set REG2=regNum2
::
:: ------------- SECTIONS OF THIS DEPLOYMENT -------------
:: :EXITAPTOS
:: :STOPSERVICES
:: :COPYFILES
:: :STARTSERVICES
:: :REBOOTREGISTERS
:: :EXIT
:: ------------- BEGIN DEPLOYMENT SCRIPT HERE -------------
:: CREATING LOG HEADER
echo.
echo Aptos Build Version %VersionNum% Smoke >> %logfile%
echo Run Time %time% %date% >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
GOTO :EXITAPTOS





:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:EXITAPTOS
cd \pstools >> %logfile%
ECHO ******************************************************************************** >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO * EXITING APTOS                                                                * >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO ******************************************************************************** >> %logfile%
ECHO. >> %logfile%
ECHO ***ISPs*** >> %logfile%
ECHO. >> %logfile%
pskill \\%REG1% nsb.desktop.client.exe >> %logfile%
pskill \\%REG2% nsb.desktop.client.exe >> %logfile%
ECHO. >> %logfile%
ECHO EXITING APTOS SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
GOTO :STOPSERVICES




:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:STOPSERVICES
ECHO ******************************************************************************** >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO * STOPPING SERVICES                                                            * >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO ******************************************************************************** >> %logfile%
ECHO. >> %logfile%
ECHO ***ISPs*** >> %logfile%
ECHO. >> %logfile%
psexec \\%REG1% c:\nsb\stopservices.bat >> %logfile%
psexec \\%REG2% c:\nsb\stopservices.bat >> %logfile%
ECHO. >> %logfile%

ECHO ******************************************************************************** >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO * STOPPING SERVICES                                                            * >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO * SECOND  PASS                                                                 * >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO ******************************************************************************** >> %logfile%
ECHO. >> %logfile%
ECHO ***ISPs*** >> %logfile%
ECHO. >> %logfile%
psexec \\%REG1% c:\nsb\stopservices.bat >> %logfile%
psexec \\%REG2% c:\nsb\stopservices.bat >> %logfile%
ECHO. >> %logfile%
ECHO SERVICES STOPPING SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
GOTO :COPYFILES







:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:COPYFILES
ECHO ******************************************************************************** >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO * COPYING FILES                                                                * >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO ******************************************************************************** >> %logfile%
ECHO. >> %logfile%
ECHO ***REGISTERS*** >> %logfile%
ECHO. >> %logfile%
xcopy /s %PROJECTLOCATION%\REGISTERS\* \\%REG1%\c$\ /E /H /I /V /Y >> %logfile%
xcopy /s %PROJECTLOCATION%\REGISTERS\* \\%REG2%\c$\ /E /H /I /V /Y >> %logfile%
ECHO. >> %logfile%
ECHO XCOPY SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
GOTO :STARTSERVICES
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:STARTSERVICES
ECHO ******************************************************************************** >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO * STARTING SERVICES                                                            * >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO ******************************************************************************** >> %logfile%
ECHO. >> %logfile%
ECHO ***ISPs*** >> %logfile%
ECHO. >> %logfile%
psexec \\%REG1% c:\nsb\startservices.bat >> %logfile%
psexec \\%REG2% c:\nsb\startservices.bat >> %logfile%
ECHO. >> %logfile%
ECHO SERVICES STARTING SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
GOTO :EXIT
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:REBOOTREGISTERS
ECHO ******************************************************************************** >> %logfile%
ECHO *                                                                              * >> %logfile%
echo * REBOOTING SYSTEMS                                                            * >> %logfile%
ECHO *                                                                              * >> %logfile%
ECHO ******************************************************************************** >> %logfile%
ECHO. >> %logfile%
ECHO ***REGISTERS*** >> %logfile%
ECHO. >> %logfile%
psexec \\%REG1% shutdown /r /f /t 300 >> %logfile%
psexec \\%REG2% shutdown /r /f /t 300 >> %logfile%
ECHO. >> %logfile%
ECHO REBOOTING SECTION COMPLETE >> %logfile%
ECHO. >> %logfile%
ECHO DONE! >> %logfile%
ECHO. >> %logfile%
PAUSE
GOTO :EXIT
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:: >> %logfile%
:EXIT
echo Exiting.... >> %logfile%
EXIT /B 0 >> %logfile%