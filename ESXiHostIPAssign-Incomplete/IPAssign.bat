@echo off

:: Set the Plink path and password
set "plinkPath=plink.exe"
set "yourPassword=YourPassword"

:: Set the default gateway and subnet mask
set "defaultGateway=YourGateway"
set "subnetMask=YourSubnetMask"

:: Loop through each IP address in the "HostIP.csv" file
@REM Pass the Hardening Ip and Production IP in CSV file 
for /f "tokens=* delims=," %%h in (HostIP.csv) do (
    "%plinkPath%" -ssh -t root@%%h -pw %yourPassword% esxcli network ip interface ipv4 set -i vmk0 %defaultGateway% -I %%i -N %subnetMask% -t static
)
