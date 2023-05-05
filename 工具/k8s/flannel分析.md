# flannel 分析

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [vxlan](#vxlan)
  - [firewall 规则分析](#firewall-规则分析)
  - [源码分析](#源码分析)
- [host-gw](#host-gw)
- [udp](#udp)
- [wireguard](#wireguard)
- [ipip](#ipip)
- [总结](#总结)
- [参考](#参考)

<!-- /TOC -->

Flannel 可以使用多种功能 backend, 设置好后不能在运行时进行更改.

- `vxlan` 官方推荐使用, 也是实际使用场景中较多使用的.
- `hostgw` 需要二层直连能力, 通常云环境不支持.
- `UDP` 当内核版本比较低，不支持 vxlan 和 host-gw 模式的时候，可以使用 UDP 模式.
- `IPIP` 模式, IPIP 类型的隧道是最简单的一种.它的开销最低，但只能封装 IPv4 单播流量.
- `WireGuard` 在内核中使用 WireGuard 来封装和加密数据包.

**我们需要确认 Flannel 使用了何种 backend.**

下面调研中可以看到 hostgw 方式相较于 vxlan 方式, 有一些性能上的优势. 主要是因为 hostgw 方式不需要封装.

除非明确指定, subnet 的配置文件路径为`/var/run/flannel/subnet.env`.

```bash
root@k8s-master:~# cat /var/run/flannel/subnet.env

FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.0.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
```

配置含义:

- FLANNEL_NETWORK 的第 17 到 24 位, 用于分配给每个节点 node, cni 网卡的网段
  - 查看: `ip addr`
- FLANNEL_SUBNET 的第 25 到 32 位, 用于分配给每个 pod
  - 查看: `kubectl get pods -o wide`

flannel 启动时需要选定一个唯一的 IP, 作为对外访问的接口, 如果这个 IP 变化, 那么需要重新启动 flannel.

<!--
**性能**

控制面: 性能消耗在检查是否有合适的资源, 以及 etcd 或者 kubernetes API 的通信.
数据面: 数据面的性能是需要优先检查.

1. backend 的类型非常重要, 为了更好的性能, 应避免使用封装.
2. MTU 的大小也非常重要, 要接近原始带宽, 网络应设置较大的 MTU. MTU 配置在`subnet.env`中. -->

**Firewalls**

https://github.com/flannel-io/flannel/blob/master/Documentation/troubleshooting.md#firewalls

- 使用`udp`后端时, 需要确保`udp`端口`8285`是开放的.
- 使用`vxlan`后端时, 需要确保`udp`端口`8472`是开放的.
- 使用`wireguard`后端时, 需要确保`udp`端口`51820`是开放的, ipv6 端口`51821`也需要开放.
- 确保您的防火墙规则允许所有参与覆盖网络的主机使用此流量
- 确保允许 pod 访问 master 节点

**k8s 要求特性**

- 确保每个 node 已经有 podCIDR
- 使用`kubeadm init`创建集群时, 传入`--pod-network-cidr=10.244.0.0/16`可以自动给每个 node 分配 podCIDR
- 也可以手动指定`podCIDR`, 但是需要确保每个 node 的`podCIDR`不重复

## vxlan

### firewall 规则分析

flannel 工具使用 SNAT 和 DNAT 进行网络隔离.

SNAT 用于把真实的源 IP 隐藏起来，而 DNAT 则是把真实的目标 IP 隐藏起来.

SNAT 发生在 iptables 的 nat Table 的 **POSTROUTING** Chain 上，正好在发送到网卡前的最后一步，对应的是 outbound 流量.
所以 filter 规则/路由规则会看到没有被修改的包.
Masquerading 是 SNAT 的特殊形式，在 iptables 中，只允许被用在动态分配 IP 地址的情况下.

MASQUERADE 从服务器的网卡上，自动获取当前 ip 地址来做 NAT，就不用手动指定转换的目的 IP 了，实现了动态的 SNAT.

DNAT 发生在 iptables 的 nat Table 的 **PREROUTING** Chain 上，正好在刚接收到包的之后一步，对应的是 inbound 流量.
所以 filter 规则/路由规则会看到“真实”的目标 IP.
Redirection 是 DNAT 的一种特殊形式，是对 来流数据的网卡地址做 DNAT 的一种便捷方式.

以下只添加了一个最简单且常用的例子进行分析.

- 创建了一个 deployment, 该 deployment 会创建一个 2 个 replicas 的 nginx pod, 在 8080 端口上提供服务
- 创建了一个 service, 映射 8080 到随机端口
- 使用 NodePort 方式暴露服务

运行 flannel 后将会增加一些网卡, 下面结合原有网卡进行解释:

- lo：回环网卡
- ens160：物理网卡
- cni0：flannel 网卡
- flannel.1：flannel 网卡
- veth0cf76916@if3：veth pair，连接 docker0 和 Pod 中的容器.veth pair 可以理解为使⽤⽹线连接好的两个接⼝，把两个端⼝放到两个 namespace 中，那么这两个 namespace 就能打通.
- docker0: bridge ⽹络，docker 默认使⽤的⽹卡，作为该节点上所有容器的虚拟交换机

| 主机    | ens33           | flannel:ip    | flannel:link/ether | cni:ip        | cni:link          | veth:link                                                  |
| ------- | --------------- | ------------- | ------------------ | ------------- | ----------------- | ---------------------------------------------------------- |
| masater | 192.168.205.145 | 10.244.0.0/32 | 1e:ba:40:05:f2:71  | 10.244.0.1/24 | 02:59:fe:44:d5:48 | 2[16:56:74:69:00:78, 4e:ac:68:e7:47:d7]                    |
| node1   | 192.168.205.146 | 10.244.1.0/32 | 62:2d:70:9c:01:ac  | 10.244.1.1/24 | 12:c2:49:c9:5d:4f | 4[...]                                                     |
| node2   | 192.168.205.147 | 10.244.2.0/32 | 66:10:a3:c1:2b:47  | 10.244.2.1/24 | 1a:1e:b0:ef:a6:21 | 3[5e:1e:1c:89:0e:8d, 82:f1:46:9c:f3:42, 7e:4d:de:2b:4f:a7] |

以下是 node2 的路由和 arp 信息

```bash
root@k8s-worker2:/# ip route
# Destination Gateway Iface, 跳转到flannel
default via 192.168.205.2 dev ens33 proto dhcp metric 100
10.244.0.0/24 via 10.244.0.0 dev flannel.1 onlink
**10.244.1.0/24** via 10.244.1.0 dev flannel.1 onlink
10.244.2.0/24 dev cni0 proto kernel scope link src 10.244.2.1

root@k8s-worker2:/# ip neigh
# arp表, 根据ip获取mac地址
192.168.205.145 dev ens33 lladdr 00:0c:29:1a:33:7e REACHABLE
10.244.0.0 dev flannel.1 lladdr 1e:ba:40:05:f2:71 PERMANENT
10.244.1.0 dev flannel.1 lladdr **62:2d:70:9c:01:ac** PERMANENT

root@k8s-worker2:/# bridge fdb
# FDB表, 获取ip地址
02:70:b4:25:55:5a dev flannel.1 dst 192.168.205.145 self permanent
1e:ba:40:05:f2:71 dev flannel.1 dst 192.168.205.145 self permanent
62:2d:70:9c:01:ac dev flannel.1 dst **192.168.205.146** self permanent
22:a2:ad:e8:8e:33 dev flannel.1 dst 192.168.205.146 self permanent
1a:1e:b0:ef:a6:21 dev cni0 vlan 1 master cni0 permanent
1a:1e:b0:ef:a6:21 dev cni0 master cni0 permanent
5e:1e:1c:89:0e:8d dev veth65f02aea vlan 1 master cni0 permanent
5e:1e:1c:89:0e:8d dev veth65f02aea master cni0 permanent
82:f1:46:9c:f3:42 dev vethb426ba0a vlan 1 master cni0 permanent
82:f1:46:9c:f3:42 dev vethb426ba0a master cni0 permanent
7e:4d:de:2b:4f:a7 dev veth1a2c02c0 vlan 1 master cni0 permanent
7e:4d:de:2b:4f:a7 dev veth1a2c02c0 master cni0 permanent
```

- RIB(Route Information Base) 表, 路由表
- ARP(Address Resolution Protocol)表：IP 和 MAC 的对应关系；用于三层转发.
- FDB(Forwarding Data Base) 表：MAC+VLAN 和 PORT 的对应关系；用于二层转发, 就算两个设备不在一个网段或者压根没配 IP，只要两者之间的链路层是连通的，就可以通过 FDB 表进行数据的转发.

路由: **10.244.1.0/24 -> 62:2d:70:9c:01:ac -> 192.168.205.146**

flannel 最终提供服务的最小单元是 pods, 但可以访问服务的方式有多种:

1. 访问*pod*的 ip:port, 分属不同*nodes*的*pods*都属于网段**pods_cidir**, 这是一个虚拟网段, 即使 nodes 相距甚远, *pods*的 ip 也将是一个网段, 并能相互访问. *pods*的 IP 管理由*flannel*实现.
1. 访问*service*的 ip:port, *service*的虚拟 IP 机制由*kube-proxy*实现, 属于网段**cluster_cidr**, 服务建立时默认仅允许集群内部访问, 暴露给外部时创建端口映射, 但直接访问**service_ip**时, 端口与 pod_IP 的端口一致.
1. 访问*node*的 ip:port, 实验时设置了一台 master 加两台 nodes, 三台虚拟机属于网段**nodes_cidir**, 通过**node_ip**获取服务时, **node_port**是*service*映射出的随机端口.
1. 访问*node*的 **cni0** 网卡的 ip:port, 通过**cni_cidir**网段获取服务时, port 是*cluster*映射出的随机端口. cni 网卡的 ip 由 flannel 分配, 但是由于 flannel 的网卡是虚拟网卡, 所以无法直接访问, 需要通过**node_ip**访问.

从以上我们可以理解**service**的定义: _将运行在一组 Pods 上的应用程序公开为网络服务的抽象方法._
**service**的 pods 方向端口来自**pods**内部的容器端口, 服务的端口来自**nodes**的端口映射.
service_ip 有两个 ip, cluster-ip 和 external-ip, 在本示例中专指 cluster-ip, 没有用到 external-ip.

- flannel 管控下 cni0 网卡的使 node 在同一网段, cni_ip 映射到 node_ip, 根据 cni_ip 可查到 node_ip
- node_ip 暴露的端口 node_port 映射到 service_ip:port, 根据 node_port 可查到 service_ip:port
- service_ip:port 映射到 pod_ip:port, 根据 service_ip:port 可查到 pod_ip:port
- pod_ip:port 映射到 container ip:port

入站时:

```bash
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
-A DOCKER -i docker0 -j RETURN
-A KUBE-EXT-FXJ34XFJ55FJZHFP -m comment --comment "masquerade traffic for default/jtest external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-FXJ34XFJ55FJZHFP -j KUBE-SVC-FXJ34XFJ55FJZHFP
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-NODEPORTS -p tcp -m comment --comment "default/jtest" -m tcp --dport 31455 -j KUBE-EXT-FXJ34XFJ55FJZHFP
# 以下都是pods的ip
-A KUBE-SEP-D4L6XHEA34PXVJE3 -s 10.244.2.18/32 -m comment --comment "default/jtest" -j KUBE-MARK-MASQ
-A KUBE-SEP-D4L6XHEA34PXVJE3 -p tcp -m comment --comment "default/jtest" -m tcp -j DNAT --to-destination 10.244.2.18:8080
-A KUBE-SEP-KN35ORIINUKINMGQ -s 10.244.1.21/32 -m comment --comment "default/jtest" -j KUBE-MARK-MASQ
-A KUBE-SEP-KN35ORIINUKINMGQ -p tcp -m comment --comment "default/jtest" -m tcp -j DNAT --to-destination 10.244.1.21:8080
# 10.97.121.82是cluster_ip
-A KUBE-SERVICES -d 10.97.121.82/32 -p tcp -m comment --comment "default/jtest cluster IP" -m tcp --dport 8080 -j KUBE-SVC-FXJ34XFJ55FJZHFP
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
# 服务选择pods的ip
-A KUBE-SVC-FXJ34XFJ55FJZHFP ! -s 10.244.0.0/16 -d 10.97.121.82/32 -p tcp -m comment --comment "default/jtest cluster IP" -m tcp --dport 8080 -j KUBE-MARK-MASQ
-A KUBE-SVC-FXJ34XFJ55FJZHFP -m comment --comment "default/jtest -> 10.244.1.21:8080" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-KN35ORIINUKINMGQ
-A KUBE-SVC-FXJ34XFJ55FJZHFP -m comment --comment "default/jtest -> 10.244.2.18:8080" -j KUBE-SEP-D4L6XHEA34PXVJE3
```

说明:

- KUBE-NODEPORTS 是**node**的规则
- KUBE-EXT-XXXXX 打上 0x4000 标记**NAT**后到对应的**service**规则
- KUBE-SVC-XXXXX 是**service**的规则
- KUBE-SEP-XXXXX 是**pod**的规则

1. pods 访问外部地址时, 打上 `0x4000` 标记**NAT**
1. 源 IP 是**pods_cidir**网段的流量打上 `0x4000` 标记**NAT**
1. **pods_cidir**网段以外的 ip 访问**svc_cidir**, 打上 `0x4000` 标记**NAT**
1. 最终**NAT**到 pod 的 ip:port

出站时:

```bash
-A POSTROUTING -m comment --comment "flanneld masq" -j FLANNEL-POSTRTG
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
-A FLANNEL-POSTRTG -m mark --mark 0x4000/0x4000 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.244.0.0/16 ! -d 224.0.0.0/4 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.0.0/24 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully
-A KUBE-POSTROUTING -m mark ! --mark 0x4000/0x4000 -j RETURN
-A KUBE-POSTROUTING -j MARK --set-xmark 0x4000/0x0
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -j MASQUERADE --random-fully
```

- flannel
  - 不对标记后的包进行 snat, 避免多次 nat
  - 确保不会在虚拟网络中进行 nat
  - 如果不是多播包, 则进行 nat
  - 避免一个处在 pod 网段的 node 访问时被 snat
  - 将从 host 发往 flannel 的包进行 snat
- kube
  1. 未标记的包不进行 snat
  2. 已标记的包, 移除标记, 并进行 snat

**总结**

- node 上每增加一个 pod 都会增加一个 veth pair, 例如上面的 node2 上有 3 个 pod, 所以会有个 3 个 veth pair.
- 每个 node 上面都有到其它 nodes 的路由，这个路由是 onlink 路由，onlink 参数表明强制此网关是“在链路上”的(虽然并没有链路层路由)，否则 linux 上面是没法添加不同网段的路由.这样数据包就能知道，如果是容器直接的访问则交给 flannel.1 设备处理. flannel.1 这个虚拟网络设备将会对数据封包.
- 路由分别对应 node1/node2 的 flannel 网卡 mac, 以及对应的 ens 网卡, 这样对应 mac 地址转发目标 IP 便可以获取到了.
- flannel 里面任何主机的添加和删除都可以被其它节点所感知到，从而更新本地内核转发表.
- 通过表查找, 不同 nodes 上的信息可以交互, flannel 负责更新 route, FDB(二层 MAC 地址表), ARP(三层转发地址解析) 这三张表, 以保证容器间的通信.

flannel 的数据方向: **container->veth0->cni0->flannel.1->node1->node2->flannel.1->cni0->veth0->container**

![picture 1](http://jn-image-bed-cdn.jqknono.com/flannel%E5%88%86%E6%9E%90_9bafa96687309680c858d8012b936ecb75bef2ba36cf08131ba76eaab619f568.png)

![picture 2](http://jn-image-bed-cdn.jqknono.com/flannel%E5%88%86%E6%9E%90_5de6349df7410b86d1d33187d2f47a9298ba77a1f6beb50e3a806dc40e553056.png)

### 源码分析

[flannel:v0.20.2](https://github.com/flannel-io/flannel/tree/v0.20.2)

主要实现添加 iptables 规则, 以及 SNAT 和 DNAT 的文件是 **iptables.go**

规则被添加到 **nat** 表的 **FLANNEL-POSTRTG** 链

添加的规则如下:

**nat**

```go
func MasqRules(ipn ip.IP4Net, lease *subnet.Lease) []IPTablesRule {
    n := ipn.String()
    sn := lease.Subnet.String()
    supports_random_fully := false
    ipt, err := iptables.New()
    if err == nil {
        supports_random_fully = ipt.HasRandomFully()
    }

    return []IPTablesRule{
        // This rule ensure that the flannel iptables rules are executed before other rules on the node
        {"nat", "-I", "POSTROUTING", []string{"-m", "comment", "--comment", "flanneld masq", "-j", "FLANNEL-POSTRTG"}},
        // This rule will not masquerade traffic marked by the kube-proxy to avoid double NAT bug on some kernel version
        {"nat", "-A", "FLANNEL-POSTRTG", []string{"-m", "mark", "--mark", kubeProxyMark, "-m", "comment", "--comment", "flanneld masq", "-j", "RETURN"}},
        // This rule makes sure we don't NAT traffic within overlay network (e.g. coming out of docker0)
        {"nat", "-A", "FLANNEL-POSTRTG", []string{"-s", n, "-d", n, "-m", "comment", "--comment", "flanneld masq", "-j", "RETURN"}},
        // NAT if it's not multicast traffic
        {"nat", "-A", "FLANNEL-POSTRTG", []string{"-s", n, "!", "-d", "224.0.0.0/4", "-m", "comment", "--comment", "flanneld masq", "-j", "MASQUERADE", "--random-fully"}},
        // Prevent performing Masquerade on external traffic which arrives from a Node that owns the container/pod IP address
        {"nat", "-A", "FLANNEL-POSTRTG", []string{"!", "-s", n, "-d", sn, "-m", "comment", "--comment", "flanneld masq", "-j", "RETURN"}},
        // Masquerade anything headed towards flannel from the host
        {"nat", "-A", "FLANNEL-POSTRTG", []string{"!", "-s", n, "-d", n, "-m", "comment", "--comment", "flanneld masq", "-j", "MASQUERADE", "--random-fully"}},
      }
    }
}
```

```bash
# 确保 flannel iptables rules 优先执行
-A POSTROUTING -m comment --comment "flanneld masq" -j FLANNEL-POSTRTG

# 不对标记后的包进行masquerade, 避免多次nat
-A FLANNEL-POSTRTG -m mark --mark 0x4000/0x4000 -m comment --comment "flanneld masq" -j RETURN

# 确保不会在虚拟网络中进行nat
-A FLANNEL-POSTRTG -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j RETURN

# 如果不是多播包, 则进行nat
-A FLANNEL-POSTRTG -s 10.244.0.0/16 ! -d 224.0.0.0/4 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully

# 避免一个处在pod网段的node访问时被snat
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.0.0/24 -m comment --comment "flanneld masq" -j RETURN

# 将从host发往flannel的包进行snat
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully
```

**filter**

```go
func ForwardRules(flannelNetwork string) []IPTablesRule {
  return []IPTablesRule{
    // This rule ensure that the flannel iptables rules are executed before other rules on the node
    {"filter", "-I", "FORWARD", []string{"-m", "comment", "--comment", "flanneld forward", "-j", "FLANNEL-FWD"}},
    // These rules allow traffic to be forwarded if it is to or from the flannel network range.
    {"filter", "-A", "FLANNEL-FWD", []string{"-s", flannelNetwork, "-m", "comment", "--comment", "flanneld forward", "-j", "ACCEPT"}},
    {"filter", "-A", "FLANNEL-FWD", []string{"-d", flannelNetwork, "-m", "comment", "--comment", "flanneld forward", "-j", "ACCEPT"}},
  }
}
```

```bash
# 确保 flannel iptables rules 优先执行
-A FORWARD -m comment --comment "flanneld forward" -j FLANNEL-FWD
# 允许flannel网段的包进行转发
-A FLANNEL-FWD -s 10.244.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A FLANNEL-FWD -d 10.244.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
```

**移除 node 或 pods**

```go
if event.Lease.EnableIPv4 {
	if directRoutingOK {
		log.V(2).Infof("Removing direct route to subnet: %s PublicIP: %s", sn, attrs.PublicIP)
		if err := netlink.RouteDel(&directRoute); err != nil {
			log.Errorf("Error deleting route to %v via %v: %v", sn, attrs.PublicIP, err)
		}
	} else {
		log.V(2).Infof("removing subnet: %s PublicIP: %s VtepMAC: %s", sn, attrs.PublicIP, net.HardwareAddr(vxlanAttrs.VtepMAC))
		// Try to remove all entries - don't bail out if one of them fails.
    // 删除 vxlan 的路由
    // 删除 arp 缓存
		if err := nw.dev.DelARP(neighbor{IP: sn.IP, MAC: net.HardwareAddr(vxlanAttrs.VtepMAC)}); err != nil {
			log.Error("DelARP failed: ", err)
		}
    // 删除 fdb 缓存
		if err := nw.dev.DelFDB(neighbor{IP: attrs.PublicIP, MAC: net.HardwareAddr(vxlanAttrs.VtepMAC)}); err != nil {
			log.Error("DelFDB failed: ", err)
		}
    // 删除路由
		if err := netlink.RouteDel(&vxlanRoute); err != nil {
			log.Errorf("failed to delete vxlanRoute (%s -> %s): %v", vxlanRoute.Dst, vxlanRoute.Gw, err)
		}
	}
}
```

删除一个子网过程:

1. 删除 arp 缓存
2. 删除 fdb 缓存
3. 删除路由

## host-gw

Host-gw 的基本原理比较简单，是直接在 host 主机上配置 Overlay 的 subnet 对端 host 的路由信息，数据包没有经过任何封装而直接送往对端，这就要求 Host 在同一个二层网络中，因为没有 vetp 做封装，也意味着 Underlay 的安全策略需要和 Overlay 一致.这种模式也不需要任何额外的虚拟网络设备，数据包直接通过 eth0 进出，因为简单也是效率最高的.

- 使用 host-gw 通过远程计算机 IP 创建到子网的 IP 路由.
- 需要运行 Flannel 的主机之间直接通过二层连接.
- host-gw 提供了良好的性能，并且易于设置, 但依赖二层网络.

## udp

当内核版本比较低，不支持 Vxlan 和 host-gw 模式的时候，可以使用 UDP 模式.
首先 Pod 通过用户进程发送 ping 请求，到网络协议栈然后检测到从 veth0 中出去到主机网络名称空间中，然后进入内核网络协议栈；
通过规程我们判断出它需要到 Flanneld 进程中处理一下，所以内核协议栈开放了 tun0 发送到用户态的 Flanneld 中进行封处理，然后再丢给内核网络协议栈中从 eth0 转出去.接收时反之.

UDP 模式和 vxlan 类似是一种隧道实现，即为 host 创建一个 tun 的设备，tun 设备是一个虚拟网路设备，通常一端连接着 kernel 网络协议栈，而另一端就取决于网络设备驱动的实现，一般连接着应用进程，网络数据包发送到这个 tun 设备上后从管道的出口到达应用程序，这个时候应用程序可以根据需求对数据包进行拆包和解包再回传给 eth0 或其他网络设备，从而到达隧道的另一端.flannel 的 udp 模式 tun 设备连接的另一端是 flanneld 进程.

![picture 3](http://jn-image-bed-cdn.jqknono.com/flannel%E5%88%86%E6%9E%90_49de1a844a9769d1a9892fc246f723f4ced57f6d0b1ae990198d74a60ada4722.png)

## wireguard

在内核中使用 WireGuard 来封装和加密数据包.

## ipip

IPIP 类型的隧道是最简单的一种.它的开销最低，但只能封装 IPv4 单播流量，因此您将无法设置 OSPF、RIP 或任何其他基于多播的协议.

## 总结

- 使用 vxlan 时:
  - Flannel 运行时会创建新的网络接口: `flannel.1`.
  - 添加 netlink, 确保数据链路畅通, 修改 FDB 表和 ARP 表
  - 在防火墙创建 2 条链:
    - nat: FLANNEL-POSTRTG
    - filter: FLANNEL-FWD
- 使用 hostgw 时:
  - 添加 netlink 路由
- udp
  - 获取子网 ip
  - 打开 tun0 文件, "/dev/net/tun"
  - 添加 netlink
  - 监听 udp 端口 8285
  - 创建 socket
- 使用 wireguard 时:
  - 创建新的网络接口: `flannel-wg`, `flannel-wg-v6`
  - 获取子网 ip, 配置 config

注意事项:

- 使用`udp`后端时, 需要确保**udp**端口**8285**是开放的.
- 使用`vxlan`后端时, 需要确保**udp**端口**8472**是开放的.
- 使用`wireguard`后端时, 需要确保**udp**端口**51820**是开放的, ipv6 端口**51821**也需要开放.
- 确保您的防火墙规则允许所有参与覆盖网络的主机使用此流量
- 确保允许 pod 访问 master

其它端口:

**Control plane**

| Protocol | Direction | Port Range | Purpose                 | Used By              |
| -------- | --------- | ---------- | ----------------------- | -------------------- |
| TCP      | Inbound   | 6443       | Kubernetes API server   | All                  |
| TCP      | Inbound   | 2379,2380  | etcd server client API  | kube-apiserver, etcd |
| TCP      | Inbound   | 10250      | Kubelet API             | Self, Control plane  |
| TCP      | Inbound   | 10259      | kube-scheduler          | Self                 |
| TCP      | Inbound   | 10257      | kube-controller-manager | Self                 |

**Worker node(s)**

| Protocol | Direction | Port Range  | Purpose           | Used By             |
| -------- | --------- | ----------- | ----------------- | ------------------- |
| TCP      | Inbound   | 10250       | Kubelet API       | Self, Control plane |
| TCP      | Inbound   | 30000-32767 | NodePort Services | All                 |

其中除了 NodePort Services, 其它端口都是必须开放的.

现有如下配置的集群:

- master ip: 192.168.205.145
- node1 ip: 192.168.205.146
- node2 ip: 192.168.205.147
- flannel network: 10.244.0.0/16
  - pod cidr: 10.244.X.0/24

假设微隔离使用的白名单形式, 所有未指定规则的流量都会被拦截, 需要添加以下规则:

| 访问场景         | 目的 IP   | 需要防火墙规则                          | 说明                                                    |
| ---------------- | --------- | --------------------------------------- | ------------------------------------------------------- |
| pod 访问 pod     | pod ip    | 8472                                    | na                                                      |
| pod 访问 node    | node ip   | 8472                                    | na                                                      |
| pod 访问 master  | master ip | 8472                                    | na                                                      |
| node 访问 pod    | pod ip    | 8472                                    | na                                                      |
| node 访问 node   | node ip   | 如非服务端口, 则需要允许 master/node ip | 由于新建服务的暴露端口是不固定的, 建议规则使用 node ip. |
| master 访问 pod  | pod ip    | 8472                                    | na                                                      |
| master 访问 node | node ip   | 如非服务端口, 则需要 master/node ip     | na                                                      |

- k8s 的标准服务执行需要开放端口和 flannel 的 cidr.
- 需要开放 svc 的 cidr
- 节点间互访
  - 节点间如果需要互访服务, 需要开放节点的 **ip 或者端口**. 默认端口是**30000-32767**.
  - 如果开放了节点的 ip, 那么节点间的服务就不需要开放端口了, 但安全性会降低, 且存在集群未全部接入微隔离的情况.

效果:

![picture 4](http://jn-image-bed-cdn.jqknono.com/flannel%E5%88%86%E6%9E%90_dc91d3b8f66a983b81990491b46cd531bed85322a94b6467cb7102eab3345f36.png)

## 参考

- [深入理解 flannel](https://www.cnblogs.com/YaoDD/p/7681811.html)
- [Kubernetes 网络分析之 Flannel](https://developer.aliyun.com/article/713036)
- [Flannel CNI 初探](https://www.tnblog.net/hb/article/details/7888)
- [Ports and Protocols](https://kubernetes.io/docs/reference/networking/ports-and-protocols/)
