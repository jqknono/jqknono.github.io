---
layout: page
title: WindowsServer桥接时的IPv6问题
published: true
categories: 运维
tags: 
  - 运维
  - blog
date: 2023-05-06 11:47:48
---

- [ ] WindowsServer 桥接时的 IPv6 问题

现在很多用作软路由的机器硬件配置较好, 仅安装一个 openwrt 大材小用, 基本都会自己折腾一下去榨干它的价值. Linux 的难点在于命令行, 其实命令行用的多的能感受到这也是 linux 的容易之处.

外网访问需求基本爱折腾的人都会遇到, 考虑到 linux 不太有专业的人维护, 安全补丁更新较慢, 衡量后会有部分人决定使用 Windows Server 系统. 原本 openwrt 上的软件则使用 wsl 加 docker 方式运行, 所有需求都可以同样满足.

在 Windows(Server)桥接多个网络时, 会出现 IPv6 地址无法更新的问题, 但是 IPv4 可以正常访问. 由于 IPv6 的地址是运营商自动分配的, 无法手动修改, 所以需要修改桥接的网络配置.

## 参考

- [Network Bridge for ipv6](https://forums.tomshardware.com/threads/network-bridge-for-ipv6.3118590/)

> Generally, bridging is purely layer 2 so no IP address is required, so just like an unmanaged switch should be iPv6 capable.
>
> However, if you can plug the bridge into a switch and more than one client at a time can have internet access through the bridge, then IPv6 will most likely only work with one of the clients because the main router handling IPv6 connections can only see the bridge's MAC address. I'm not sure how SLAAC decides which client gets the IPv6 but you could test this out with a switch.
>
> DHCP is of course for IPv4. It may be possible to use stateful DHCPv6 to assign DUIDs to each client and make this work but I have no idea how this would be done. Good luck!

解释下, 由于桥接是二层的, 所以不需要 IP 地址, 但是如果桥接的网络连接到交换机, 交换机上的路由器只能看到桥接的 MAC 地址, 无法分辨出桥接的多个设备, 所以只能给其中一个设备分配 IPv6 地址.

- [请问 windows 多网卡卡如何实现交换机功能](https://www.chiphell.com/forum.php?mod=viewthread&tid=2458976&extra=page%3D1&mobile=no)

![picture 2](https://s2.loli.net/2023/05/06/y7mtlGhBWjA82Es.png)

一份标准可联网的配置如下:

```bat
PS C:\Users\jqkno> netsh interface ipv6 show interface "wi-fi"

Interface Wi-Fi Parameters
----------------------------------------------
IfLuid                             : wireless_32768
IfIndex                            : 24
State                              : connected
Metric                             : 45
Link MTU                           : 1480 bytes
Reachable Time                     : 29000 ms
Base Reachable Time                : 30000 ms
Retransmission Interval            : 1000 ms
DAD Transmits                      : 1
Site Prefix Length                 : 64
Site Id                            : 1
Forwarding                         : disabled
Advertising                        : disabled
Neighbor Discovery                 : enabled
Neighbor Unreachability Detection  : enabled
Router Discovery                   : enabled
Managed Address Configuration      : enabled
Other Stateful Configuration       : enabled
Weak Host Sends                    : disabled
Weak Host Receives                 : disabled
Use Automatic Metric               : enabled
Ignore Default Routes              : disabled
Advertised Router Lifetime         : 1800 seconds
Advertise Default Route            : disabled
Current Hop Limit                  : 64
Force ARPND Wake up patterns       : disabled
Directed MAC Wake up patterns      : disabled
ECN capability                     : application
RA Based DNS Config (RFC 6106)     : enabled
DHCP/Static IP coexistence         : enabled
```

修改设置方法: `netsh interface ipv6 set interface "Network Bridge" managedaddress=enabled`