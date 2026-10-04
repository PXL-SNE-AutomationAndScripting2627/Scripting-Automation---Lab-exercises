$firefox = (Get-ChildItem -Path 'C:\Program Files' -Filter firefox.exe -Recurse -ErrorAction SilentlyContinue).FullName
Write-Host "Firefox gevonden op: $firefox"

New-NetFirewallRule -DisplayName 'Blokkeer Firefox' -Direction Outbound -Program $firefox -Action Block
Pause

Get-NetFirewallRule -DisplayName 'Blokkeer Firefox'
Pause

Disable-NetFirewallRule -DisplayName 'Blokkeer Firefox'
Write-Host 'Regel uitgeschakeld'
Pause
Enable-NetFirewallRule -DisplayName 'Blokkeer Firefox'
Write-Host 'Regel ingeschakeld'
Pause

Remove-NetFirewallRule -DisplayName 'Blokkeer Firefox'
Write-Host 'Regel verwijderd'