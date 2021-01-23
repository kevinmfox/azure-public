﻿function GeneratePassword([Int]$Length)
{
    $chars = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPRSTUVWXYZ23456789"
    $password = ""
    for ($i = 0; $i -lt $Length; $i++)
    {
        $password += $chars.ToCharArray() | Get-Random
    }
    return $password
}

Unregister-ScheduledTask -TaskName 01DC01Bootstrap -Confirm:$false

$safeModePassword = GeneratePassword -Length 32

$safeModePassword | Out-File -FilePath "C:\Bootstrap\SafeMode.txt" -Append:$false -Force

Install-ADDSForest `
    -SkipPreChecks `
    -DomainName fox.local `
    -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $safeModePassword -Force) `
    -CreateDnsDelegation:$false `
    -DomainMode WinThreshold `
    -DomainNetbiosName FOX `
    -ForestMode WinThreshold `
    -InstallDns `
    -Force