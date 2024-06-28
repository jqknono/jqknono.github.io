---
layout: blog
categories: 教程
tags: [教程, k8s]
published: false
draft: true
title: k8s网络插件flannel
linkTitle: k8s网络插件flannel
date: 2024-06-28 16:05:28 +0800
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

- [ ] k8s网络插件flannel

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [网络模型](#网络模型)
- [网络插件](#网络插件)
  - [flannel](#flannel)
    - [ip address(k8s-master)](#ip-addressk8s-master)
    - [ip address(k8s-worker1)](#ip-addressk8s-worker1)
    - [ip address(k8s-worker2)](#ip-addressk8s-worker2)
    - [iptables -nvL(k8s-master)](#iptables--nvlk8s-master)
    - [iptables -nvL(k8s-worker1)](#iptables--nvlk8s-worker1)
    - [iptables-save(k8s-master)](#iptables-savek8s-master)
    - [iptables-save(k8s-worker1)](#iptables-savek8s-worker1)

<!-- /code_chunk_output -->

## 网络模型

- all nodes must be able to reach each other, without NAT
- all pods must be able to reach each other, without NAT
- pods and nodes must be able to reach each other, without NAT
- each pod is aware of its IP address (no NAT)
- 但 k8s 未强制要求任何特定的实现

**优势**

- Everything can reach everything
- No address translation
- No port translation
- No new protocol
- Pods cannot move from a node to another and keep their IP address
- IP addresses don't have to be "portable" from a node to another (We can use e.g. a subnet per node and use a simple routed topology)
- The specification is simple enough to allow many various implementations

**劣势**

- Everything can reach everything
  - if you want security, you need to add network policies
  - the network implementation that you use needs to support them
- There are literally dozens of implementations out there (15 are listed in the Kubernetes documentation)
- It looks like you have a level 3 network, but it's only level 4 (The spec requires UDP and TCP, but not port ranges or arbitrary IP packets)
- `kube-proxy` is on the data path when connecting to a pod or container, and it's not particularly fast (relies on userland proxying or iptables)

## 网络插件

k8s 有许多网络插件，但是它们都有一个共同的特点，就是它们都是基于 CNI（Container Network Interface）的，CNI 是一个标准的网络接口，它定义了一些标准的接口，比如创建网络、删除网络、添加容器到网络、从网络中删除容器等等，这些接口都是通过 JSON 格式的配置文件来实现的，这样就使得不同的网络插件可以通过实现这些接口来实现对 k8s 的支持。

flannel 是一个比较简单的网络插件，它的实现原理是在每个节点上启动一个代理，这个代理会监听一个 UDP 端口，然后在每个节点上创建一个虚拟网卡，这个虚拟网卡会和 flannel 代理进行通信，flannel 代理会根据节点的 IP 地址来计算出一个子网，然后将这个子网分配给每个节点，每个节点都会在这个子网中分配一个 IP 地址，然后将这个 IP 地址和节点的 IP 地址进行绑定，这样就实现了节点之间的通信。

    如果集群的主机都在一个子网内，就搞一条路由转发过去；若是不在一个子网内，就搞一条隧道转发过去。

### flannel

![picture 1](https://s2.loli.net/2023/05/06/xOaTZqyr6kEfLpU.png)

参考:

- [扁平网络 Flannel](https://jimmysong.io/kubernetes-handbook/concepts/flannel.html)
- [强大的 iptables 在 K8s 中的应用剖析](https://jishuin.proginn.com/p/763bfbd2bf02)
- [Kubernetes 网络分析之 Flannel](https://developer.aliyun.com/article/713036)

#### ip address(k8s-master)

**k8s-master**:  
flannel.1: 10.244.0.0/32
cni0: 10.244.0.1/24

```shell
root@k8s-master:~# k get pods -A
NAMESPACE      NAME                                 READY   STATUS    RESTARTS        AGE
kube-flannel   kube-flannel-ds-jpl6q                1/1     Running   0               22h
kube-flannel   kube-flannel-ds-r62cs                1/1     Running   1 (5h59m ago)   20h
kube-flannel   kube-flannel-ds-wb4mz                1/1     Running   0               4h
kube-system    coredns-787d4945fb-g2lzn             1/1     Running   0               23h
kube-system    coredns-787d4945fb-lbjsd             1/1     Running   0               23h
kube-system    etcd-k8s-master                      1/1     Running   0               23h
kube-system    kube-apiserver-k8s-master            1/1     Running   0               23h
kube-system    kube-controller-manager-k8s-master   1/1     Running   0               23h
kube-system    kube-proxy-49gwt                     1/1     Running   1 (5h59m ago)   20h
kube-system    kube-proxy-cq898                     1/1     Running   0               4h
kube-system    kube-proxy-n5cj6                     1/1     Running   0               23h
kube-system    kube-scheduler-k8s-master            1/1     Running   0               23h
root@k8s-master:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:1a:33:7e brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 192.168.205.145/24 brd 192.168.205.255 scope global dynamic noprefixroute ens33
       valid_lft 1218sec preferred_lft 1218sec
    inet6 fe80::8030:98fa:2f04:cdea/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:aa:d9:0b:32 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:aaff:fed9:b32/64 scope link
       valid_lft forever preferred_lft forever
4: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN group default
    link/ether 3e:85:1f:fc:43:52 brd ff:ff:ff:ff:ff:ff
    inet 10.244.0.0/32 scope global flannel.1
       valid_lft forever preferred_lft forever
    inet6 fe80::3c85:1fff:fefc:4352/64 scope link
       valid_lft forever preferred_lft forever
16: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    link/ether ce:e6:37:84:60:4f brd ff:ff:ff:ff:ff:ff
    inet 10.244.0.1/24 brd 10.244.0.255 scope global cni0
       valid_lft forever preferred_lft forever
    inet6 fe80::cce6:37ff:fe84:604f/64 scope link
       valid_lft forever preferred_lft forever
17: vethb06665fe@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default
    link/ether c2:a1:8e:d5:89:0e brd ff:ff:ff:ff:ff:ff link-netns cni-48d1b9a9-eb8e-4b47-eed9-35e0144da2d9
    inet6 fe80::c0a1:8eff:fed5:890e/64 scope link
       valid_lft forever preferred_lft forever
18: veth7745811b@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default
    link/ether 4e:00:3f:95:c5:f5 brd ff:ff:ff:ff:ff:ff link-netns cni-10323ab9-47b5-4161-1127-566463d2010c
    inet6 fe80::4c00:3fff:fe95:c5f5/64 scope link
       valid_lft forever preferred_lft forever
```

#### ip address(k8s-worker1)

**k8s-worker1**:  
flannel.1: 10.244.1.0/32

```shell
root@k8s-worker1:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:69:a4:e2 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 192.168.205.146/24 brd 192.168.205.255 scope global dynamic noprefixroute ens33
       valid_lft 1222sec preferred_lft 1222sec
    inet6 fe80::589d:df22:6455:b62a/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN group default
    link/ether fe:ef:1a:85:28:8d brd ff:ff:ff:ff:ff:ff
    inet 10.244.1.0/32 scope global flannel.1
       valid_lft forever preferred_lft forever
    inet6 fe80::fcef:1aff:fe85:288d/64 scope link
       valid_lft forever preferred_lft forever
```

#### ip address(k8s-worker2)

**k8s-worker2**:  
flannel.1: 10.244.2.0/32

```shell
root@k8s-worker2:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:7c:79:c4 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 192.168.205.147/24 brd 192.168.205.255 scope global dynamic noprefixroute ens33
       valid_lft 1735sec preferred_lft 1735sec
    inet6 fe80::45b9:96cf:c5a2:6528/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN group default
    link/ether 8a:f0:39:92:a3:9b brd ff:ff:ff:ff:ff:ff
    inet 10.244.2.0/32 scope global flannel.1
       valid_lft forever preferred_lft forever
    inet6 fe80::88f0:39ff:fe92:a39b/64 scope link
       valid_lft forever preferred_lft forever
```

#### iptables -nvL(k8s-master)

**k8s-master**:

- 添加 pods 后规则不变

```shell
root@k8s-master:~/.kube# iptables -nvL
Chain INPUT (policy ACCEPT 75993 packets, 11M bytes)
 pkts bytes target     prot opt in     out     source               destination
 203K   12M KUBE-PROXY-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes load balancer firewall */
  25M 3834M KUBE-NODEPORTS  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes health check service ports */
 203K   12M KUBE-EXTERNAL-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes externally-visible service portals */
  25M 3949M KUBE-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
    4  1726 DOCKER-USER  all  --  *      *       0.0.0.0/0            0.0.0.0/0
    4  1726 DOCKER-ISOLATION-STAGE-1  all  --  *      *       0.0.0.0/0            0.0.0.0/0
    0     0 ACCEPT     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
    0     0 DOCKER     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0
    0     0 ACCEPT     all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0
    0     0 ACCEPT     all  --  docker0 docker0  0.0.0.0/0            0.0.0.0/0
    4  1726 FLANNEL-FWD  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* flanneld forward */
32395 1462K KUBE-PROXY-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes load balancer firewall */
32395 1462K KUBE-FORWARD  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes forwarding rules */
32395 1462K KUBE-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes service portals */
32395 1462K KUBE-EXTERNAL-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes externally-visible service portals */

Chain OUTPUT (policy ACCEPT 75849 packets, 12M bytes)
 pkts bytes target     prot opt in     out     source               destination
 249K   15M KUBE-PROXY-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes load balancer firewall */
 249K   15M KUBE-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes service portals */
  25M 3818M KUBE-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain DOCKER (1 references)
 pkts bytes target     prot opt in     out     source               destination

Chain DOCKER-ISOLATION-STAGE-1 (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DOCKER-ISOLATION-STAGE-2  all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0
    4  1726 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain DOCKER-ISOLATION-STAGE-2 (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       all  --  *      docker0  0.0.0.0/0            0.0.0.0/0
    0     0 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain DOCKER-USER (1 references)
 pkts bytes target     prot opt in     out     source               destination
32399 1464K RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain FLANNEL-FWD (1 references)
 pkts bytes target     prot opt in     out     source               destination
    2   191 ACCEPT     all  --  *      *       10.244.0.0/16        0.0.0.0/0            /* flanneld forward */
    2  1535 ACCEPT     all  --  *      *       0.0.0.0/0            10.244.0.0/16        /* flanneld forward */

Chain KUBE-EXTERNAL-SERVICES (2 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-FIREWALL (2 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       all  --  *      *      !127.0.0.0/8          127.0.0.0/8          /* block incoming localnet connections */ ! ctstate RELATED,ESTABLISHED,DNAT
    0     0 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes firewall for dropping marked packets */ mark match 0x8000/0x8000

Chain KUBE-FORWARD (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate INVALID
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes forwarding rules */ mark match 0x4000/0x4000
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes forwarding conntrack rule */ ctstate RELATED,ESTABLISHED

Chain KUBE-KUBELET-CANARY (0 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-NODEPORTS (1 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-PROXY-CANARY (0 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-PROXY-FIREWALL (3 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-SERVICES (2 references)
 pkts bytes target     prot opt in     out     source               destination
```

#### iptables -nvL(k8s-worker1)

**k8s-worker1**:

- **k8s-worker2**: 同 k8s-worker1

```shell
root@k8s-master:~# iptables -nvL
Chain INPUT (policy ACCEPT 3673 packets, 836K bytes)
 pkts bytes target     prot opt in     out     source               destination
 2232  196K KUBE-PROXY-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes load balancer firewall */
 133K   78M KUBE-NODEPORTS  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes health check service ports */
 2232  196K KUBE-EXTERNAL-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes externally-visible service portals */
 133K   78M KUBE-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 FLANNEL-FWD  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* flanneld forward */
    0     0 KUBE-PROXY-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes load balancer firewall */
    0     0 KUBE-FORWARD  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes forwarding rules */
    0     0 KUBE-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes service portals */
    0     0 KUBE-EXTERNAL-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes externally-visible service portals */

Chain OUTPUT (policy ACCEPT 3779 packets, 286K bytes)
 pkts bytes target     prot opt in     out     source               destination
 2173  168K KUBE-PROXY-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes load balancer firewall */
 2173  168K KUBE-SERVICES  all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate NEW /* kubernetes service portals */
 133K   14M KUBE-FIREWALL  all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain FLANNEL-FWD (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     all  --  *      *       10.244.0.0/16        0.0.0.0/0            /* flanneld forward */
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            10.244.0.0/16        /* flanneld forward */

Chain KUBE-EXTERNAL-SERVICES (2 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-FIREWALL (2 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       all  --  *      *      !127.0.0.0/8          127.0.0.0/8          /* block incoming localnet connections */ ! ctstate RELATED,ESTABLISHED,DNAT
    0     0 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes firewall for dropping marked packets */ mark match 0x8000/0x8000

Chain KUBE-FORWARD (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate INVALID
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes forwarding rules */ mark match 0x4000/0x4000
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes forwarding conntrack rule */ ctstate RELATED,ESTABLISHED

Chain KUBE-KUBELET-CANARY (0 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-NODEPORTS (1 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-PROXY-CANARY (0 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-PROXY-FIREWALL (3 references)
 pkts bytes target     prot opt in     out     source               destination

Chain KUBE-SERVICES (2 references)
 pkts bytes target     prot opt in     out     source               destination
```

#### iptables-save(k8s-master)

```shell
root@k8s-master:~# iptables-save
# Generated by iptables-save v1.8.4 on Thu Feb  2 00:57:54 2023
*nat
:PREROUTING ACCEPT [3:330]
:INPUT ACCEPT [3:330]
:OUTPUT ACCEPT [104:6405]
:POSTROUTING ACCEPT [104:6405]
:DOCKER - [0:0]
:FLANNEL-POSTRTG - [0:0]
:KUBE-EXT-CEZPIJSAUFW5MYPQ - [0:0]
:KUBE-EXT-FXJ34XFJ55FJZHFP - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-MARK-DROP - [0:0]
:KUBE-MARK-MASQ - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-POSTROUTING - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-SEP-CEWR77HQLZDHWWAJ - [0:0]
:KUBE-SEP-FWCNVWTS6ZPOZ3BF - [0:0]
:KUBE-SEP-LBMQNJ35ID4UIQ2A - [0:0]
:KUBE-SEP-M5AH7HXBJNRQUZER - [0:0]
:KUBE-SEP-M6GS57VBAWSHNQMT - [0:0]
:KUBE-SEP-RLYUOFPY4DP6R7JM - [0:0]
:KUBE-SEP-S7MPVVC7MGYVFSF3 - [0:0]
:KUBE-SEP-SISP6ORRA37L3ZYK - [0:0]
:KUBE-SEP-UUBFDOGZKSZ6QOBE - [0:0]
:KUBE-SEP-XNZERJBNXRGRQGMS - [0:0]
:KUBE-SEP-XRFUWCXKVCLGWYQC - [0:0]
:KUBE-SERVICES - [0:0]
:KUBE-SVC-CEZPIJSAUFW5MYPQ - [0:0]
:KUBE-SVC-ERIFXISQEP7F7OF4 - [0:0]
:KUBE-SVC-FXJ34XFJ55FJZHFP - [0:0]
:KUBE-SVC-JD5MR3NA4I4DYORP - [0:0]
:KUBE-SVC-NPX46M4PTMTKRN6Y - [0:0]
:KUBE-SVC-TCOU7JCQXEZGVUNU - [0:0]
:KUBE-SVC-Z6GDYMWE5TV2NNJN - [0:0]
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -m comment --comment "flanneld masq" -j FLANNEL-POSTRTG
-A FLANNEL-POSTRTG -m mark --mark 0x4000/0x4000 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.244.0.0/16 ! -d 224.0.0.0/4 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.0.0/24 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully
-A KUBE-EXT-CEZPIJSAUFW5MYPQ -m comment --comment "masquerade traffic for kubernetes-dashboard/kubernetes-dashboard external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-CEZPIJSAUFW5MYPQ -j KUBE-SVC-CEZPIJSAUFW5MYPQ
-A KUBE-EXT-FXJ34XFJ55FJZHFP -m comment --comment "masquerade traffic for default/jtest external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-FXJ34XFJ55FJZHFP -j KUBE-SVC-FXJ34XFJ55FJZHFP
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-NODEPORTS -p tcp -m comment --comment "default/jtest" -m tcp --dport 31455 -j KUBE-EXT-FXJ34XFJ55FJZHFP
-A KUBE-NODEPORTS -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard" -m tcp --dport 31734 -j KUBE-EXT-CEZPIJSAUFW5MYPQ
-A KUBE-POSTROUTING -m mark ! --mark 0x4000/0x4000 -j RETURN
-A KUBE-POSTROUTING -j MARK --set-xmark 0x4000/0x0
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -j MASQUERADE --random-fully
-A KUBE-SEP-CEWR77HQLZDHWWAJ -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-CEWR77HQLZDHWWAJ -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.9:9153
-A KUBE-SEP-FWCNVWTS6ZPOZ3BF -s 10.244.2.17/32 -m comment --comment "default/jtest" -j KUBE-MARK-MASQ
-A KUBE-SEP-FWCNVWTS6ZPOZ3BF -p tcp -m comment --comment "default/jtest" -m tcp -j DNAT --to-destination 10.244.2.17:8080
-A KUBE-SEP-LBMQNJ35ID4UIQ2A -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-LBMQNJ35ID4UIQ2A -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.9:53
-A KUBE-SEP-M5AH7HXBJNRQUZER -s 10.244.2.12/32 -m comment --comment "kubernetes-dashboard/kubernetes-dashboard" -j KUBE-MARK-MASQ
-A KUBE-SEP-M5AH7HXBJNRQUZER -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard" -m tcp -j DNAT --to-destination 10.244.2.12:8443
-A KUBE-SEP-M6GS57VBAWSHNQMT -s 10.244.1.19/32 -m comment --comment "default/jtest" -j KUBE-MARK-MASQ
-A KUBE-SEP-M6GS57VBAWSHNQMT -p tcp -m comment --comment "default/jtest" -m tcp -j DNAT --to-destination 10.244.1.19:8080
-A KUBE-SEP-RLYUOFPY4DP6R7JM -s 10.244.1.15/32 -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper" -j KUBE-MARK-MASQ
-A KUBE-SEP-RLYUOFPY4DP6R7JM -p tcp -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper" -m tcp -j DNAT --to-destination 10.244.1.15:8000
-A KUBE-SEP-S7MPVVC7MGYVFSF3 -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-S7MPVVC7MGYVFSF3 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.9:53
-A KUBE-SEP-SISP6ORRA37L3ZYK -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-SISP6ORRA37L3ZYK -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.8:53
-A KUBE-SEP-UUBFDOGZKSZ6QOBE -s 192.168.205.145/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-UUBFDOGZKSZ6QOBE -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 192.168.205.145:6443
-A KUBE-SEP-XNZERJBNXRGRQGMS -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-XNZERJBNXRGRQGMS -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.8:9153
-A KUBE-SEP-XRFUWCXKVCLGWYQC -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-XRFUWCXKVCLGWYQC -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.8:53
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-SVC-ERIFXISQEP7F7OF4
-A KUBE-SERVICES -d 10.97.121.82/32 -p tcp -m comment --comment "default/jtest cluster IP" -m tcp --dport 8080 -j KUBE-SVC-FXJ34XFJ55FJZHFP
-A KUBE-SERVICES -d 10.96.223.136/32 -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard cluster IP" -m tcp --dport 443 -j KUBE-SVC-CEZPIJSAUFW5MYPQ
-A KUBE-SERVICES -d 10.96.1.86/32 -p tcp -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper cluster IP" -m tcp --dport 8000 -j KUBE-SVC-Z6GDYMWE5TV2NNJN
-A KUBE-SERVICES -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-NPX46M4PTMTKRN6Y
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-SVC-JD5MR3NA4I4DYORP
-A KUBE-SERVICES -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-SVC-TCOU7JCQXEZGVUNU
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
-A KUBE-SVC-CEZPIJSAUFW5MYPQ ! -s 10.244.0.0/16 -d 10.96.223.136/32 -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-CEZPIJSAUFW5MYPQ -m comment --comment "kubernetes-dashboard/kubernetes-dashboard -> 10.244.2.12:8443" -j KUBE-SEP-M5AH7HXBJNRQUZER
-A KUBE-SVC-ERIFXISQEP7F7OF4 ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.8:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-XRFUWCXKVCLGWYQC
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.9:53" -j KUBE-SEP-S7MPVVC7MGYVFSF3
-A KUBE-SVC-FXJ34XFJ55FJZHFP ! -s 10.244.0.0/16 -d 10.97.121.82/32 -p tcp -m comment --comment "default/jtest cluster IP" -m tcp --dport 8080 -j KUBE-MARK-MASQ
-A KUBE-SVC-FXJ34XFJ55FJZHFP -m comment --comment "default/jtest -> 10.244.1.19:8080" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-M6GS57VBAWSHNQMT
-A KUBE-SVC-FXJ34XFJ55FJZHFP -m comment --comment "default/jtest -> 10.244.2.17:8080" -j KUBE-SEP-FWCNVWTS6ZPOZ3BF
-A KUBE-SVC-JD5MR3NA4I4DYORP ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-MARK-MASQ
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.8:9153" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-XNZERJBNXRGRQGMS
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.9:9153" -j KUBE-SEP-CEWR77HQLZDHWWAJ
-A KUBE-SVC-NPX46M4PTMTKRN6Y ! -s 10.244.0.0/16 -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https -> 192.168.205.145:6443" -j KUBE-SEP-UUBFDOGZKSZ6QOBE
-A KUBE-SVC-TCOU7JCQXEZGVUNU ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.8:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-SISP6ORRA37L3ZYK
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.9:53" -j KUBE-SEP-LBMQNJ35ID4UIQ2A
-A KUBE-SVC-Z6GDYMWE5TV2NNJN ! -s 10.244.0.0/16 -d 10.96.1.86/32 -p tcp -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper cluster IP" -m tcp --dport 8000 -j KUBE-MARK-MASQ
-A KUBE-SVC-Z6GDYMWE5TV2NNJN -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper -> 10.244.1.15:8000" -j KUBE-SEP-RLYUOFPY4DP6R7JM
COMMIT
# Completed on Thu Feb  2 00:57:54 2023
# Generated by iptables-save v1.8.4 on Thu Feb  2 00:57:54 2023
*mangle
:PREROUTING ACCEPT [73528:11201784]
:INPUT ACCEPT [73528:11201784]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [73621:11913771]
:POSTROUTING ACCEPT [73621:11913771]
:KUBE-IPTABLES-HINT - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-PROXY-CANARY - [0:0]
COMMIT
# Completed on Thu Feb  2 00:57:54 2023
# Generated by iptables-save v1.8.4 on Thu Feb  2 00:57:54 2023
*filter
:INPUT ACCEPT [9311:1423528]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9349:1535197]
:FLANNEL-FWD - [0:0]
:KUBE-EXTERNAL-SERVICES - [0:0]
:KUBE-FORWARD - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-PROXY-FIREWALL - [0:0]
:KUBE-SERVICES - [0:0]
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -m comment --comment "flanneld forward" -j FLANNEL-FWD
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FLANNEL-FWD -s 10.244.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A FLANNEL-FWD -d 10.244.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
COMMIT
# Completed on Thu Feb  2 00:57:54 2023
```

#### iptables-save(k8s-worker1)

```bash
root@k8s-worker1:~# iptables-save
# Generated by iptables-save v1.8.4 on Thu Feb  2 00:58:07 2023
*nat
:PREROUTING ACCEPT [4:340]
:INPUT ACCEPT [2:220]
:OUTPUT ACCEPT [17:1524]
:POSTROUTING ACCEPT [18:1584]
:FLANNEL-POSTRTG - [0:0]
:KUBE-EXT-CEZPIJSAUFW5MYPQ - [0:0]
:KUBE-EXT-FXJ34XFJ55FJZHFP - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-MARK-DROP - [0:0]
:KUBE-MARK-MASQ - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-POSTROUTING - [0:0]
:KUBE-PROXY-CANARY - [0:0]
:KUBE-SEP-CEWR77HQLZDHWWAJ - [0:0]
:KUBE-SEP-FWCNVWTS6ZPOZ3BF - [0:0]
:KUBE-SEP-LBMQNJ35ID4UIQ2A - [0:0]
:KUBE-SEP-M5AH7HXBJNRQUZER - [0:0]
:KUBE-SEP-M6GS57VBAWSHNQMT - [0:0]
:KUBE-SEP-RLYUOFPY4DP6R7JM - [0:0]
:KUBE-SEP-S7MPVVC7MGYVFSF3 - [0:0]
:KUBE-SEP-SISP6ORRA37L3ZYK - [0:0]
:KUBE-SEP-UUBFDOGZKSZ6QOBE - [0:0]
:KUBE-SEP-XNZERJBNXRGRQGMS - [0:0]
:KUBE-SEP-XRFUWCXKVCLGWYQC - [0:0]
:KUBE-SERVICES - [0:0]
:KUBE-SVC-CEZPIJSAUFW5MYPQ - [0:0]
:KUBE-SVC-ERIFXISQEP7F7OF4 - [0:0]
:KUBE-SVC-FXJ34XFJ55FJZHFP - [0:0]
:KUBE-SVC-JD5MR3NA4I4DYORP - [0:0]
:KUBE-SVC-NPX46M4PTMTKRN6Y - [0:0]
:KUBE-SVC-TCOU7JCQXEZGVUNU - [0:0]
:KUBE-SVC-Z6GDYMWE5TV2NNJN - [0:0]
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -m comment --comment "flanneld masq" -j FLANNEL-POSTRTG
-A FLANNEL-POSTRTG -m mark --mark 0x4000/0x4000 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG -s 10.244.0.0/16 ! -d 224.0.0.0/4 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.1.0/24 -m comment --comment "flanneld masq" -j RETURN
-A FLANNEL-POSTRTG ! -s 10.244.0.0/16 -d 10.244.0.0/16 -m comment --comment "flanneld masq" -j MASQUERADE --random-fully
-A KUBE-EXT-CEZPIJSAUFW5MYPQ -m comment --comment "masquerade traffic for kubernetes-dashboard/kubernetes-dashboard external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-CEZPIJSAUFW5MYPQ -j KUBE-SVC-CEZPIJSAUFW5MYPQ
-A KUBE-EXT-FXJ34XFJ55FJZHFP -m comment --comment "masquerade traffic for default/jtest external destinations" -j KUBE-MARK-MASQ
-A KUBE-EXT-FXJ34XFJ55FJZHFP -j KUBE-SVC-FXJ34XFJ55FJZHFP
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-NODEPORTS -p tcp -m comment --comment "default/jtest" -m tcp --dport 31455 -j KUBE-EXT-FXJ34XFJ55FJZHFP
-A KUBE-NODEPORTS -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard" -m tcp --dport 31734 -j KUBE-EXT-CEZPIJSAUFW5MYPQ
-A KUBE-POSTROUTING -m mark ! --mark 0x4000/0x4000 -j RETURN
-A KUBE-POSTROUTING -j MARK --set-xmark 0x4000/0x0
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -j MASQUERADE --random-fully
-A KUBE-SEP-CEWR77HQLZDHWWAJ -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-CEWR77HQLZDHWWAJ -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.9:9153
-A KUBE-SEP-FWCNVWTS6ZPOZ3BF -s 10.244.2.17/32 -m comment --comment "default/jtest" -j KUBE-MARK-MASQ
-A KUBE-SEP-FWCNVWTS6ZPOZ3BF -p tcp -m comment --comment "default/jtest" -m tcp -j DNAT --to-destination 10.244.2.17:8080
-A KUBE-SEP-LBMQNJ35ID4UIQ2A -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-LBMQNJ35ID4UIQ2A -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.9:53
-A KUBE-SEP-M5AH7HXBJNRQUZER -s 10.244.2.12/32 -m comment --comment "kubernetes-dashboard/kubernetes-dashboard" -j KUBE-MARK-MASQ
-A KUBE-SEP-M5AH7HXBJNRQUZER -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard" -m tcp -j DNAT --to-destination 10.244.2.12:8443
-A KUBE-SEP-M6GS57VBAWSHNQMT -s 10.244.1.19/32 -m comment --comment "default/jtest" -j KUBE-MARK-MASQ
-A KUBE-SEP-M6GS57VBAWSHNQMT -p tcp -m comment --comment "default/jtest" -m tcp -j DNAT --to-destination 10.244.1.19:8080
-A KUBE-SEP-RLYUOFPY4DP6R7JM -s 10.244.1.15/32 -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper" -j KUBE-MARK-MASQ
-A KUBE-SEP-RLYUOFPY4DP6R7JM -p tcp -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper" -m tcp -j DNAT --to-destination 10.244.1.15:8000
-A KUBE-SEP-S7MPVVC7MGYVFSF3 -s 10.244.0.9/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-S7MPVVC7MGYVFSF3 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.9:53
-A KUBE-SEP-SISP6ORRA37L3ZYK -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:dns" -j KUBE-MARK-MASQ
-A KUBE-SEP-SISP6ORRA37L3ZYK -p udp -m comment --comment "kube-system/kube-dns:dns" -m udp -j DNAT --to-destination 10.244.0.8:53
-A KUBE-SEP-UUBFDOGZKSZ6QOBE -s 192.168.205.145/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-UUBFDOGZKSZ6QOBE -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 192.168.205.145:6443
-A KUBE-SEP-XNZERJBNXRGRQGMS -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:metrics" -j KUBE-MARK-MASQ
-A KUBE-SEP-XNZERJBNXRGRQGMS -p tcp -m comment --comment "kube-system/kube-dns:metrics" -m tcp -j DNAT --to-destination 10.244.0.8:9153
-A KUBE-SEP-XRFUWCXKVCLGWYQC -s 10.244.0.8/32 -m comment --comment "kube-system/kube-dns:dns-tcp" -j KUBE-MARK-MASQ
-A KUBE-SEP-XRFUWCXKVCLGWYQC -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp" -m tcp -j DNAT --to-destination 10.244.0.8:53
-A KUBE-SERVICES -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-SVC-TCOU7JCQXEZGVUNU
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-SVC-ERIFXISQEP7F7OF4
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-SVC-JD5MR3NA4I4DYORP
-A KUBE-SERVICES -d 10.97.121.82/32 -p tcp -m comment --comment "default/jtest cluster IP" -m tcp --dport 8080 -j KUBE-SVC-FXJ34XFJ55FJZHFP
-A KUBE-SERVICES -d 10.96.223.136/32 -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard cluster IP" -m tcp --dport 443 -j KUBE-SVC-CEZPIJSAUFW5MYPQ
-A KUBE-SERVICES -d 10.96.1.86/32 -p tcp -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper cluster IP" -m tcp --dport 8000 -j KUBE-SVC-Z6GDYMWE5TV2NNJN
-A KUBE-SERVICES -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-NPX46M4PTMTKRN6Y
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
-A KUBE-SVC-CEZPIJSAUFW5MYPQ ! -s 10.244.0.0/16 -d 10.96.223.136/32 -p tcp -m comment --comment "kubernetes-dashboard/kubernetes-dashboard cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-CEZPIJSAUFW5MYPQ -m comment --comment "kubernetes-dashboard/kubernetes-dashboard -> 10.244.2.12:8443" -j KUBE-SEP-M5AH7HXBJNRQUZER
-A KUBE-SVC-ERIFXISQEP7F7OF4 ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp cluster IP" -m tcp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.8:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-XRFUWCXKVCLGWYQC
-A KUBE-SVC-ERIFXISQEP7F7OF4 -m comment --comment "kube-system/kube-dns:dns-tcp -> 10.244.0.9:53" -j KUBE-SEP-S7MPVVC7MGYVFSF3
-A KUBE-SVC-FXJ34XFJ55FJZHFP ! -s 10.244.0.0/16 -d 10.97.121.82/32 -p tcp -m comment --comment "default/jtest cluster IP" -m tcp --dport 8080 -j KUBE-MARK-MASQ
-A KUBE-SVC-FXJ34XFJ55FJZHFP -m comment --comment "default/jtest -> 10.244.1.19:8080" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-M6GS57VBAWSHNQMT
-A KUBE-SVC-FXJ34XFJ55FJZHFP -m comment --comment "default/jtest -> 10.244.2.17:8080" -j KUBE-SEP-FWCNVWTS6ZPOZ3BF
-A KUBE-SVC-JD5MR3NA4I4DYORP ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:metrics cluster IP" -m tcp --dport 9153 -j KUBE-MARK-MASQ
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.8:9153" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-XNZERJBNXRGRQGMS
-A KUBE-SVC-JD5MR3NA4I4DYORP -m comment --comment "kube-system/kube-dns:metrics -> 10.244.0.9:9153" -j KUBE-SEP-CEWR77HQLZDHWWAJ
-A KUBE-SVC-NPX46M4PTMTKRN6Y ! -s 10.244.0.0/16 -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https -> 192.168.205.145:6443" -j KUBE-SEP-UUBFDOGZKSZ6QOBE
-A KUBE-SVC-TCOU7JCQXEZGVUNU ! -s 10.244.0.0/16 -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns cluster IP" -m udp --dport 53 -j KUBE-MARK-MASQ
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.8:53" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-SISP6ORRA37L3ZYK
-A KUBE-SVC-TCOU7JCQXEZGVUNU -m comment --comment "kube-system/kube-dns:dns -> 10.244.0.9:53" -j KUBE-SEP-LBMQNJ35ID4UIQ2A
-A KUBE-SVC-Z6GDYMWE5TV2NNJN ! -s 10.244.0.0/16 -d 10.96.1.86/32 -p tcp -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper cluster IP" -m tcp --dport 8000 -j KUBE-MARK-MASQ
-A KUBE-SVC-Z6GDYMWE5TV2NNJN -m comment --comment "kubernetes-dashboard/dashboard-metrics-scraper -> 10.244.1.15:8000" -j KUBE-SEP-RLYUOFPY4DP6R7JM
COMMIT
# Completed on Thu Feb  2 00:58:07 2023
# Generated by iptables-save v1.8.4 on Thu Feb  2 00:58:07 2023
*filter
:INPUT ACCEPT [175:65816]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [195:28238]
:FLANNEL-FWD - [0:0]
:KUBE-EXTERNAL-SERVICES - [0:0]
:KUBE-FORWARD - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-PROXY-FIREWALL - [0:0]
:KUBE-SERVICES - [0:0]
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -m comment --comment "flanneld forward" -j FLANNEL-FWD
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FLANNEL-FWD -s 10.244.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A FLANNEL-FWD -d 10.244.0.0/16 -m comment --comment "flanneld forward" -j ACCEPT
-A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
COMMIT
# Completed on Thu Feb  2 00:58:07 2023
# Generated by iptables-save v1.8.4 on Thu Feb  2 00:58:07 2023
*mangle
:PREROUTING ACCEPT [1793:705645]
:INPUT ACCEPT [1551:679866]
:FORWARD ACCEPT [242:25779]
:OUTPUT ACCEPT [1733:179087]
:POSTROUTING ACCEPT [1976:204939]
:KUBE-IPTABLES-HINT - [0:0]
:KUBE-KUBELET-CANARY - [0:0]
:KUBE-PROXY-CANARY - [0:0]
COMMIT
# Completed on Thu Feb  2 00:58:07 2023
```
