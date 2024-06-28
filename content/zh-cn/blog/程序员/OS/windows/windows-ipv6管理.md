---
layout: blog
categories: 教程
tags: [教程, windows]
published: true
draft: false
title: windows-ipv6管理
linkTitle: windows-ipv6管理
date: 2024-06-28 17:08:36 +0800
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

- [ ] windows-ipv6管理
# windows-ipv6 管理

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

# 获取interface 信息
Get-NetIPInterface -AddressFamily IPv6 -ifAlias Ethernet | Select-Object -Property *
Get-NetIPv6Protocol

# 设置interface 信息, 解决Windows IPv6地址不更新的问题
Set-NetIPInterface -AddressFamily IPv6 -ifAlias Ethernet -Dhcp Disabled
Set-NetIPInterface -AddressFamily IPv6 -ifAlias Ethernet -AdvertiseDefaultRoute Disabled
Set-NetIPInterface -AddressFamily IPv6 -ifAlias Ethernet -IgnoreDefaultRoutes Enabled
# 手动恢复ipv6访问
# Set-NetIPInterface -AddressFamily IPv6 -ifAlias Ethernet -RouterDiscovery Disabled
# Set-NetIPInterface -AddressFamily IPv6 -ifAlias Ethernet -RouterDiscovery Enabled

Set-NetIPv6Protocol -DhcpMediaSense Disabled
Set-NetIPv6Protocol -RandomizeIdentifiers Disabled
Set-NetIPv6Protocol -UseTemporaryAddresses Disabled
Set-NetIPv6Protocol -MaxTemporaryDesyncTime 0:3:0
Set-NetIPv6Protocol -MaxTemporaryPreferredLifetime 0:10:0
Set-NetIPv6Protocol -MaxTemporaryValidLifetime 0:30:0
Set-NetIPv6Protocol -TemporaryRegenerateTime 0:0:30
```
