<#
.SYNOPSIS
    Telt alle bestanden in een map.
.DESCRIPTION
    Telt recursief alle bestanden in de opgegeven map en toont het volledige
    resultaat van Measure-Object.
.PARAMETER directory
    Een bestaande map. Eerste positionele argument.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/NumberOfFiles.ps1 C:\powershell
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateScript({ Test-Path -Path $_ -PathType Container }, ErrorMessage = '{0} is geen bestaande map.')]
    [string]$directory
)

Get-ChildItem -Path $directory -Recurse -File | Measure-Object
