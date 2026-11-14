<#
.SYNOPSIS
    Toont de studenten en departementen uit pxl_data.xlsx.
.DESCRIPTION
    Leest met de module ImportExcel de werkbladen Studenten en Departementen
    uit example_files/pxl_data.xlsx. Toont boven elk overzicht het aantal rijen
    en daarna met een foreach-lus elke rij. Ontbreekt het bestand, dan
    verschijnt een duidelijke foutmelding.
    Vereist de module ImportExcel (Install-Module -Name ImportExcel -Scope AllUsers).
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/pxl_view.ps1
#>

$excelBestand = Join-Path $PSScriptRoot '../example_files/pxl_data.xlsx'

if (-not (Test-Path -LiteralPath $excelBestand -PathType Leaf)) {
    Write-Error "Het bestand $excelBestand bestaat niet."
} else {
    $studenten     = Import-Excel -Path $excelBestand -WorksheetName 'Studenten'
    $departementen = Import-Excel -Path $excelBestand -WorksheetName 'Departementen'

    Write-Host "Overzicht studenten($($studenten.Count)) PXL:" -ForegroundColor Green
    foreach ($student in $studenten) {
        Write-Host "Student $($student.Voornaam) $($student.Naam) woonachtig te $($student.Woonplaats)"
    }

    Write-Host "Overzicht departementen($($departementen.Count)) PXL:" -ForegroundColor Green
    foreach ($departement in $departementen) {
        Write-Host "Departement $($departement.Naam) afdeling $($departement.Richting)"
    }
}
