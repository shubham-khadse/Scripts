@echo off
:: Set the path to Pscp executable
set PSCP_PATH="pscp.exe"
:: Set the path to Putty executable
set PUTTY_PATH="putty.exe"
:: Set the path to Plink executable
set PLINK_PATH="plink.exe"

:: Set the common password for all servers
set SERVER_PASSWORD="YourPassword"

:: Read server names from servers.csv and execute PatchInstall.sh remotely
for /f "tokens=* delims=" %%i in (HostIP.csv) do (
    %PSCP_PATH% -pw %SERVER_PASSWORD% -P 22 ESXiScript.sh root@%%i:/
)
for /f "tokens=* delims=" %%i in (HostIP.csv) do (
    %PUTTY_PATH% -ssh root@%%i -pw %SERVER_PASSWORD% -m "FilePermission.sh"
)
for /f "tokens=* delims=" %%i in (HostIP.csv) do (
    %PLINK_PATH% -v -ssh -t root@%%i -pw %SERVER_PASSWORD% -m "ESXiScript.sh"
)

pause
