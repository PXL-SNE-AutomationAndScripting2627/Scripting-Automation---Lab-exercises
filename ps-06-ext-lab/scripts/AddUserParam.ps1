<#
.SYNOPSIS
    Maakt een lokale Windows-gebruiker.
.DESCRIPTION
    Ontvangt een gebruikersnaam en optioneel een volledige naam als parameter.
    Het wachtwoord wordt interactief als SecureString gevraagd. Fouten worden
    opgevangen met try/catch. Uitvoeren als administrator.
.PARAMETER userName
    De gebruikersnaam. Verplicht.
.PARAMETER fullName
    De volledige naam. Optioneel.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/AddUserParam.ps1 -userName test -fullName testPxl
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$userName,

    [string]$fullName
)

Write-Host "AddUser Tool" -ForegroundColor Blue
Write-Host "------------" -ForegroundColor Blue

$password = Read-Host "Wachtwoord" -AsSecureString

try {
    Write-Host "Creating local account $userName on $env:COMPUTERNAME" -ForegroundColor Green
    New-LocalUser -Name $userName -FullName $fullName -Password $password -ErrorAction Stop
    Write-Host "local user $userName created" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
