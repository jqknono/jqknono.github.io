---
layout: blog
categories: 工具
tags: [工具, windows]
published: true
draft: false
title: wireguard配置
linkTitle: wireguard配置
date: 2024-06-28 17:11:32 +0800
toc: true
toc_hide: false
math: false
comments: false
giscus_comments: true
hide_summary: false
hide_feedback: false
description: 
weight: 100
---

- [ ] wireguard配置

# wireguard 配置

## 防火墙配置

```powershell
wireguard /installtunnelservice <wg_conf_path>
wg show
Get-NetConnectionProfile
Get-NetAdapter
Get-NetFirewallProfile
Set-NetFirewallProfile -Profile domain,public,private -DisabledInterfaceAliases <wg_config_name>
Set-NetIPInterface -ifindex <interface index> -Forwarding Enabled
New-NetFirewallRule -DisplayName "@wg1" -Direction Inbound  -RemoteAddress 10.66.66.1/24 -Action Allow
New-NetFirewallRule -DisplayName "@wg1" -Direction Outbound -RemoteAddress 10.66.66.1/24 -Action Allow
```

```powershell
# 定位拦截原因
auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable
wevtutil qe Security /q:"*[System/EventID=5152]" /c:5 /rd:true /f:text
auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable
```
