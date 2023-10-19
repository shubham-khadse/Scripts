@echo off
REM This script sets the hostname of remote ESXi or ESXi-AOS hosts

REM Specify the path to plink.exe
set "PlinkPath=plink.exe"

REM Specify the CSV file containing hostnames and path
set "CSVFile=Hostname.csv"

REM Set the password
set "Password=YourActualPassword"

REM Loop through each line in the CSV file
for /f "tokens=1,2 delims=," %%i in (%CSVFile%) do (
    "%PlinkPath%" -ssh -t root@%%i -pw %Password% esxcli system hostname set --host=%%j
)

pause
