$ipAddress = "10.0.1.200"
$defaultGateway = "10.0.1.1"

New-Item -Path "C:\Bootstrap" -ItemType Directory

$webClient = New-Object System.Net.WebClient
$credCache = New-Object System.Net.CredentialCache
$creds = New-Object System.Net.NetworkCredential("bootstrap", "6p3bt7u2f2xk3i7o3hw2qfxqmgyvo7h6tqys4nwlggxbf2zkawna")
$credCache.Add("url", "Basic", $creds)
$webClient.Credentials = $credCache
$webClient.DownloadFile(`
    "https://dev.azure.com/kevinmfox/azure/_apis/sourceProviders/TfsGit/filecontents?repository=PowerShell&path=%2FConfigurations%2F00-DC01Bootstrap.ps1&commitOrBranch=main",`
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

Rename-Computer -NewName DC01 -Restart