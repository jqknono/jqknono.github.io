# 网络

## 添加网络

```ps1
New-VMSwitch -SwitchName "SwitchName" -SwitchType Internal
Get-NetAdapter
New-NetIPAddress -IPAddress 192.168.100.1 -PrefixLength 24 -InterfaceIndex 24
New-NetNat -Name MyNATnetwork -InternalIPInterfaceAddressPrefix 192.168.100.0/24
```
