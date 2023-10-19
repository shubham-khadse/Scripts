# Import hostnames from HostnameList.csv
$esxihostlist = Import-Csv -Path "Hostname.csv"

$esxihostlist | ForEach-Object {
    $hostname = $_.Name
    $esxiHost = Get-VMHost -Name $hostname

    if ($esxiHost) {
        $setting = Get-AdvancedSetting -Entity $esxiHost -Name "Syslog.global.logHost"
        if ($setting) {
            $setting | Set-AdvancedSetting -Value '' -Confirm:$false
            Write-Host "Cleared Syslog.global.logHost for $hostname"
        } else {
            Write-Host "Syslog.global.logHost setting not found for $hostname"
        }
    } else {
        Write-Host "ESXi host $hostname not found"
    }
}


# Below code for Clear Syslog global.logHost setting for all vCenter hosts

# Get-VMHost | ForEach-Object {
#     $setting = Get-AdvancedSetting -Entity $_ -Name "Syslog.global.logHost"
#     if ($setting) {
#         $setting | Set-AdvancedSetting -Value '' -Confirm:$false
#         Write-Host "Cleared Syslog.global.logHost for $($_.Name)"
#     } else {
#         Write-Host "Syslog.global.logHost setting not found for $($_.Name)"
#     }
# }



# Another Way for all vCenter hosts

#Get-VMHost | Foreach { Get-AdvancedSetting -Entity $_ -Name Syslog. global.logHost | Set-AdvancedSetting -Value ''-Confirm:$false } | Sort-Object name | ft -a
