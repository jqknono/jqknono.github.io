---
layout: blog
categories: 系统
tags: [系统, windows]
published: true
draft: false
title: Windows防火墙管理-netsh
linkTitle: Windows防火墙管理-netsh
date: 2024-06-28 17:10:36 +0800
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

- [ ] Windows防火墙管理-netsh

# Windows 防火墙管理-netsh

## 管理工具

## netsh advfirewall

```ps1
# 导出防火墙规则
netsh advfirewall export advfirewallpolicy.wfw

# 导入防火墙规则
netsh advfirewall import advfirewallpolicy.wfw

# 查看防火墙状态
netsh advfirewall show allprofiles state

# 查看防火墙默认规则
netsh advfirewall show allprofiles firewallpolicy
# netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound
# netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

# 查看防火墙设置
netsh advfirewall show allprofiles settings

# 启用防火墙
netsh advfirewall set allprofiles state on

# 禁用防火墙
netsh advfirewall set allprofiles state off

# 查看防火墙规则
netsh advfirewall firewall show rule name=all

# 查看防火墙状态
netsh advfirewall monitor show firewall
```

## netsh firewall(deprecated)

```ps1
# 查看防火墙状态
netsh firewall show state
```

## netsh mbn(Mobile Broadband network)

## netsh wfp

```ps1
# 查看防火墙状态
netsh wfp show state

# 查看防火墙规则
netsh wfp show filters
```
