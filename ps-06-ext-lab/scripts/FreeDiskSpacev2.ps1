<#
.SYNOPSIS
    Toont de totale grootte en vrije ruimte van een lokale schijf.
.DESCRIPTION
    Zoekt de lokale schijf (DriveType 3) met de opgegeven stationsletter en
    toont de totale grootte en de vrije ruimte in bytes.
.PARAMETER driveLetter
    Stationsletter zoals C:. Verplicht en positioneel.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/FreeDiskSpacev2.ps1 C:
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidatePattern('\A[A-Z]:\z', ErrorMessage = '{0} is geen geldige stationsletter (bv. C:).')]
    [string]$driveLetter
)

$disk = Get-CimInstance -ClassName CIM_LogicalDisk |
    Where-Object DriveType -eq 3 |
    Where-Object DeviceID -eq $driveLetter

Write-Output "$driveLetter totale grootte $($disk.Size), vrije ruimte $($disk.FreeSpace)"
