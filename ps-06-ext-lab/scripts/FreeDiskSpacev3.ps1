<#
.SYNOPSIS
    Toont de totale grootte en vrije ruimte van een lokale schijf.
.DESCRIPTION
    Zoekt de lokale schijf (DriveType 3) met de opgegeven stationsletter en
    toont de totale grootte en de vrije ruimte in bytes. Zonder stationsletter
    wordt C: gebruikt.
.PARAMETER driveLetter
    Stationsletter zoals C:. Optioneel, standaard C:.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/FreeDiskSpacev3.ps1
.EXAMPLE
    ./scripts/FreeDiskSpacev3.ps1 D:
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidatePattern('\A[A-Z]:\z', ErrorMessage = '{0} is geen geldige stationsletter (bv. C:).')]
    [string]$driveLetter = 'C:'
)

$disk = Get-CimInstance -ClassName CIM_LogicalDisk |
    Where-Object DriveType -eq 3 |
    Where-Object DeviceID -eq $driveLetter

Write-Output "$driveLetter totale grootte $($disk.Size), vrije ruimte $($disk.FreeSpace)"
