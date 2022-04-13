# Ethernet or WLAN or WireGuard TUN VPN
$adaptersOfInterest = Get-NetAdapter | Where-Object { ($_.HardwareInterface -eq $true) -or ( $_.InterfaceType -eq 53 ) }
$connectionOfInterest = Get-NetConnectionProfile | Where-Object { $_.InterfaceIndex -in ($adaptersOfInterest  | Select-Object -ExpandProperty InterfaceIndex)}
# One interface may contain ipv4 and ipv6 addresses
$connectionIPs = Get-NetIPAddress | Where-Object { $_.InterfaceIndex -in ($connectionOfInterest | Select-Object -ExpandProperty InterfaceIndex)}

$result = @()

foreach ($c in $connectionOfInterest) {

    $ipv4 = $connectionIPs | Where-Object { ($_.InterfaceIndex -eq $c.InterfaceIndex) -and ($_.AddressFamily -eq "IPv4") } | Select-Object -ExpandProperty IPAddress
    $ipv6 = $connectionIPs | Where-Object { ($_.InterfaceIndex -eq $c.InterfaceIndex) -and ($_.AddressFamily -eq "IPv6") } | Select-Object -ExpandProperty IPAddress

    $adapterInterfaceType = $adaptersOfInterest | Where-Object { $_.InterfaceIndex -eq $c.InterfaceIndex } | Select-Object -ExpandProperty InterfaceType

    $result += [pscustomobject] @{        

        Name = $c.Name
        AliasName = $c.InterfaceAlias

        InterfaceIndex = $c.InterfaceIndex
        InterfaceType = $adapterInterfaceType

        IPv4Connectivity = $c.IPv4Connectivity
        IPv6Connectivity = $c.IPv6Connectivity

        IPv4Address = $ipv4 
        IPv6Address = $ipv6
    }
}

$result | ConvertTo-Json 

