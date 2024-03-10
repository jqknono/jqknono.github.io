---
title: openvpn配置
---

# openvpn配置

## 工具脚本

[openvpn-install](https://github.com/angristan/openvpn-install)

## Windows防火墙配置

```ps1
New-NetFirewallRule -DisplayName "@openvpn" -Direction Inbound  -RemoteAddress 10.8.0.1/24 -Action Allow
New-NetFirewallRule -DisplayName "@openvpn" -Direction Outbound -RemoteAddress 10.8.0.1/24 -Action Allow
```
