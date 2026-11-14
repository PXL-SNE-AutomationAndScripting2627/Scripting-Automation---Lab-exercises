<#
.SYNOPSIS
    Controleert of een bestand bestaat.
.DESCRIPTION
    Ontvangt een bestandspad als eerste argument en meldt of het bestand bestaat.
    Zonder argument verschijnt "Geen parameter".
.PARAMETER filePath
    Het pad naar een bestand. Eerste positionele argument.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/OefIf1.ps1 C:\Windows\notepad.exe
#>
param(
    [string]$filePath
)

if ([string]::IsNullOrWhiteSpace($filePath)) {
    Write-Output 'Geen parameter'
} elseif (Test-Path -LiteralPath $filePath -PathType Leaf) {
    Write-Output "De file $filePath bestaat."
} else {
    Write-Output "De file $filePath bestaat niet."
}
