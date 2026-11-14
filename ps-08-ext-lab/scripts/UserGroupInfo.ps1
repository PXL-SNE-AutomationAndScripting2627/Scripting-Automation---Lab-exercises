<#
.SYNOPSIS
    Toont de gebruikers per groep uit usergroup.csv.
.DESCRIPTION
    Importeert example_files/usergroup.csv en toont eerst alle gebruikers uit
    groep GPA en daarna alle gebruikers uit groep GPB. Ontbreekt het bestand,
    dan verschijnt een duidelijke foutmelding.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/UserGroupInfo.ps1
#>

$csvBestand = Join-Path $PSScriptRoot '../example_files/usergroup.csv'

if (-not (Test-Path -LiteralPath $csvBestand -PathType Leaf)) {
    Write-Error "Het bestand $csvBestand bestaat niet."
} else {
    $users = Import-Csv -LiteralPath $csvBestand

    Write-Host 'Groep A' -ForegroundColor Green
    foreach ($user in $users) {
        if ($user.Group.Trim() -eq 'GPA') {
            Write-Host "`t$($user.Username.Trim())"
        }
    }

    Write-Host 'Groep B' -ForegroundColor Green
    foreach ($user in $users) {
        if ($user.Group.Trim() -eq 'GPB') {
            Write-Host "`t$($user.Username.Trim())"
        }
    }
}
