@echo off

REM Set the path to the Microsoft Edge executable (You can change as per your browser)
set "EdgePath=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

REM Loop through each line in the "ILO.csv" file
for /f "tokens=*" %%w in (ILO.csv) do (
    REM Start Microsoft Edge with the URL from each line
    start "" "%EdgePath%" "https://%%w"
)

