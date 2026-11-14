<#
.SYNOPSIS
    Een eenvoudige rekenmachine.
.DESCRIPTION
    Vraagt twee getallen, zet ze om naar double en toont de som en het product
    met twee cijfers na het decimaalteken.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/Rekenen.ps1
#>

Write-Host "Mijn rekenmachine" -ForegroundColor Yellow
Write-Host "-----------------" -ForegroundColor Yellow

# Read-Host geeft tekst terug; een komma vervangen we door een punt
$invoer1 = Read-Host "Geef het eerste getal in"
$invoer2 = Read-Host "Geef het tweede getal in"

# Expliciet omzetten naar double (casting)
[double]$getal1 = $invoer1.Replace(',', '.')
[double]$getal2 = $invoer2.Replace(',', '.')

# Berekenen
$som     = $getal1 + $getal2
$product = $getal1 * $getal2

# Twee cijfers na het decimaalteken
$somTekst     = '{0:N2}' -f $som
$productTekst = '{0:N2}' -f $product

Write-Host ""
Write-Host "Rekenkundige bewerkingen:" -ForegroundColor Green
Write-Host "-------------------------" -ForegroundColor Green
Write-Host "De som van $getal1 en $getal2 is $somTekst"
Write-Host "Het product van $getal1 en $getal2 is $productTekst"
