---
layout: blog
title: 利用DNS服务平滑切换网络服务
linkTitle: 利用DNS服务平滑切换网络服务
published: true
categories: 网络
tags: [网络, adguard系列]
date: 2024-06-12 19:00:34 +0800
draft: false
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

假设服务域名为`example.domain`, 原服务器 IP 地址为`A`, 由于服务器迁移或 IP 更换, 新服务器 IP 地址为`B`, 为了保证用户无感知, 可以通过 DNS 服务平滑切换网络服务.

1. 原服务状态, `example.domain` 解析到 IP 地址`A`
1. 过渡状态, `example.domain` 解析到 IP 地址`A` 和`B`
1. 新服务状态, `example.domain` 解析到 IP 地址`B`, 移除 IP 地址`A`

说明: 当用户获得两个解析地址时, 客户端会选择其中一个地址进行连接, 当连接失败时, 会尝试其它地址, 以此保证服务的可用性.

由于 DNS 解析存在缓存, 为了保证平滑切换, 需要在过渡状态保持一段时间, 以确保所有缓存失效.

我这里需要迁移的是 dns 服务, 可以在过渡状态中设置`DNS重写`, 加快迁移过程.

A 服务重写规则:

![A服务重写](https://s2.loli.net/2024/06/12/xRFMB1PTIcvUQHr.png)

B 服务重写规则:

![B服务重写](https://s2.loli.net/2024/06/12/DILEi9jJoVYeuT2.png)

原迁移过程拓展为:

1. 原服务状态, `example.domain` 解析到 IP 地址`A`
1. 过渡状态, `example.domain` 在`dns A`服务中重写到`A`和`B`, 在`dns B`服务中重写到`B`
1. 新服务状态, `example.domain` 解析到 IP 地址`B`, 移除 IP 地址`A`

当用户仍在使用`dns A`服务时, 可以获得两个地址, 有一半的概率会选择`dns A`服务.  
另外一半的概率会切换到`dns B`服务, `dns B`服务故障时切换回`dns A`. `dns B`服务未故障时, 将只会获得一个地址, 因而用户会停留在`dns B`服务中.  
这样我们可以逐步的减少`dns A`服务的资源消耗, 而不是直接停止, 实现更平滑的迁移.
