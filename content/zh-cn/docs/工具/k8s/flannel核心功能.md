---
title: flannel核心功能
---

# flannel 核心功能

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [配置](#配置)
- [VXLAN](#vxlan)
- [host-gw](#host-gw)
- [WireGuard](#wireguard)
- [UDP](#udp)

<!-- /TOC -->

Flannel 在每台主机上运行一个小的、单一的二进制代理 flanneld，并负责从一个较大的、预配置的地址空间中为每个主机分配子网租约。Flannel 使用 Kubernetes API 或直接使用 etcd 存储网络配置、已分配的子网和任何辅助数据（如主机的公共 IP）。使用多种后端机制，包括 VXLAN 和各种云集成，转发数据包。类似 Kubernetes 的平台假设集群中每个容器（Pod）都有一个唯一的可路由 IP。这种模型的优点是，它消除了共享单个主机 IP 所带来的端口映射复杂性。Flannel 负责为集群中的多个节点提供第三层 IPv4 网络。Flannel 不控制如何将容器网络连接到主机上，只负责在主机之间传输流量。Flannel 专注于网络。在网络策略方面，可以使用其他项目，如 Calico。

## 配置

如果 `--kube-subnet-mgr` 参数为 true，则 Flannel 从 `/etc/kube-flannel/net-conf.json` 读取其配置。如果 `--kube-subnet-mgr` 参数为 false，则 Flannel 从 etcd 读取其配置。默认情况下，它将从 `/coreos.com/network/config` 读取配置（可以使用 `--etcd-prefix` 进行覆盖）。

使用 etcdctl 工具将值设置到 etcd 中。

配置值是一个 JSON 字典，包含以下键：

- `Network`（字符串）：在 CIDR 格式下使用的 IPv4 网络，用于整个 Flannel 网络（如果 EnableIPv4 为 true，则为必填项）
- `IPv6Network`（字符串）：在 CIDR 格式下使用的 IPv6 网络，用于整个 Flannel 网络（如果 EnableIPv6 为 true，则为必填项）
- `EnableIPv4`（布尔型）：启用 IPv4 支持，默认为 `true`
- `EnableIPv6`（布尔型）：启用 IPv6 支持，默认为 `false`
- `SubnetLen`（整数）：分配给每个主机的子网的大小。默认为 24（即 /24），除非 `Network` 配置比 /22 小，此时它比网络小两个。
- `SubnetMin`（字符串）：子网分配应从其中开始的 IP 范围的开头。默认为 `Network` 的第二个子网。
- `SubnetMax`（字符串）：子网分配应以哪个 IP 范围结束。默认为 `Network` 的最后一个子网。
- `IPv6SubnetLen`（整数）：分配给每个主机的 IPv6 子网的大小。默认为 64（即 /64），除非 `Ipv6Network` 配置比 /62 小，此时它比网络小两个。
- `IPv6SubnetMin`（字符串）：子网分配应从其中开始的 IPv6 范围的开头。默认为 `Ipv6Network` 的第二个子网。
- `IPv6SubnetMax`（字符串）：子网分配应以哪个 IPv6 范围结束。默认为 `Ipv6Network` 的最后一个子网。
- `Backend`（字典）：要使用的后端类型和特定的配置。可在 [Backends](https://github.com/flannel-io/flannel/blob/master/Documentation/backends.md) 中列出可用的后端和可以放入该字典中的键。默认为 `vxlan` 后端。

示例：

```json
{
  "Network": "10.0.0.0/8",
  "EnableIPv4": true,
  "SubnetLen": 24,
  "SubnetMin": "10.10.0.0",
  "SubnetMax": "10.99.0.0",
  "IPv6Network": "2001:db8::/64",
  "EnableIPv6": true,
  "IPv6SubnetLen": 64,
  "IPv6SubnetMin": "2001:db8:1::",
  "IPv6SubnetMax": "2001:db8:ffff::",
  "Backend": {
    "Type": "vxlan",
    "VNI": 1
  }
}
```

## VXLAN

使用内核中的 VXLAN 来封装数据包。

类型和选项：

- `Type`（字符串）：`vxlan`
- `VNI`（数字）：要使用的 VXLAN 标识符（VNI）。在 Linux 上，默认值为 1。在 Windows 上，应大于或等于 4096。
- `Port`（数字）：用于发送封装包的 UDP 端口。在 Linux 上，默认为内核默认值，目前为 8472，但在 Windows 上，必须为 4789。
- `GBP`（布尔型）：启用 VXLAN 基于组的策略。默认为 `false`。Windows 上不支持 GBP
- `DirectRouting`（布尔型）：启用直接路径（如 `host-gw`），当主机在同一子网上时, 将会启用直接路径。VXLAN 将仅用于封装发送到不同子网的主机的数据包。默认为 `false`。Windows 上不支持直接路径。
- `MacPrefix`（字符串）：仅在 Windows 上使用，设置为 MAC 前缀。默认为 `0E-2A`。

## host-gw

使用 host-gw 通过远程机器 IP 创建到子网的 IP 路由。**需要在运行 Flannel 的主机之间直接层 2 连接性。**

host-gw 提供良好的性能，具有很少的依赖关系，易于设置。

类型：

- `Type`（字符串）：`host-gw`

## WireGuard

使用内核中的 [WireGuard](https://www.wireguard.com/) 来封装和加密数据包。

类型：

- `Type`（字符串）：`wireguard`
- `PSK`（字符串）：可选。要使用的预共享密钥。使用 `wg genpsk` 生成密钥。
- `ListenPort`（整数）：可选。要侦听的 udp 端口。默认为 `51820`。
- `ListenPortV6`（整数）：可选。ipv6 侦听的 udp 端口。默认为 `51821`。
- `Mode`（字符串）：可选。
  - separate-为 ipv4 和 ipv6 使用单独的 WireGuard 隧道（默认值）
  - auto-为两个地址族使用单个 WireGuard 隧道; 自动确定首选的对等地址
  - ipv4-为两个地址族使用单个 WireGuard 隧道;使用 ipv4 作为对等地址
  - ipv6-为两个地址族使用单个 WireGuard 隧道;使用 ipv6 作为对等地址
- `PersistentKeepaliveInterval`（整数）：可选。默认为 0（禁用）。

如果在生成私钥之前未生成私钥，则私钥将写入 `/run/flannel/wgkey`。可以使用环境变量 `WIREGUARD_KEY_FILE` 来更改此路径。

接口的静态名称为 `flannel-wg` 和 `flannel-wg-v6`。WireGuard 工具（如 `wg show`）可用于调试接口和对等体。

内核版本小于 5.6 的用户需要[安装](https://www.wireguard.com/install/)附加的 Wireguard 软件包。

## UDP

如果您的网络和内核禁止使用 VXLAN 或 host-gw，则**仅用于调试**使用 UDP。

类型和选项：

- `Type`（字符串）：`udp`
- `Port`（数字）：用于发送封装包的 UDP 端口。默认值为 8285。
