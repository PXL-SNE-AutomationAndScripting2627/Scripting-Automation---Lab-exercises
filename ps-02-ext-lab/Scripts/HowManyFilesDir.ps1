<#

.SYNOPSIS
    Shows the amount of files, directories and processes.

.DESCRIPTION
    This script counts the amount of files en directories directly inside C:\Windows and the amount of active processes on the system.

.EXAMPLE
    .\HowmanyFilesDir.ps1
    Shows the amounts for C:\Windows and the amount of processes.


#>


$path = 'C:\Windows\'
$filecount = (Get-ChildItem $path).Count
$dircount = (Get-ChildItem $path -Directory).Count
$procount = (Get-Process).Count

Write-Output "Information of path: $path"
Write-Output "File count: $filecount"
Write-Output "Directory count: $dircount"
Write-Output "Amount of processes: $procount"