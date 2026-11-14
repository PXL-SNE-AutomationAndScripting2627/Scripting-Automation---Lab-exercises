<#
.SYNOPSIS
    Toont of een service draait of gestopt is.
.DESCRIPTION
    Ontvangt een servicenaam als eerste argument en meldt de status van de
    service. Een ontbrekende parameter en een onbekende service geven een
    duidelijke melding in plaats van een foutmelding.
.PARAMETER serviceName
    De naam van de service. Eerste positionele argument.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/OefIf2.ps1 W32Time
#>
param(
    [string]$serviceName
)

if ([string]::IsNullOrWhiteSpace($serviceName)) {
    Write-Output 'Geen parameter'
} else {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($null -eq $service) {
        Write-Output "De service $serviceName bestaat niet."
    } elseif ($service.Status -eq 'Running') {
        Write-Output "De service $serviceName runt."
    } elseif ($service.Status -eq 'Stopped') {
        Write-Output "De service $serviceName is gestopt."
    } else {
        Write-Output "De service $serviceName heeft de status $($service.Status)."
    }
}
