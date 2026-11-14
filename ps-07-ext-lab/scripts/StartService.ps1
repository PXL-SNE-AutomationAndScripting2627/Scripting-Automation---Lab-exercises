<#
.SYNOPSIS
    Start een service wanneer ze niet draait.
.DESCRIPTION
    Controleert of de service bestaat en of ze draait. Een gestopte service
    wordt gestart: rechtstreeks, of na bevestiging wanneer -AskUser gebruikt
    wordt. Met -Info worden eerst de parameters getoond.
    Het starten van een service vereist administratorrechten.
.PARAMETER ServiceName
    De naam van de service. Verplicht.
.PARAMETER AskUser
    Vraag bevestiging (y/n) voordat de service gestart wordt.
.PARAMETER Info
    Toon informatie over de parameters.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/StartService.ps1 -ServiceName WSearch
.EXAMPLE
    ./scripts/StartService.ps1 -ServiceName WSearch -Info -AskUser
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ServiceName,

    [switch]$AskUser,

    [switch]$Info
)

if ($Info) {
    Write-Host "The selected service parameter `$ServiceName is $ServiceName" -ForegroundColor Green
    Write-Host "The switch parameter `$AskUser is $($AskUser.IsPresent)" -ForegroundColor Green
}

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($null -eq $service) {
    Write-Host "Service $ServiceName doesn't exist"
} elseif ($service.Status -eq 'Running') {
    Write-Host "Service $ServiceName already running"
} else {
    Write-Host "Service $ServiceName stopped"

    if ($AskUser) {
        $answer = Read-Host "Do you want to start $ServiceName service ? (y/n)"

        switch ($answer) {
            'y' {
                Write-Host "starting $ServiceName"
                Start-Service -Name $ServiceName
            }
            'n' {
                Write-Host "don't start the service $ServiceName"
            }
            default {
                Write-Host "Invalid answer '$answer': the service $ServiceName is not started"
            }
        }
    } else {
        Write-Host "starting $ServiceName"
        Start-Service -Name $ServiceName
    }
}
