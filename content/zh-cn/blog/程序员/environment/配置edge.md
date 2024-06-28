---
layout: blog
categories: 工具
tags: [工具, environment]
published: false
draft: true
title: 配置edge
linkTitle: 配置edge
date: 2024-06-28 16:39:58 +0800
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

- [ ] 配置edge

# 配置edge


[Browser policy reference](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies)

```bat
<!-- policy -->
reg delete "HKCU\Software\Policies\Microsoft\Edge" /f
reg delete "HKLM\Software\Policies\Microsoft\Edge" /f
```

