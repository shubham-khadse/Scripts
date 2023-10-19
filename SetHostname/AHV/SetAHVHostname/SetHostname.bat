@echo off
REM This script updates the hostname and network configuration on remote AHV hosts

REM Specify the path to plink.exe
set "PlinkPath=plink.exe"

REM Specify the CSV file containing host IP addresses and hostnames
set "CSVFile=Hostname.csv"

REM Set the password
set "Password=YourActualPassword"

REM Loop through each line in the CSV file
for /f "tokens=1,2 delims=," %%i in (%CSVFile%) do (
    REM Use plink to SSH into the ESXi host and update the hostname (%%i is ip and %%j is hostname)
    "%PlinkPath%" -ssh -t root@%%i -pw %Password% "hostname %%j"
    "%PlinkPath%" -ssh -t root@%%i -pw %Password% "echo '%%j' > /etc/hostname"
    "%PlinkPath%" -ssh -t root@%%i -pw %Password% "printf 'NETWORKING=yes \n HOSTNAME=%%j \n' > /etc/sysconfig/network"
)

REM Pause the script to view any output or errors
pause
