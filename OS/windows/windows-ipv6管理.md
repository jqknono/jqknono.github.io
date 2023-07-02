# windows-ipv6管理

```ps1
# 查看ipv6地址, 过滤locallink地址, 过滤Loopback地址
Get-NetIPAddress -AddressFamily IPv6 | Where-Object {$_.IPAddress -notlike "fe80*" -and $_.IPAddress -notlike "::1"} | Format-Table -AutoSize

# 查看ipv6路由
Get-NetRoute -AddressFamily IPv6

# 查看ipv6邻居
Get-NetNeighbor -AddressFamily IPv6

# 查看interface
Get-NetAdapter

# 使能临时ipv6地址
Set-NetIPv6Protocol -UseTemporaryAddress Enabled
```
