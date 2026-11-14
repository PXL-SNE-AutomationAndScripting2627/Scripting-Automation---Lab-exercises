<#
.SYNOPSIS
    Maakt een ZIP-back-up van een map.
.DESCRIPTION
    Controleert de bronmap en de doelmap en maakt een ZIP-bestand met de naam
    yyyyMMddHHmmss_naam.zip in de doelmap.
.PARAMETER source_Folder
    De map die geback-upt wordt. Verplicht.
.PARAMETER destination_Folder
    De map waarin het ZIP-bestand komt. Verplicht.
.PARAMETER backup_Name
    De naam van de back-up. Verplicht.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/MakeBackupV2.ps1 -source_Folder C:\pxl_data -destination_Folder C:\backups -backup_Name pxldata
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -Path $_ -PathType Container }, ErrorMessage = '{0} is geen bestaande map.')]
    [string]$source_Folder,

    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -Path $_ -PathType Container }, ErrorMessage = '{0} is geen bestaande map.')]
    [string]$destination_Folder,

    [Parameter(Mandatory)]
    [string]$backup_Name
)

Write-Host " Backup Tool" -ForegroundColor Blue
Write-Host "------------" -ForegroundColor Blue
Write-Host "Check existence of $($source_Folder): $(Test-Path $source_Folder)" -ForegroundColor Green
Write-Host "Check existence of $($destination_Folder): $(Test-Path $destination_Folder)" -ForegroundColor Green

# Bestandsnaam: yyyyMMddHHmmss_naam.zip
$datum        = Get-Date -Format 'yyyyMMddHHmmss'
$bestandsnaam = $datum + '_' + $backup_Name + '.zip'
$zipPad       = Join-Path -Path $destination_Folder -ChildPath $bestandsnaam

# ZIP-bestand maken
Compress-Archive -Path $source_Folder -DestinationPath $zipPad

Write-Host "Backup Finished - $zipPad" -ForegroundColor Green
