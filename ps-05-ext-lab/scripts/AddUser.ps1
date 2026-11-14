<#
.SYNOPSIS
    Maakt een lokale Windows-gebruiker.
.DESCRIPTION
    Vraagt een gebruikersnaam, volledige naam en wachtwoord (als SecureString)
    en maakt de lokale gebruiker met New-LocalUser. Fouten worden opgevangen
    met try/catch. Uitvoeren als administrator.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/AddUser.ps1
#>

Write-Host "AddUser Tool" -ForegroundColor Blue
Write-Host "------------" -ForegroundColor Blue

$username = Read-Host "Username"
$fullName = Read-Host "Volledige naam"
$password = Read-Host "Wachtwoord" -AsSecureString

try {
    Write-Host "Creating local account $username on $env:COMPUTERNAME" -ForegroundColor Green
    New-LocalUser -Name $username -FullName $fullName -Password $password -ErrorAction Stop
    Write-Host "local user $username created" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
