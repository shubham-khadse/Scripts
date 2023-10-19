@echo off

@REM Set the path to your pscp executable example(D:\Patch\pscp.exe)
set "PSCP_PATH=pscp.exe"

@REM Set the common password for all ESXi hosts
set "ESXI_AOS_PASSWORD=YourServerPassword"

@REM Set the source file (local file to copy)
set "SOURCE_FILE=D:\Patch\VMware ESXi-7.0U31-20842708-depot.zip"

@REM Read server names and datastore folder names from Hostname.csv
@REM Ensure that Hostname.csv contains comma-separated IP and serial number (e.g., 192.168.1.1,Serial123)
for /f "tokens=1,2 delims=," %%i in (HostIp.csv) do (

    @REM /vmfs/volumes/NTNX-local-ds-%%s-A/ is the AOS destination. 
    @REM where %%s represents the serial number, and %%a represents the IP in Hostname.csv
    "%PSCP_PATH%" -pw "%ESXI_AOS_PASSWORD%" -P 22 "%SOURCE_FILE%" root@%%i:/vmfs/volumes/NTNX-local-ds-%%s-A/

)

pause
