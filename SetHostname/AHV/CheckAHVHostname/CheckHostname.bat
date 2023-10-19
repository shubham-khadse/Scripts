@echo off
REM This script retrieves and displays hostname and network configuration information from remote AHV hosts

REM Specify the path to plink.exe
set "PlinkPath=plink.exe"

REM Specify the CSV file containing hostnames or IP addresses
set "CSVFile=HostIP.csv"

REM Set the password for authentication
set "Password=YourActualPassword"

REM Loop through each line in the CSV file
for /f "tokens=* delims=," %%i in (%CSVFile%) do (
    REM Use plink to SSH into the ESXi host and retrieve the hostname
    "%PlinkPath%" -ssh -t root@%%i -pw %Password% "hostname"
    "%PlinkPath%" -ssh -t root@%%i -pw %Password% "cat /etc/hostname"
    "%PlinkPath%" -ssh -t root@%%i -pw %Password% "cat /etc/sysconfig/network"
)

pause
