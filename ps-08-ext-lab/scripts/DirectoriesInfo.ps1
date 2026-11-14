<#
.SYNOPSIS
    Toont informatie over enkele mappen.
.DESCRIPTION
    Doorloopt met foreach de mappen C:\Windows, C:\Program Files en
    C:\powershell. Voor elke bestaande map verschijnen naam, aanmaakdatum en
    attributen. De onderstreping wordt gemaakt met een geneste for-lus.
    Een ontbrekende map wordt gemeld, waarna het script verdergaat.
.NOTES
    Author: Angelo Switon (PXL Student)
.EXAMPLE
    ./scripts/DirectoriesInfo.ps1
#>

$folders = 'C:\Windows', 'C:\Program Files', 'C:\powershell'

foreach ($folder in $folders) {
    if (Test-Path -LiteralPath $folder -PathType Container) {
        $folderInfo = Get-Item -LiteralPath $folder
        $titel = "Informatie over de folder: $folder"

        # Onderstreping: evenveel streepjes als tekens in de titel
        $lijn = ''
        for ($i = 0; $i -lt $titel.Length; $i++) {
            $lijn = $lijn + '-'
        }

        Write-Host $titel -ForegroundColor Green
        Write-Host $lijn -ForegroundColor Green
        Write-Host "De folder `"$($folderInfo.Name)`" is aangemaakt op $($folderInfo.CreationTime)"
        Write-Host "en heeft de volgende attributen: $($folderInfo.Attributes)"
        Write-Host ''
    } else {
        Write-Host "De folder $folder bestaat niet." -ForegroundColor Red
        Write-Host ''
    }
}
