<#
.SYNOPSIS
    Telt alle bestanden in een map en toont een leesbare zin.
.DESCRIPTION
    Telt recursief alle bestanden in de opgegeven map en toont de map en het
    aantal bestanden in een zin.
.PARAMETER directory
    Een bestaande map. Eerste positionele argument.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/NumberOfFilesv2.ps1 C:\powershell
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateScript({ Test-Path -Path $_ -PathType Container }, ErrorMessage = '{0} is geen bestaande map.')]
    [string]$directory
)

$aantal = (Get-ChildItem -Path $directory -Recurse -File | Measure-Object).Count
Write-Output "Onder de map $directory bevinden zich $aantal bestanden."
