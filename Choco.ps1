#Requires -RunAsAdministrator
#Requires -Version 5
[CmdletBinding(SupportsShouldProcess)]
$time1 = Get-Date
Write-Host "setting up chocolatey" -ForegroundColor Green
if (!(Test-Path "$env:PROGRAMDATA\chocolatey\choco.exe")) {
    Write-Verbose "installing chocolatey"
    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-Verbose "chocolatey has been installed. yay!"
    }
    catch {
        Write-Warning "failed to install chocolatey..."
        Write-Warning $_.Exception.Message
        break
    }
}
else {
    Write-Verbose "chocolatey is already installed. yay!"
}
Write-Verbose "installing packages from internal list"
$pkgs = "7zip,notepadplusplus,firefox,vscode,vscode-powershell,visualstudio2017community,googlechrome,treesizefree"
$count = 0
foreach ($pkg in $pkgs -split ',') {
    if ($WhatIfPreference) {
        choco install $pkg -whatif
    }
    else {
        choco install $pkg -y
    }
    $count++
}
Write-Host "finished!"-ForegroundColor Green
$time2 = Get-Date
$ts = $time2 - $time1
Write-Host $("$count packages installed. Elapsed time: {0:g}" -f $ts) -ForegroundColor Green
