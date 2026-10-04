Stop-Process -Name notepad -ErrorAction SilentlyContinue
1..4 | ForEach-Object { Start-Process notepad -Windowstyle Maximized }
