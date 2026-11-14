<#
.SYNOPSIS
    Start en stopt Kladblok en Rekenmachine.
.DESCRIPTION
    Zoekt notepad.exe en calc.exe, start ze en sluit ze daarna weer af.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/StartStopProgsV1.ps1
#>

# De gevonden bestanden
$start_Apps = Get-ChildItem C:\Windows\System32\notepad.exe, C:\Windows\System32\calc.exe

Write-Host "Kladblok en Rekenmachine worden gestart..." -ForegroundColor Green
$start_Apps | Invoke-Item

Start-Sleep -Seconds 3

# De gevonden processen (pas zoeken NA het starten)
$stop_Apps = Get-Process notepad, *calc*

Write-Host "Kladblok en Rekenmachine worden gestopt..." -ForegroundColor Yellow
$stop_Apps | Stop-Process

Write-Host "Klaar." -ForegroundColor Cyan
