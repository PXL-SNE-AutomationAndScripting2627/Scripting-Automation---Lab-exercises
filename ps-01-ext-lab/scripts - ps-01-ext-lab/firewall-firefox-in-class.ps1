New-NetFirewallRule -DisplayName "Firefox blocker" -Direction Outbound -Program "C:\Program Files\Mozilla Firefox" -Action Block


Get-NetFirewallRule - Displayname *Firefox* | Set-NetFirewallRule -Action Allow

