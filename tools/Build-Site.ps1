$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$scriptsDirectory = Join-Path $repositoryRoot 'scripts'
$scriptsPagePath = Join-Path $repositoryRoot 'scripts.html'
$startMarker = '<!-- SCRIPT_LINKS_START -->'
$endMarker = '<!-- SCRIPT_LINKS_END -->'

$scriptFiles = Get-ChildItem -LiteralPath $scriptsDirectory -File -Filter '*.ps1' |
    Sort-Object Name

$html = [System.IO.File]::ReadAllText($scriptsPagePath)
$startIndex = $html.IndexOf($startMarker, [System.StringComparison]::Ordinal)
$endIndex = $html.IndexOf($endMarker, [System.StringComparison]::Ordinal)

if ($startIndex -lt 0 -or $endIndex -lt 0 -or $startIndex -ge $endIndex) {
    throw "Could not find the script link markers in '$scriptsPagePath'."
}

if ($html.IndexOf($startMarker, $startIndex + $startMarker.Length, [System.StringComparison]::Ordinal) -ge 0 -or
    $html.IndexOf($endMarker, $endIndex + $endMarker.Length, [System.StringComparison]::Ordinal) -ge 0) {
    throw "Expected exactly one pair of script link markers in '$scriptsPagePath'."
}

$links = foreach ($file in $scriptFiles) {
    $encodedName = [System.Uri]::EscapeDataString($file.Name)
    $label = [System.Net.WebUtility]::HtmlEncode($file.Name)
    "          <li><a href=`"scripts/$encodedName`">$label</a></li>"
}

$generatedLinks = $links -join [Environment]::NewLine
$contentStart = $startIndex + $startMarker.Length
$updatedHtml = $html.Substring(0, $contentStart) +
    [Environment]::NewLine +
    $generatedLinks +
    [Environment]::NewLine +
    '          ' +
    $html.Substring($endIndex)

[System.IO.File]::WriteAllText(
    $scriptsPagePath,
    $updatedHtml,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Output "Updated script links in scripts.html for $($scriptFiles.Count) PowerShell scripts."
