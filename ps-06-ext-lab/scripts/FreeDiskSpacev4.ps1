<#
.SYNOPSIS
    Toont de totale grootte en vrije ruimte van een lokale schijf in MB, GB of TB.
.DESCRIPTION
    Zoekt de lokale schijf (DriveType 3) met de opgegeven stationsletter en
    toont de totale grootte en de vrije ruimte, afgerond op twee decimalen,
    in de gekozen eenheid. Bestaat de schijf niet, dan volgt een foutmelding.
.PARAMETER driveLetter
    Stationsletter zoals C:. Optioneel, standaard C:.
.PARAMETER dataUnit
    Eenheid: MB, GB of TB. Optioneel, standaard TB.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/FreeDiskSpacev4.ps1
.EXAMPLE
    ./scripts/FreeDiskSpacev4.ps1 -driveLetter D: -dataUnit GB
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateScript({ Get-CimInstance -ClassName CIM_LogicalDisk | Where-Object DriveType -eq 3 | Where-Object DeviceID -eq $_ }, ErrorMessage = 'De schijf {0} bestaat niet of is geen lokale schijf.')]
    [ValidatePattern('\A[A-Z]:\z', ErrorMessage = '{0} is geen geldige stationsletter (bv. C:).')]
    [string]$driveLetter = 'C:',

    [Parameter(Position = 1)]
    [ValidateSet('MB', 'GB', 'TB', ErrorMessage = 'Enkel MB, GB, TB zijn als dataUnit mogelijk.')]
    [string]$dataUnit = 'TB'
)

$disk = Get-CimInstance -ClassName CIM_LogicalDisk |
    Where-Object DriveType -eq 3 |
    Where-Object DeviceID -eq $driveLetter

# Het aantal bytes per eenheid opzoeken in een hashtable
$delers = @{ MB = 1MB; GB = 1GB; TB = 1TB }
$deler  = $delers[$dataUnit]

$totaal = [math]::Round($disk.Size / $deler, 2)
$vrij   = [math]::Round($disk.FreeSpace / $deler, 2)

$eenheid = $dataUnit.ToUpper()

Write-Output "$($disk.DeviceID) totale grootte $totaal$eenheid, vrije ruimte $vrij$eenheid"
