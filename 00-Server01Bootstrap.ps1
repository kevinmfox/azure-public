New-Item -Path "C:\Bootstrap" -ItemType Directory

(New-Object System.Net.WebClient).DownloadFile(`
    "https://raw.githubusercontent.com/kevinmfox/azure-public/master/00-Server01Bootstrap.ps1",`
    "C:\Bootstrap\01-Server01Bootstrap.ps1")

Install-WindowsFeature -Name Web-Server -IncludeManagementTools