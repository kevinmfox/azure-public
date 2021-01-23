$ipAddress = "192.168.40.20"
$defaultGateway = "192.168.40.1"

New-Item -Path "C:\Bootstrap" -ItemType Directory

(New-Object System.Net.WebClient).DownloadFile(`
    "https://raw.githubusercontent.com/kevinmfox/azure-public/master/01-DC01Bootstrap.ps1",`
    "C:\Bootstrap\01-DC01Bootstrap.ps1")

New-NetIPAddress -IPAddress $ipAddress -InterfaceAlias Ethernet0 -DefaultGateway $defaultGateway -AddressFamily IPv4 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias Ethernet0 -ServerAddresses 127.0.0.1, 8.8.8.8

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Register-ScheduledTask `
    -TaskName 01DC01Bootstrap `
    -Action (New-ScheduledTaskAction `
        -Execute powershell.exe `
        -Argument "C:\Bootstrap\01-DC01Bootstrap.ps1") `
    -Trigger (New-ScheduledTaskTrigger -AtStartup) `
    -Principal (New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest)

Start-Sleep -Seconds 120

Rename-Computer -NewName DC01 -Restart