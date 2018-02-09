cd \pstools
xcopy /s xxx\ISP\* \\LAB\c$\ /E /H /I /V /Y 

xcopy /s xxx\Registers\* \\regNum1\c$\ /E /H /I /V /Y 

xcopy /s xxx\Registers\* \\regNum2\c$\ /E /H /I /V /Y 

streams -d -s \\LAB\c$\NSB\coalition\dotnet
streams -d -s \\regNum1\c$\NSB\coalition\dotnet
streams -d -s \\regNum2\c$\NSB\coalition\dotnet

Timeout /T 200 /NOBREAK