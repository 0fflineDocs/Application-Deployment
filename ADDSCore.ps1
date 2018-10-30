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

[Reboot]

#DHCP
$Computername = "DC01.SH.com"
$Domain = "SH.com"
$DHCPScope = "SHNet"
$DCIP = "6.6.0.6"

#DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 6.6.0.6

#Create DHCP security groups
netsh dhcp add securitygroups
Restart-service dhcpserver

Add-DhcpServerInDC -DnsName $Computername -IPAddress $DCIP
Get-DhcpServerInDC

#Display domain\user for DNS
whoami

$Credential = Get-Credential
Set-DhcpServerDnsCredential -Credential $Credential -ComputerName $Computername

#Set DHCP Scope
Set-DhcpServerv4DnsSetting -ComputerName $Computername -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True
Add-DhcpServerv4Scope -name $DHCPScope -StartRange 6.6.0.1 -EndRange 6.6.0.254 -SubnetMask 255.255.255.0 -State Active
Add-DhcpServerv4ExclusionRange -ScopeID 6.6.0.0 -StartRange 6.6.0.1 -EndRange 6.6.0.10
Set-DhcpServerv4OptionValue -OptionID 3 -Value 6.6.0.1 -ScopeID 6.6.0.0 -ComputerName $Computername
Set-DhcpServerv4OptionValue -DnsDomain $Domain -DnsServer $DCIP
