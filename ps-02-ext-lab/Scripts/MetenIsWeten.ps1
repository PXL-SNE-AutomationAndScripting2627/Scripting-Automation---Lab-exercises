<#
.SYNOPSIS
Shows the amount of lines, words and characters inside mydata.txt

.DESCRIPTION
This script counts all the amounts.

.EXAMPLE
.\MetenIsWeten.ps1
Shows the amount of lines, words and characters inside mydata.txt
#>



$sourcefile = 'C:\Projects\ps-01-ext-lab-AngeloSwitonPXL\ps-02-ext-lab\example_files\mydata.txt'
$linecount = (Get-Content $sourcefile | Measure-Object -Line).Lines
$wordcount = (Get-Content $sourcefile | Measure-Object -Word).Words
$charcount = (Get-Content $sourcefile | Measure-Object -Character).Characters

Write-Output "The file mydata.txt contains"
Write-Output "$linecount line(es)"
Write-Output "$wordcount word(s)"
Write-Output "$charcount character(s)"