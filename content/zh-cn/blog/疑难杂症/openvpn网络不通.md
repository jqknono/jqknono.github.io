---
layout: blog
categories: 教程
tags: [教程, 网络]
published: true
draft: false
title: openvpn网络不通
linkTitle: openvpn网络不通
date: 2024-06-28 17:18:48 +0800
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

- [ ] openvpn配置

# openvpn配置

## 工具脚本

[openvpn-install](https://github.com/angristan/openvpn-install)

## Windows防火墙配置

```ps1
New-NetFirewallRule -DisplayName "@openvpn" -Direction Inbound  -RemoteAddress 10.8.0.1/24 -Action Allow
New-NetFirewallRule -DisplayName "@openvpn" -Direction Outbound -RemoteAddress 10.8.0.1/24 -Action Allow
```
