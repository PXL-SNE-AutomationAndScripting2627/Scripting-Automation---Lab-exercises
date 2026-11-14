<#
.SYNOPSIS
    Toont informatie over de bestanden en mappen in een folder.
.DESCRIPTION
    Bewaart het aantal bestanden, de grootste, gemiddelde en totale grootte in MB
    en het aantal submappen van $myFolder in variabelen en toont ze in kleur.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/ShowFolderInfo.ps1
#>

$myFolder = $env:USERPROFILE      # test daarna met 'C:\Windows\System32'

# Metingen
$fileInfo   = Get-ChildItem -Path $myFolder -Recurse -File -ErrorAction SilentlyContinue |
              Measure-Object -Property Length -Maximum -Average -Sum
$folderInfo = Get-ChildItem -Path $myFolder -Recurse -Directory -ErrorAction SilentlyContinue |
              Measure-Object

# Resultaten in betekenisvolle variabelen
$aantalBestanden = $fileInfo.Count
$grootsteMB      = [math]::Round($fileInfo.Maximum / 1MB, 2)
$totaalMB        = [math]::Round($fileInfo.Sum / 1MB, 2)
$gemiddeldeMB    = [math]::Round($fileInfo.Average / 1MB, 2)
$aantalFolders   = $folderInfo.Count

# Uitvoer
Write-Host "Folder $myFolder" -ForegroundColor Yellow
Write-Host "Recursive: True" -ForegroundColor Green
Write-Host "`t-> Aantal bestanden: $aantalBestanden"
Write-Host "`t-> Grootste bestand: $grootsteMB MB"
Write-Host "`t-> Totale grootte: $totaalMB MB"
Write-Host "`t-> Gemiddelde bestandsgrootte: $gemiddeldeMB MB"
Write-Host "`t-> Aantal Folders: $aantalFolders"
