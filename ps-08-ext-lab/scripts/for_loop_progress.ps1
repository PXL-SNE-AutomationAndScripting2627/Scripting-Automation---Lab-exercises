<#
.SYNOPSIS
    Toont een voortgangsbalk van 1 tot en met 100 procent.
.DESCRIPTION
    Een for-lus telt van 1 tot en met 100. Bij elke stap toont Write-Progress
    de voortgang en simuleert Start-Sleep een beetje werk. Na de lus wordt de
    voortgangsbalk afgesloten.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/for_loop_progress.ps1
#>

for ($i = 1; $i -le 100; $i++) {
    Write-Progress -Activity 'Search in Progress' -Status "$i% Complete:" -PercentComplete $i
    Start-Sleep -Milliseconds 50
}

# De voortgangsbalk afsluiten
Write-Progress -Activity 'Search in Progress' -Completed
