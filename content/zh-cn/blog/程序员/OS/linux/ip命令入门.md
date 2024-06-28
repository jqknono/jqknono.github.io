---
layout: blog
categories: 工具
tags: [工具, linux]
published: false
draft: true
title: ip命令入门
linkTitle: ip命令入门
date: 2024-06-28 17:06:18 +0800
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

- [ ] ip命令入门

# ip 命令入门

## 帮助

```shell
qt@minikube:~$ ip
Usage: ip [ OPTIONS ] OBJECT { COMMAND | help }
       ip [ -force ] -batch filename
where  OBJECT := { address | addrlabel | fou | help | ila | ioam | l2tp | link |
                   macsec | maddress | monitor | mptcp | mroute | mrule |
                   neighbor | neighbour | netconf | netns | nexthop | ntable |
                   ntbl | route | rule | sr | tap | tcpmetrics |
                   token | tunnel | tuntap | vrf | xfrm }
       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] |
                    -h[uman-readable] | -iec | -j[son] | -p[retty] |
                    -f[amily] { inet | inet6 | mpls | bridge | link } |
                    -4 | -6 | -M | -B | -0 |
                    -l[oops] { maximum-addr-flush-attempts } | -br[ief] |
                    -o[neline] | -t[imestamp] | -ts[hort] | -b[atch] [filename] |
                    -rc[vbuf] [size] | -n[etns] name | -N[umeric] | -a[ll] |
                    -c[olor]}
```

## OBJECT

| OBJECT     | 说明                 |
| ---------- | -------------------- |
| address    | 管理网络接口地址     |
| addrlabel  | 管理地址标签         |
| fou        | 管理 Fou 隧道        |
| help       | 显示帮助             |
| ila        | 管理 ILA 隧道        |
| ioam       | 管理 IOAM 隧道       |
| l2tp       | 管理 L2TP 隧道       |
| link       | 管理网络接口         |
| macsec     | 管理 MACsec 隧道     |
| maddress   | 管理多播地址         |
| monitor    | 监控网络事件         |
| mptcp      | 管理 MPTCP 隧道      |
| mroute     | 管理多播路由         |
| mrule      | 管理多播规则         |
| neighbor   | 管理邻居             |
| neighbour  | 管理邻居             |
| netconf    | 管理 Netconf         |
| netns      | 管理网络命名空间     |
| nexthop    | 管理下一跳           |
| ntable     | 管理路由表           |
| ntbl       | 管理路由表           |
| route      | 管理路由             |
| rule       | 管理路由规则         |
| sr         | 管理 Segment Routing |
| tap        | 管理 Tap 设备        |
| tcpmetrics | 管理 TCP 指标        |
| token      | 管理令牌             |
| tunnel     | 管理隧道             |
| tuntap     | 管理 Tun/Tap 设备    |
| vrf        | 管理虚拟路由转发     |
| xfrm       | 管理 IPsec 转换      |

## OPTIONS

| OPTIONS                                               | 说明                       |
| ----------------------------------------------------- | -------------------------- |
| -V[ersion]                                            | 显示版本信息               |
| -s[tatistics]                                         | 显示统计信息               |
| -d[etails]                                            | 显示详细信息               |
| -r[esolve]                                            | 显示主机名                 |
| -h[uman-readable]                                     | 显示人类可读的信息         |
| -iec                                                  | 显示 IEC 单位              |
| -j[son]                                               | 显示 JSON 格式             |
| -p[retty]                                             | 显示漂亮的格式             |
| -f[amily] { inet \| inet6 \| mpls \| bridge \| link } | 显示指定协议族的信息       |
| -4                                                    | 显示 IPv4 信息             |
| -6                                                    | 显示 IPv6 信息             |
| -M                                                    | 显示 MPLS 信息             |
| -B                                                    | 显示 Bridge 信息           |
| -0                                                    | 显示 Link 信息             |
| -l[oops] { maximum-addr-flush-attempts }              | 设置最大地址刷新尝试次数   |
| -br[ief]                                              | 显示简要信息               |
| -o[neline]                                            | 显示单行信息               |
| -t[imestamp]                                          | 显示时间戳                 |
| -ts[hort]                                             | 显示短时间戳               |
| -b[atch] [filename]                                   | 批量处理                   |
| -rc[vbuf] [size]                                      | 设置接收缓冲区大小         |
| -n[etns] name                                         | 显示指定网络命名空间的信息 |
| -N[umeric]                                            | 显示数字信息               |
| -a[ll]                                                | 显示所有信息               |
| -c[olor]                                              | 显示彩色信息               |

## 参考

  - [Linux ip命令详解](https://www.codeplayer.org/Wiki/Router/Linux%20ip%E5%91%BD%E4%BB%A4%E8%AF%A6%E8%A7%A3.html)