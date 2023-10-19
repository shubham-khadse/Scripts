@echo off
:: Set the path to Plink executable
set PLINK_PATH="plink.exe"

:: Set the common password for all servers
set SERVER_PASSWORD="YourPassword"

:: Read server names from servers.csv and execute PatchInstall.sh remotely
for /f "tokens=* delims=" %%i in (HostIP.csv) do (
    %PLINK_PATH% -ssh root@%%i -pw %SERVER_PASSWORD% -m "PatchInstall.sh"
)

pause
