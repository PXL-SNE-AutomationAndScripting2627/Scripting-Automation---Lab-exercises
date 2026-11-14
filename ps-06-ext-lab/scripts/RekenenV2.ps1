<#
.SYNOPSIS
    Een eenvoudige rekenmachine met parameters.
.DESCRIPTION
    Ontvangt twee verplichte getallen van het type double en toont de som en
    het product met twee cijfers na het decimaalteken.
.PARAMETER my_Getal1
    Het eerste getal. Verplicht, positie 0.
.PARAMETER my_Getal2
    Het tweede getal. Verplicht, positie 1.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/RekenenV2.ps1 21.75 103.25
.EXAMPLE
    ./scripts/RekenenV2.ps1 -my_Getal1 21.75 -my_Getal2 103.25
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [double]$my_Getal1,

    [Parameter(Mandatory, Position = 1)]
    [double]$my_Getal2
)

Write-Host "Mijn rekenmachine" -ForegroundColor Yellow
Write-Host "-----------------" -ForegroundColor Yellow
Write-Host "Getal 1: $my_Getal1"
Write-Host "Getal 2: $my_Getal2"

# Berekenen
$som     = $my_Getal1 + $my_Getal2
$product = $my_Getal1 * $my_Getal2

# Twee cijfers na het decimaalteken
$somTekst     = '{0:N2}' -f $som
$productTekst = '{0:N2}' -f $product

Write-Host ""
Write-Host "Rekenkundige bewerkingen:" -ForegroundColor Green
Write-Host "-------------------------" -ForegroundColor Green
Write-Host "De som van $my_Getal1 en $my_Getal2 is $somTekst"
Write-Host "Het product van $my_Getal1 en $my_Getal2 is $productTekst"
