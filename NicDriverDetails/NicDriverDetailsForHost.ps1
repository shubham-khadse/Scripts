# Connect to the vCenter server
Connect-VIServer -Server 0.0.0.0

# Import a list of ESXi hostnames from the "Hostname.csv" file
$esxihostlist = Import-Csv -Path "Hostname.csv"
$esxihostnames = $esxihostlist.Name

# Get PCI devices for specified device classes
$devices = Get-VMHost $esxihostnames | Get-VMHostPciDevice |
    Where-Object {
        $_.DeviceClass -eq "MassStorageController" -or
        $_.DeviceClass -eq "NetworkController" -or
        $_.DeviceClass -eq "SerialBusController"
    }

# Load HCL data from a JSON file
$hcl = Invoke-WebRequest -Uri "file:///D:/Scripts/NicDriverDetails/vmware-iohcl.json" | ConvertFrom-Json

$AllInfo = @()

Foreach ($device in $devices) {
    # Ignore specific devices
    if ($device.DeviceName -like "*USB*" -or $device.DeviceName -like "*iLO*" -or $device.DeviceName -like "*iDRAC*") {
        continue
    }

    $DeviceFound = $false

    $Info = "" | Select VMHost, Device, DeviceName, VendorName, DeviceClass, vid, did, svid, ssid, Driver, DriverVersion, FirmwareVersion, VibVersion, Supported, Reference
    $Info.VMHost = $device.VMHost
    $Info.DeviceName = $device.DeviceName
    $Info.VendorName = $device.VendorName
    $Info.DeviceClass = $device.DeviceClass
    $Info.vid = [String]::Format("{0:x4}", $device.VendorId)
    $Info.did = [String]::Format("{0:x4}", $device.DeviceId)
    $Info.svid = [String]::Format("{0:x4}", $device.SubVendorId)
    $Info.ssid = [String]::Format("{0:x4}", $device.SubDeviceId)

    Foreach ($entry in $hcl.data.ioDevices) {
        # Search HCL entry with PCI IDs VID, DID, SVID, and SSID
        if ($Info.vid -eq $entry.vid -and $Info.did -eq $entry.did -and $Info.svid -eq $entry.svid -and $Info.ssid -eq $entry.ssid) {
            $Info.Reference = $entry.url
            $DeviceFound = $true
        }
    }

    if ($DeviceFound) {
        if ($device.DeviceClass -eq "NetworkController") {
            # Get NIC list to identify vmnicX from PCI slot Id
            $esxcli = $device.VMHost | Get-EsxCli -V2
            $niclist = $esxcli.network.nic.list.Invoke()
            $vmnicId = $niclist | where { $_.PCIDevice -like '*' + $device.Id }
            $Info.Device = $vmnicId.Name

            # Get NIC driver and firmware information
            Write-Debug "Processing $($Info.VMHost.Name) $($Info.Device) $($Info.DeviceName)"
            if ($vmnicId.Name) {
                $vmnicDetail = $esxcli.network.nic.get.Invoke(@{nicname = $vmnicId.Name })
                $Info.Driver = $vmnicDetail.DriverInfo.Driver
                $Info.DriverVersion = $vmnicDetail.DriverInfo.Version
                $Info.FirmwareVersion = $vmnicDetail.DriverInfo.FirmwareVersion

                # Get driver vib package version
                Try {
                    $driverVib = $esxcli.software.vib.get.Invoke(@{vibname = "net-" + $vmnicDetail.DriverInfo.Driver })
                }
                Catch {
                    $driverVib = $esxcli.software.vib.get.Invoke(@{vibname = $vmnicDetail.DriverInfo.Driver })
                }
                $Info.VibVersion = $driverVib.Version
            }
        }
        elseif ($device.DeviceClass -eq "MassStorageController" -or $device.DeviceClass -eq "SerialBusController") {
            # Identify HBA (FC or Local Storage) with PCI slot Id
            $vmhbaId = $device.VMHost | Get-VMHostHba -ErrorAction SilentlyContinue | where { $_.PCI -like '*' + $device.Id }
            $Info.Device = $vmhbaId.Device
            $Info.Driver = $vmhbaId.Driver

            # Get driver vib package version
            Try {
                $driverVib = $esxcli.software.vib.get.Invoke(@{vibname = "scsi-" + $vmhbaId.Driver })
            }
            Catch {
                $driverVib = $esxcli.software.vib.get.Invoke(@{vibname = $vmhbaId.Driver })
            }
            $Info.VibVersion = $driverVib.Version
        }
        $Info.Supported = $DeviceFound
        $AllInfo += $Info
    }
}

$AllInfo | select VMHost, Device, DeviceName, Driver, DriverVersion, FirmwareVersion, VibVersion | ft -AutoSize
$AllInfo | Export-Csv -NoTypeInformation "Report.csv"
