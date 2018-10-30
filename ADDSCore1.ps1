#Network Config + DNS (Check Get-NetAdapter)
$ipaddress = "6.6.0.6"
$dnsaddress = "127.0.0.1"
$gateway = "6.6.0.1"
New-NetIPAddress -InterfaceAlias Ethernet -IPAddress $ipaddress -DefaultGateway $gateway -AddressFamily IPv4 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dnsaddress

#Set TimeZone
Set-Timezone -id "W. Europe Standard Time"

#Install AD
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -Verbose

#Install Domain
Install-ADDSForest -DomainName SH.com

Write-Host "Reboot"
