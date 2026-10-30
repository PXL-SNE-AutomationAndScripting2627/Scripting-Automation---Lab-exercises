<#
.SYNOPSIS
This script shows the content of the file C:\Windows\System32\drivers\etc\hosts

.DESCRIPTION
Shows content of the file C:\Windows\System32\drivers\etc\hosts

.EXAMPLE
.\WindowsHostFile.ps1
Shows the content of the file C:\Windows\System32\drivers\etc\hosts


#>


$path = 'C:\Windows\System32\drivers\etc\hosts'

Write-Host "Inhoud van de Windows file: $path" -ForegroundColor Yellow
Get-Content -Path $path