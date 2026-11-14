<#
.SYNOPSIS
    Toont het CIM-object van een lokale schijf.
.DESCRIPTION
    Zoekt met Get-CimInstance de lokale schijf (DriveType 3) met de opgegeven
    stationsletter en toont het CIM-object.
.PARAMETER driveLetter
    Stationsletter zoals C:. Verplicht en positioneel.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/FreeDiskSpace.ps1 C:
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidatePattern('\A[A-Z]:\z', ErrorMessage = '{0} is geen geldige stationsletter (bv. C:).')]
    [string]$driveLetter
)

Get-CimInstance -ClassName CIM_LogicalDisk |
    Where-Object DriveType -eq 3 |
    Where-Object DeviceID -eq $driveLetter
