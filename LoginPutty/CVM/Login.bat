@echo off

REM Set the path to the putty.exe executable (example: C:\Path\ssh.exe)
set "SSHPath=putty.exe"

REM Set the SSH password
set "SSHPassword=YourActualPassword"

for /f "tokens=*" %%i in (ServeIp.csv) do (
    "%SSHPath%" -ssh nutanix@%%i -pw %SSHPassword%
)

pause
