@echo off

@REM Set the path to your pscp executable
set PSCP_PATH="pscp.exe"

@REM Set the common password for all ESXi hosts
set ESXI_PASSWORD="YourServerPassword"

@REM Set the source file (local file to copy)
set SOURCE_FILE=D:\Patch\VMware-ESXi-7.0U3i-20842708-depot.zip

@REM Set the destination directory on the ESXi hosts
set DESTINATION_DIR=/vmfs/volumes/datastore1/

@REM Read server names from Hostname.csv and copy the file to each server
for /f "tokens=1 delims=," %%a in (HostIP.csv) do (
    %PSCP_PATH% -pw %ESXI_PASSWORD% -P 22 %SOURCE_FILE% root@%%a:%DESTINATION_DIR%
)

pause
