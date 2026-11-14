<#
.SYNOPSIS
    Start en stopt twee programma's via variabelen.
.DESCRIPTION
    Zoekt de programma's uit $app_01 en $app_02, start ze en sluit ze daarna weer af.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/StartStopProgsV2.ps1
#>

$app_01 = 'notepad'
$app_02 = 'calc'

# Bestanden zoeken met een filter op de variabelen
$start_Apps = Get-ChildItem C:\Windows\System32 -File |
    Where-Object { $_.Name -eq "$app_01.exe" -or $_.Name -eq "$app_02.exe" }

Write-Host "Starten van $app_01 en $app_02..." -ForegroundColor Green
$start_Apps | Invoke-Item

Start-Sleep -Seconds 3

# Processen zoeken met een filter op de variabelen
$stop_Apps = Get-Process |
    Where-Object { $_.Name -like "*$app_01*" -or $_.Name -like "*$app_02*" }

Write-Host "Stoppen van $app_01 en $app_02..." -ForegroundColor Yellow
$stop_Apps | Stop-Process

Write-Host "Klaar." -ForegroundColor Cyan
