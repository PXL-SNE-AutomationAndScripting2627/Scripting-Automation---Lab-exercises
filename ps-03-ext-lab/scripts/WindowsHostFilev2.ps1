<#
.SYNOPSIS
    Toont de inhoud van een bestand uit de map drivers\etc van Windows.

.DESCRIPTION
    Het script bouwt het pad op vanuit $env:WINDIR en de bestandsnaam in
    $File_To_Find. Het controleert of het bestand bestaat. Zo ja, dan worden
    het pad en de inhoud getoond. Zo nee, dan verschijnt er een duidelijke foutmelding.

.EXAMPLE
    .\WindowsHostFilev2.ps1
    Toont het pad en de inhoud van het bestand dat in $File_To_Find staat (bv. hosts).
#>

$File_To_Find = 'hosts'

# Pad opbouwen vanuit de Windows-map
$folder = Join-Path -Path $env:WINDIR -ChildPath 'System32\drivers\etc'
$path   = Join-Path -Path $folder -ChildPath $File_To_Find

# Controleren of het bestand bestaat
if (Test-Path -Path $path) {
    Write-Host "Inhoud van de Windows file: $path" -ForegroundColor Yellow
    Get-Content -Path $path
}
else {
    Write-Error "Het bestand '$File_To_Find' werd niet gevonden op '$path'."
}