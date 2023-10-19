@echo off

REM Set the path to the putty.exe executable (example: D:\Path\ssh.exe)
set "SSHPath=putty.exe"

REM Set the SSH password
set "SSHPassword=YourActualPassword"

for /f "tokens=*" %%i in (HostIP.csv) do (
    "%SSHPath%" -ssh root@%%i -pw %SSHPassword%
)

pause
