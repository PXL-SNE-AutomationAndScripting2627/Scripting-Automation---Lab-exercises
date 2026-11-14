<#
.SYNOPSIS
    Zoekt met reguliere expressies verschillende soorten gegevens in regdata.txt.
.DESCRIPTION
    Het script leest example_files\regdata.txt volledig in en zoekt per categorie
    (e-mailadressen, URL's, datums, IP-adressen, telefoonnummers, HTML-tags)
    alle overeenkomsten. Per categorie wordt eerst het aantal getoond, daarna de waarden.
.EXAMPLE
    .\scripts\FilterWithRegExp.ps1
#>

$text = Get-Content .\example_files\regdata.txt -Raw

# E-mailadressen: woord @ woord . woord
$hits = $text | Select-String -Pattern '\w+@\w+\.\w+' -AllMatches
Write-Output "Aantal e-mailadressen: $($hits.Matches.Count)"
$hits.Matches.Value

# URL's: http of https, dan :// en daarna woordtekens en punten
$hits = $text | Select-String -Pattern 'https?://[\w.]+' -AllMatches
Write-Output "`nAantal URL's: $($hits.Matches.Count)"
$hits.Matches.Value

# Datums: eerst de telefoonnummers verwijderen, dan dag/maand met 1-2 cijfers, gescheiden door /, - of ., jaar met 4 of 2 cijfers
$textWithoutPhones = $text -replace '(\+32 ?\d{3}|0\d{2,3})[ /]\d{2}\.\d{2}\.\d{2}', ''
$hits = $textWithoutPhones | Select-String -Pattern '\b\d{1,2}[/.-]\d{1,2}[/.-](\d{4}|\d{2})\b' -AllMatches
Write-Output "`nAantal datums: $($hits.Matches.Count)"
$hits.Matches.Value

# IP-adressen: 4 groepen van 1-3 cijfers met punten, zonder het subnetmasker (/24)
$hits = $text | Select-String -Pattern '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b' -AllMatches
Write-Output "`nAantal IP-adressen: $($hits.Matches.Count)"
$hits.Matches.Value

# Belgische telefoonnummers: zonenummer (0.. of +32 ...), dan / of spatie, dan xx.xx.xx
$hits = $text | Select-String -Pattern '(\+32 ?\d{3}|0\d{2,3})[ /]\d{2}\.\d{2}\.\d{2}' -AllMatches
Write-Output "`nAantal telefoonnummers: $($hits.Matches.Count)"
$hits.Matches.Value

# HTML-tags: < gevolgd door alles behalve >, dan >
$hits = $text | Select-String -Pattern '<[^>]+>' -AllMatches
Write-Output "`nAantal HTML-tags: $($hits.Matches.Count)"
$hits.Matches.Value