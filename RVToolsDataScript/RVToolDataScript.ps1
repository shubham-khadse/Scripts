# Import VCenterDetails from CSV
$VcenterDetails = Import-Csv -Path "VcenterDetails.csv"

# RVTool Path
$RVToolsPath = "C:\Program Files (x86)\RVTools"

# Change location to the RVTools directory
Set-Location -Path $RVToolsPath

# Iterate through each VCenter in the CSV
ForEach ($Vcenter in $VcenterDetails) {
    # Extract information from the current VCenter entry
    $VcenterIp = $Vcenter.VcenterIp
    $VcenterUserName = $Vcenter.VcenterUserName
    $VcenterEncryptedPassword = $Vcenter.VcenterEncryptedPassword
    $RVFilePath = $Vcenter.RvFilePath

    # Get the current date in the "dd-MM-yyyy" format
    $Datetime = Get-Date -Format "dd-MM-yyyy"
    $VCServer = $VcenterIp
    $User = $VcenterUserName
    $EncryptedPassword = $VcenterEncryptedPassword
    $XlsxDir1 = $RVFilePath

    # Generate the output XLSX file name based on date and VCenter
    $XlsxFile1 = "${Datetime}-${VCServer}_RVTools-Export.xlsx"

    # Output a message indicating the start of the export for the current VCenter
    Write-Host "Start export for vCenter $VCServer" -ForegroundColor DarkYellow

    # Define the arguments for the RVTools process
    $Arguments = "-u $User -p $EncryptedPassword -s $VCServer -c ExportAll2xls -d $XlsxDir1 -f $XlsxFile1 -DBColumnNames -ExcludeCustomAnnotations"
    Write-Host "Arguments: $Arguments"

    # Start the RVTools process
    $Process = Start-Process -FilePath ".\RVTools.exe" -ArgumentList $Arguments -NoNewWindow -Wait -PassThru

    # Check if the RVTools process returned an exit code of -1 (connection error)
    if ($Process.ExitCode -eq -1) {
        Write-Host "Error: Export failed! RVTools returned exit code -1, probably a connection error! Script is stopped" -ForegroundColor Red 
        exit 1
    }
}
