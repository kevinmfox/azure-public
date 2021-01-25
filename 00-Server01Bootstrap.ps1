$id = "Server01"

New-Item -Path "C:\Bootstrap" -ItemType Directory

(New-Object System.Net.WebClient).DownloadFile(`
    "https://raw.githubusercontent.com/kevinmfox/azure-public/master/00-" + $id + "Bootstrap.ps1",`
    "C:\Bootstrap\00-" + $id + "Bootstrap.ps1")

(New-Object System.Net.WebClient).DownloadFile(`
    "https://raw.githubusercontent.com/kevinmfox/azure-public/master/01-" + $id + "Bootstrap.ps1",`
    "C:\Bootstrap\01-" + $id + "Bootstrap.ps1")

Register-ScheduledTask `
    -TaskName ("01" + $id + "Bootstrap") `
    -Action (New-ScheduledTaskAction `
        -Execute powershell.exe `
        -Argument ("C:\Bootstrap\01-" + $id + "Bootstrap.ps1")) `
    -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(30)) `
    -Principal (New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest)