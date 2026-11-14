<#
.SYNOPSIS
    Maakt een ZIP-back-up van een map.
.DESCRIPTION
    Vraagt een bronmap, een doelmap en een back-upnaam, controleert beide mappen
    met Test-Path en maakt een ZIP-bestand met de naam yyyyMMddHHmmss_naam.zip.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/MakeBackup.ps1
#>

Write-Host " Backup Tool" -ForegroundColor Blue
Write-Host "------------" -ForegroundColor Blue

# Bronmap vragen en controleren
$bronmap = Read-Host "Bronmap (c:\pxl_data)"
Write-Host "Check existence of $($bronmap): $(Test-Path $bronmap)" -ForegroundColor Green

# Doelmap vragen en controleren
$doelmap = Read-Host "Doelmap (c:\backups)"
Write-Host "Check existence of $($doelmap): $(Test-Path $doelmap)" -ForegroundColor Green

# Naam van de back-up
$backupnaam = Read-Host "Backupnaam (mydata)"

# Bestandsnaam: yyyyMMddHHmmss_naam.zip
$datum        = Get-Date -Format 'yyyyMMddHHmmss'
$bestandsnaam = $datum + '_' + $backupnaam + '.zip'
$zipPad       = Join-Path -Path $doelmap -ChildPath $bestandsnaam

# ZIP-bestand maken
Compress-Archive -Path $bronmap -DestinationPath $zipPad

Write-Host "Backup Finished - $zipPad" -ForegroundColor Green
