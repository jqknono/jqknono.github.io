---
layout: page
title: k8s网络
published: true
date: 2023-04-21 18:19:59
categories: 集群
tags: 
  - 集群
  - k8s
---

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [K8s 的基本概念](#k8s-的基本概念)
  - [Pod](#pod)
  - [Service(服务)](#service服务)
  - [网络策略](#网络策略)
  - [Node(节点)](#node节点)
  - [标签和选择算符](#标签和选择算符)
  - [镜像](#镜像)
- [网络](#网络)
  - [Kubernetes 网络模型](#kubernetes-网络模型)
  - [Pod 联网](#pod-联网)
  - [节点到控制面](#节点到控制面)
  - [控制面到节点](#控制面到节点)
  - [DNS](#dns)
  - [Pod 的 DNS 策略](#pod-的-dns-策略)
  - [IPv4/IPv6 双协议栈](#ipv4ipv6-双协议栈)
  - [服务内部流量策略](#服务内部流量策略)
  - [Ingress](#ingress)
  - [CNI](#cni)
  - [使用 Service 连接到应用](#使用-service-连接到应用)
- [网络扩展](#网络扩展)
- [拓扑感知](#拓扑感知)
  - [拓扑感知提示](#拓扑感知提示)
  - [使用拓扑键实现拓扑感知的流量路由](#使用拓扑键实现拓扑感知的流量路由)
  - [使用服务拓扑](#使用服务拓扑)
- [代理](#代理)
  - [kube-proxy](#kube-proxy)
  - [虚拟 IP 和服务代理](#虚拟-ip-和服务代理)
- [控制面](#控制面)
  - [通过 API 服务器来控制](#通过-api-服务器来控制)
  - [直接控制](#直接控制)
- [Windows 支持](#windows-支持)
- [参考](#参考)

<!-- /TOC -->

## K8s 的基本概念

一组工作机器，称为 **节点**， 会运行容器化应用程序。每个集群至少有一个工作节点。

工作节点会托管 Pod ，而 Pod 就是作为应用负载的组件。 控制平面管理集群中的工作节点和 Pod。 在生产环境中，控制平面通常跨多台计算机运行， 一个集群通常运行多个节点，提供容错性和高可用性。

- 除了 Docker 以外, Kubernetes 支持很多其它容器运行时, 但 Docker 是最有名的.

![picture 1](https://s2.loli.net/2023/05/06/5GHliN4JCUKPk2F.png)  

### Pod

- Pod 是可以在 Kubernetes 中创建和管理的、最小的可部署的计算单元.
- 可由一个或多个容器组成, 共享存储/网络.
- Pod 中的容器总是共同调度, 在共享的上下文中运行.
- Pod 类似于共享名字空间并共享文件系统卷的一组容器
- 主要两种用法
  - "每个 Pod 一个容器" 模型是最常见的 Kubernetes 用例； 在这种情况下，可以将 Pod 看作单个容器的包装器，并且 Kubernetes 直接管理 Pod，而不是容器。
  - Pod 可能封装由多个紧密耦合且需要共享资源的共处容器组成的应用程序。 这些位于同一位置的容器可能形成单个内聚的服务单元 —— 一个容器将文件从共享卷提供给公众， 而另一个单独的 “边车”（sidecar）容器则刷新或更新这些文件。 Pod 将这些容器和存储资源打包为一个可管理的实体。
- Pod 被设计成了相对临时性的、用后即抛的一次性实体。 当 Pod 由你或者间接地由控制器 创建时，它被调度在集群中的节点上运行。 Pod 会保持在该节点上运行，直到 Pod 结束执行、Pod 对象被删除、Pod 因资源不足而被驱逐或者节点失效为止。
- Pod 的名称必须是一个合法的 DNS 子域值， 但这可能对 Pod 的主机名产生意外的结果。为获得最佳兼容性，名称应遵循更严格的 DNS 标签规则。
- 每个 Pod 都在每个地址族中获得一个唯一的 IP 地址。 Pod 中的每个容器共享网络名字空间，包括 IP 地址和网络端口。 Pod 内的容器可以使用 localhost 互相通信。 当 Pod 中的容器与 Pod 之外的实体通信时，它们必须协调如何使用共享的网络资源（例如端口）。
- 检查机制, 使用探针来检查容器有四种不同的方法。 每个探针都必须准确定义为这四种机制中的一种：
  - **exec** 在容器内执行指定命令。如果命令退出时返回码为 0 则认为诊断成功。
  - **grpc** 使用 gRPC 执行一个远程过程调用。 目标应该实现 gRPC 健康检查。 如果响应的状态是 "SERVING"，则认为诊断成功。 gRPC 探针是一个 Alpha 特性，只有在你启用了 "GRPCContainerProbe" 特性门控时才能使用。
  - **httpGet** 对容器的 IP 地址上指定端口和路径执行 HTTP GET 请求。如果响应的状态码大于等于 200 且小于 400，则诊断被认为是成功的。
  - **tcpSocket** 对容器的 IP 地址上的指定端口执行 TCP 检查。如果端口打开，则诊断被认为是成功的。 如果远程系统（容器）在打开连接后立即将其关闭，这算作是健康的。

### Service(服务)

将运行在**一组 Pods 上的应用程序公开为网络服务**的抽象方法。

使用 Kubernetes，你无需修改应用程序去使用不熟悉的服务发现机制。

Kubernetes Pod 是转瞬即逝的。 Pod 实际上拥有 生命周期。 当一个工作 Node 挂掉后, 在 Node 上运行的 Pod 也会消亡。 ReplicaSet 会自动地通过创建新的 Pod 驱动集群回到目标状态，以保证应用程序正常运行。 换一个例子，考虑一个具有 3 个副本数的用作图像处理的后端程序。这些副本是可替换的; 前端系统不应该关心后端副本，即使 Pod 丢失或重新创建。也就是说，Kubernetes 集群中的每个 Pod (即使是在同一个 Node 上的 Pod )都有一个唯一的 IP 地址，因此需要一种方法自动协调 Pod 之间的变更，以便应用程序保持运行。

Kubernetes 中的服务(Service)是一种抽象概念，它定义了 Pod 的逻辑集和访问 Pod 的协议。Service 使从属 Pod 之间的松耦合成为可能。 和其他 Kubernetes 对象一样, Service 用 YAML (更推荐) 或者 JSON 来定义. Service 下的一组 Pod 通常由 LabelSelector (请参阅下面的说明为什么你可能想要一个 spec 中不包含 selector 的服务)来标记。

尽管每个 Pod 都有一个唯一的 IP 地址，但是如果没有 Service ，这些 IP 不会暴露在集群外部。Service 允许你的应用程序接收流量。Service 也可以用在 ServiceSpec 标记 type 的方式暴露

NAT: 网络地址转换
Source NAT: 替换数据包上的源 IP；在本页面中，这通常意味着替换为节点的 IP 地址
Destination NAT: 替换数据包上的目标 IP；在本页面中，这通常意味着替换为 Pod 的 IP 地址
VIP: 一个虚拟 IP 地址，例如分配给 Kubernetes 中每个 Service 的 IP 地址
Kube-proxy: 一个网络守护程序，在每个节点上协调 Service VIP 管理

### 网络策略

- ClusterIP (默认) - 在集群的内部 IP 上公开 Service 。这种类型使得 Service 只能从集群内访问。
- NodePort - 使用 NAT 在集群中每个选定 Node 的相同端口上公开 Service 。使用<NodeIP>:<NodePort> 从集群外部访问 Service。是 ClusterIP 的超集。
- LoadBalancer - 在当前云中创建一个外部负载均衡器(如果支持的话)，并为 Service 分配一个固定的外部 IP。是 NodePort 的超集。
- ExternalName - 通过返回带有该名称的 CNAME 记录，使用任意名称(由 spec 中的 externalName 指定)公开 Service。不使用代理。这种类型需要 kube-dns 的 v1.7 或更高版本。

- Kubernetes 为 Pod 提供自己的 IP 地址，并为一组 Pod 提供相同的 DNS 名， 并且可以在它们之间进行负载均衡。
- 如果你希望在 IP 地址或端口层面（OSI 第 3 层或第 4 层）控制网络流量， 则你可以考虑为集群中特定应用使用 Kubernetes 网络策略（NetworkPolicy）。 NetworkPolicy 是一种以应用为中心的结构，允许你设置如何允许 Pod 与网络上的各类网络“实体” 通信。 NetworkPolicy 适用于一端或两端与 Pod 的连接，与其他连接无关。
- Pod 可以通信的 Pod 是通过如下三个标识符的组合来辩识的：
  1. 其他被允许的 Pods（例外：Pod 无法阻塞对自身的访问）
  1. 被允许的名字空间
  1. IP 组块（例外：与 Pod 运行所在的节点的通信总是被允许的， 无论 Pod 或节点的 IP 地址）
- 网络策略通过网络插件来实现。 要使用网络策略，你必须使用支持 NetworkPolicy 的网络解决方案。 创建一个 NetworkPolicy 资源对象而没有控制器来使它生效的话，是没有任何作用的。
- Pod 隔离的两种类型
  - Pod 有两种隔离: 出口的隔离和入口的隔离。它们涉及到可以建立哪些连接。 这里的“隔离”不是绝对的，而是意味着“有一些限制”。 另外的，“非隔离方向”意味着在所述方向上没有限制。这两种隔离（或不隔离）是独立声明的， 并且都与从一个 Pod 到另一个 Pod 的连接有关。
  - 默认情况下，一个 Pod 的出口是非隔离的，即所有外向连接都是被允许的。如果有任何的 NetworkPolicy 选择该 Pod 并在其 policyTypes 中包含 “Egress”，则该 Pod 是出口隔离的， 我们称这样的策略适用于该 Pod 的出口。当一个 Pod 的出口被隔离时， 唯一允许的来自 Pod 的连接是适用于出口的 Pod 的某个 NetworkPolicy 的 egress 列表所允许的连接。 这些 egress 列表的效果是相加的。
  - 默认情况下，一个 Pod 对入口是非隔离的，即所有入站连接都是被允许的。如果有任何的 NetworkPolicy 选择该 Pod 并在其 policyTypes 中包含 “Ingress”，则该 Pod 被隔离入口， 我们称这种策略适用于该 Pod 的入口。当一个 Pod 的入口被隔离时，唯一允许进入该 Pod 的连接是来自该 Pod 节点的连接和适用于入口的 Pod 的某个 NetworkPolicy 的 ingress 列表所允许的连接。这些 ingress 列表的效果是相加的。
  - 网络策略是相加的，所以不会产生冲突。如果策略适用于 Pod 某一特定方向的流量， Pod 在对应方向所允许的连接是适用的网络策略所允许的集合。 因此，评估的顺序不影响策略的结果。

**通过网络策略（至少目前还）无法完成的工作:**

到 Kubernetes 1.26 为止，NetworkPolicy API 还不支持以下功能， 不过你可能可以使用操作系统组件（如 SELinux、OpenVSwitch、IPTables 等等） 或者第七层技术（Ingress 控制器、服务网格实现）或准入控制器来实现一些替代方案。 如果你对 Kubernetes 中的网络安全性还不太了解，了解使用 NetworkPolicy API 还无法实现下面的用户场景是很值得的。

- 强制集群内部流量经过某公用网关（这种场景最好通过服务网格或其他代理来实现）；
- 与 TLS 相关的场景（考虑使用服务网格或者 Ingress 控制器）；
- 特定于节点的策略（你可以使用 CIDR 来表达这一需求不过你无法使用节点在 Kubernetes 中的其他标识信息来辩识目标节点）；
- 基于名字来选择服务（不过，你可以使用 标签 来选择目标 Pod 或名字空间，这也通常是一种可靠的替代方案）；
- 创建或管理由第三方来实际完成的“策略请求”；
- 实现适用于所有名字空间或 Pods 的默认策略（某些第三方 Kubernetes 发行版本或项目可以做到这点）；
- 高级的策略查询或者可达性相关工具；
- 生成网络安全事件日志的能力（例如，被阻塞或接收的连接请求）；
- 显式地拒绝策略的能力（目前，NetworkPolicy 的模型默认采用拒绝操作， 其唯一的能力是添加允许策略）；
- 禁止本地回路或指向宿主的网络流量（Pod 目前无法阻塞 localhost 访问， 它们也无法禁止来自所在节点的访问请求）。

一个网络策略 NetworkPolicy 示例:

https://kubernetes.io/zh-cn/docs/concepts/services-networking/network-policies/

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: test-network-policy
namespace: default
spec:
podSelector:
  matchLabels:
    role: db
policyTypes:
  - Ingress
  - Egress
ingress:
  - from:
      - ipBlock:
          cidr: 172.17.0.0/16
          except:
            - 172.17.1.0/24
      - namespaceSelector:
          matchLabels:
            project: myproject
      - podSelector:
          matchLabels:
            role: frontend
    ports:
      - protocol: TCP
        port: 6379
egress:
  - to:
      - ipBlock:
          cidr: 10.0.0.0/24
    ports:
      - protocol: TCP
        port: 5978
```

### Node(节点)

- Kubernetes 通过将容器放入在节点（Node）上运行的 Pod 中来执行你的工作负载。 节点可以是一个虚拟机或者物理机器，取决于所在的集群配置。 每个节点包含运行 Pod 所需的服务； 这些节点由控制面负责管理。
- 通常集群中会有若干个节点；而在一个学习所用或者资源受限的环境中，你的集群中也可能只有一个节点。
- 节点上的组件包括 kubelet、 容器运行时以及 kube-proxy。
- kube-proxy 是集群中每个节点（node）上所运行的网络代理， 实现 Kubernetes 服务（Service） 概念的一部分。
- kube-proxy 维护节点上的一些网络规则， 这些网络规则会允许从集群内部或外部的网络会话与 Pod 进行网络通信。
- 如果操作系统提供了可用的数据包过滤层，则 kube-proxy 会通过它来实现网络规则。 否则，kube-proxy 仅做流量转发。
- 节点的名称用来标识 Node 对象。 没有两个 Node 可以同时使用相同的名称。 Kubernetes 还假定名字相同的资源是同一个对象。 就 Node 而言，隐式假定使用相同名称的实例会具有相同的状态（例如网络配置、根磁盘内容） 和类似节点标签这类属性。这可能在节点被更改但其名称未变时导致系统状态不一致。 如果某个 Node 需要被替换或者大量变更，需要从 API 服务器移除现有的 Node 对象， 之后再在更新之后重新将其加入。
- 节点地址
  - HostName：由节点的内核报告。可以通过 kubelet 的 --hostname-override 参数覆盖。
  - ExternalIP：通常是节点的可外部路由（从集群外可访问）的 IP 地址。
  - InternalIP：通常是节点的仅可在集群内部路由的 IP 地址。

### 标签和选择算符

**标签（Labels）**  是附加到 Kubernetes 对象（比如 Pod）上的键值对。 标签旨在用于指定对用户有意义且相关的对象的标识属性，但不直接对核心系统有语义含义。 标签可以用于组织和选择对象的子集。标签可以在创建时附加到对象，随后可以随时添加和修改。 每个对象都可以定义一组键/值标签。每个键对于给定对象必须是唯一的。

与**名称和 UID**不同， 标签不支持唯一性。通常，我们希望许多对象携带相同的标签。

通过**标签选择算符**，客户端/用户可以识别一组对象。标签选择算符是 Kubernetes 中的核心分组原语。

API 目前支持两种类型的选择算符：**基于等值的**和**基于集合的**。 标签选择算符可以由逗号分隔的多个**需求**组成。 在多个需求的情况下，必须满足所有要求，因此逗号分隔符充当逻辑**与**（`&&`）运算符。

空标签选择算符或者未指定的选择算符的语义取决于上下文， 支持使用选择算符的 API 类别应该将算符的合法性和含义用文档记录下来。

### 镜像

容器镜像（Image）所承载的是封装了应用程序及其所有软件依赖的二进制数据。 容器镜像是可执行的软件包，可以单独运行；该软件包对所处的运行时环境具有良定（Well Defined）的假定。

你通常会创建应用的容器镜像并将其推送到某仓库（Registry），然后在 Pod 中引用它。

## 网络

### Kubernetes 网络模型

集群中每一个 Pod 都会获得自己的、 独一无二的 IP 地址， 这就意味着你不需要显式地在 Pod 之间创建链接，你几乎不需要处理容器端口到主机端口之间的映射。 这将形成一个干净的、向后兼容的模型；在这个模型里，从端口分配、命名、服务发现、 负载均衡、 应用配置和迁移的角度来看，Pod 可以被视作虚拟机或者物理主机。

Kubernetes 强制要求所有网络设施都满足以下基本要求（从而排除了有意隔离网络的策略）：

- Pod 能够与所有其他节点上的 Pod 通信， 且不需要网络地址转译（NAT）
- 节点上的代理（比如：系统守护进程、kubelet）可以和节点上的所有 Pod 通信

说明：对于支持在主机网络中运行 Pod 的平台（比如：Linux）， 当 Pod 挂接到节点的宿主网络上时，它们仍可以不通过 NAT 和所有节点上的 Pod 通信。

Kubernetes 的 IP 地址存在于 Pod 范围内 —— 容器共享它们的网络命名空间 —— 包括它们的 IP 地址和 MAC 地址。 这就意味着 Pod 内的容器都可以通过 localhost 到达对方端口。 这也意味着 Pod 内的容器需要相互协调端口的使用，但是这和虚拟机中的进程似乎没有什么不同， 这也被称为“一个 Pod 一个 IP”模型。

也可以在 Node 本身请求端口，并用这类端口转发到你的 Pod（称之为主机端口）， 但这是一个很特殊的操作。转发方式如何实现也是容器运行时的细节。 Pod 自己并不知道这些主机端口的存在。

**Kubernetes 网络解决四方面的问题：**

- 一个 Pod 中的容器之间通过本地回路（loopback）通信。
- 集群网络在不同 Pod 之间提供通信。
- Service API 允许你向外暴露 Pod 中运行的应用， 以支持来自于集群外部的访问。
  - Ingress 提供专门用于暴露 HTTP 应用程序、网站和 API 的额外功能。
- 你也可以使用 Service 来发布仅供集群内部使用的服务。

集群网络系统是 Kubernetes 的核心部分，但是想要准确了解它的工作原理可是个不小的挑战。 下面列出的是网络系统的的四个主要问题：

1. 高度耦合的容器间通信：这个已经被 Pod 和 `localhost` 通信解决了。
1. Pod 间通信：这是本文档讲述的重点。
1. Pod 与 Service 间通信：涵盖在 Service 中。
1. 外部与 Service 间通信：也涵盖在 Service 中。

Kubernetes 的宗旨就是在应用之间共享机器。 通常来说，共享机器需要两个应用之间不能使用相同的端口，但是在多个应用开发者之间 去大规模地协调端口是件很困难的事情，尤其是还要让用户暴露在他们控制范围之外的集群级别的问题上。

动态分配端口也会给系统带来很多复杂度 - 每个应用都需要设置一个端口的参数， 而 API 服务器还需要知道如何将动态端口数值插入到配置模块中，服务也需要知道如何找到对方等等。

网络模型由每个节点上的容器运行时实现。最常见的容器运行时使用 Container Network Interface (CNI) 插件来管理其网络和安全功能。 许多不同的 CNI 插件来自于许多不同的供应商。其中一些仅提供添加和删除网络接口的基本功能， 而另一些则提供更复杂的解决方案，例如与其他容器编排系统集成、运行多个 CNI 插件、高级 IPAM 功能等。

### Pod 联网

每个 Pod 都在每个地址族中获得一个唯一的 IP 地址。 Pod 中的每个容器共享网络名字空间，包括 IP 地址和网络端口。 Pod 内的容器可以使用 localhost 互相通信。 当 Pod 中的容器与 Pod 之外的实体通信时，它们必须协调如何使用共享的网络资源（例如端口）。

在同一个 Pod 内，所有容器共享一个 IP 地址和端口空间，并且可以通过 localhost 发现对方。 他们也能通过如 SystemV 信号量或 POSIX 共享内存这类标准的进程间通信方式互相通信。 不同 Pod 中的容器的 IP 地址互不相同，如果没有特殊配置，就无法通过 OS 级 IPC 进行通信。 如果某容器希望与运行于其他 Pod 中的容器通信，可以通过 IP 联网的方式实现。

Pod 中的容器所看到的系统主机名与为 Pod 配置的 name 属性值相同。 网络部分提供了更多有关此内容的信息。

### 节点到控制面

当 Pod 被实例化时，Kubernetes 自动把公共根证书和一个有效的持有者令牌注入到 Pod 里。 kubernetes 服务（位于 default 名字空间中）配置了一个虚拟 IP 地址， 用于（通过 kube-proxy）转发请求到 API 服务器的 HTTPS 末端。

从集群节点和节点上运行的 Pod 到控制面的连接的缺省操作模式即是安全的， 能够在不可信的网络或公网上运行。

### 控制面到节点

根据文档https://kubernetes.io/zh-cn/docs/concepts/architecture/control-plane-node-communication/, 目前从控制面（API 服务器）到节点有两种主要的通信路径:

- 从 API 服务器到集群中每个节点上运行的 kubelet 进程。
  - 从 API 服务器到 kubelet 的连接用于：
    - 获取 Pod 日志
    - 挂接（通过 kubectl）到运行中的 Pod
    - 提供 kubelet 的端口转发功能。
  - 这些连接终止于 kubelet 的 HTTPS 末端。 默认情况下，API 服务器不检查 kubelet 的服务证书。这使得此类连接容易受到中间人攻击， 在非受信网络或公开网络上运行也是 不安全的。
  - 为了对这个连接进行认证，使用 --kubelet-certificate-authority 标志给 API 服务器提供一个根证书包，用于 kubelet 的服务证书。
  - 应该启用 Kubelet 认证/鉴权 来保护 kubelet API
- 从 API 服务器通过它的代理功能连接到任何节点、Pod 或者服务。
  - 从 API 服务器到节点、Pod 或服务的连接默认为纯 HTTP 方式，因此既没有认证，也没有加密。 这些连接可通过给 API URL 中的节点、Pod 或服务名称添加前缀 https: 来运行在安全的 HTTPS 连接上。 不过这些连接既不会验证 HTTPS 末端提供的证书，也不会提供客户端证书。 因此，虽然连接是加密的，仍无法提供任何完整性保证。 这些连接 目前还不能安全地 在非受信网络或公共网络上运行。
- Konnectivity 服务, 作为 SSH 隧道的替代方案，Konnectivity 服务提供 TCP 层的代理，以便支持从控制面到集群的通信。 Konnectivity 服务包含两个部分：Konnectivity 服务器和 Konnectivity 代理， 分别运行在控制面网络和节点网络中。 Konnectivity 代理建立并维持到 Konnectivity 服务器的网络连接。 启用 Konnectivity 服务之后，所有控制面到节点的通信都通过这些连接传输。

### DNS

[dns-pod-service](https://kubernetes.io/zh-cn/docs/concepts/services-networking/dns-pod-service/)

[Kubernetes DNS-Based Service Discovery](https://github.com/kubernetes/dns/blob/master/docs/specification.md)

Kubernetes 为 Service 和 Pod 创建 DNS 记录。 你可以使用一致的 DNS 名称而非 IP 地址访问 Service。

Kubernetes DNS 除了在集群上调度 DNS Pod 和 Service， 还配置 kubelet 以告知各个容器使用 DNS Service 的 IP 来解析 DNS 名称。

集群中定义的每个 Service （包括 DNS 服务器自身）都被赋予一个 DNS 名称。 默认情况下，客户端 Pod 的 DNS 搜索列表会包含 Pod 自身的名字空间和集群的默认域。

DNS 查询可能因为执行查询的 Pod 所在的名字空间而返回不同的结果。 不指定名字空间的 DNS 查询会被限制在 Pod 所在的名字空间内。 要访问其他名字空间中的 Service，需要在 DNS 查询中指定名字空间。

例如，假定名字空间 test 中存在一个 Pod，prod 名字空间中存在一个服务 data。

Pod 查询 data 时没有返回结果，因为使用的是 Pod 的名字空间 test。

Pod 查询 data.prod 时则会返回预期的结果，因为查询中指定了名字空间。

DNS 查询可以使用 Pod 中的 /etc/resolv.conf 展开。kubelet 会为每个 Pod 生成此文件。例如，对 data 的查询可能被展开为 data.test.svc.cluster.local。 search 选项的取值会被用来展开查询。

哪些对象会获得 DNS 记录呢？

1. Services
   1. A/AAAA 记录
   2. SRV 记录, SRV 记录是在 DNS 中指定端口的方式。
2. Pods 1. 当前，创建 Pod 时其主机名取自 Pod 的 metadata.name 值。
   Pod 规约中包含一个可选的 hostname 字段，可以用来指定 Pod 的主机名。 当这个字段被设置时，它将优先于 Pod 的名字成为该 Pod 的主机名。 举个例子，给定一个 hostname 设置为 "my-host" 的 Pod， 该 Pod 的主机名将被设置为 "my-host"。
   Pod 规约还有一个可选的 subdomain 字段，可以用来指定 Pod 的子域名。 举个例子，某 Pod 的 hostname 设置为 “foo”，subdomain 设置为 “bar”， 在名字空间 “my-namespace” 中对应的完全限定域名（FQDN）为 “foo.bar.my-namespace.svc.cluster-domain.example”。

如果某无头 Service 与某 Pod 在同一个名字空间中，且它们具有相同的子域名， 集群的 DNS 服务器也会为该 Pod 的全限定主机名返回 A 记录或 AAAA 记录。 例如，在同一个名字空间中，给定一个主机名为 “busybox-1”、 子域名设置为 “default-subdomain” 的 Pod，和一个名称为 “default-subdomain” 的无头 Service，Pod 将看到自己的 FQDN 为 "busybox-1.default-subdomain.my-namespace.svc.cluster-domain.example"。 DNS 会为此名字提供一个 A 记录或 AAAA 记录，指向该 Pod 的 IP。 “busybox1” 和 “busybox2” 这两个 Pod 分别具有它们自己的 A 或 AAAA 记录。

### Pod 的 DNS 策略

DNS 策略可以逐个 Pod 来设定。目前 Kubernetes 支持以下特定 Pod 的 DNS 策略。 这些策略可以在 Pod 规约中的 dnsPolicy 字段设置：

- "Default": Pod 从运行所在的节点继承名称解析配置。
- "ClusterFirst": 与配置的集群域后缀不匹配的任何 DNS 查询（例如 "www.kubernetes.io"） 都会由 DNS 服务器转发到上游名称服务器。集群管理员可能配置了额外的存根域和上游 DNS 服务器。
- "ClusterFirstWithHostNet": 对于以 hostNetwork 方式运行的 Pod，应将其 DNS 策略显式设置为 "ClusterFirstWithHostNet"。否则，以 hostNetwork 方式和 "ClusterFirst" 策略运行的 Pod 将会做出回退至 "Default" 策略的行为。
  - 注意：这在 Windows 上不支持。
- "None": 此设置允许 Pod 忽略 Kubernetes 环境中的 DNS 设置。Pod 会使用其 dnsConfig 字段所提供的 DNS 设置。

**说明：**
"Default" 不是默认的 DNS 策略。如果未明确指定 dnsPolicy，则使用 "ClusterFirst"。

**Pod 的 DNS 配置**
Pod 的 DNS 配置可让用户对 Pod 的 DNS 设置进行更多控制。

`dnsConfig ` 字段是可选的，它可以与任何 `dnsPolicy` 设置一起使用。 但是，当 Pod 的`dnsPolicy`设置为 "None" 时，必须指定 dnsConfig 字段。

用户可以在 dnsConfig 字段中指定以下属性：

- nameservers：将用作于 Pod 的 DNS 服务器的 IP 地址列表。 最多可以指定 3 个 IP 地址。当 Pod 的 dnsPolicy 设置为 "None" 时， 列表必须至少包含一个 IP 地址，否则此属性是可选的。 所列出的服务器将合并到从指定的 DNS 策略生成的基本名称服务器，并删除重复的地址。
- searches：用于在 Pod 中查找主机名的 DNS 搜索域的列表。此属性是可选的。 指定此属性时，所提供的列表将合并到根据所选 DNS 策略生成的基本搜索域名中。 重复的域名将被删除。Kubernetes 最多允许 6 个搜索域。
- options：可选的对象列表，其中每个对象可能具有 name 属性（必需）和 value 属性（可选）。 此属性中的内容将合并到从指定的 DNS 策略生成的选项。 重复的条目将被删除。

示例: https://kubernetes.io/zh-cn/docs/concepts/services-networking/dns-pod-service/

### IPv4/IPv6 双协议栈

https://kubernetes.io/zh-cn/docs/concepts/services-networking/dual-stack/

IPv4/IPv6 双协议栈网络能够将 IPv4 和 IPv6 地址分配给 Pod 和 Service。

从 1.21 版本开始，Kubernetes 集群默认启用 IPv4/IPv6 双协议栈网络， 以支持同时分配 IPv4 和 IPv6 地址。

Kubernetes 集群的 IPv4/IPv6 双协议栈可提供下面的功能：

- 双协议栈 pod 网络 (每个 pod 分配一个 IPv4 和 IPv6 地址)
- IPv4 和 IPv6 启用的服务
- Pod 的集群外出口通过 IPv4 和 IPv6 路由

### 服务内部流量策略

- 服务内部流量策略开启了内部流量限制，将内部流量只路由到发起方所处节点内的服务端点。 这里的”内部“流量指当前集群中的 Pod 所发起的流量。 这种机制有助于节省开销，提升效率。
- 你可以通过将 Service 的 .spec.internalTrafficPolicy 项设置为 Local， 来为它指定一个内部专用的流量策略。 此设置就相当于告诉 kube-proxy 对于集群内部流量只能使用节点本地的服务端口。
- kube-proxy 基于 spec.internalTrafficPolicy 的设置来过滤路由的目标服务端点。 当它的值设为 Local 时，只会选择节点本地的服务端点。 当它的值设为 Cluster 或缺省时，Kubernetes 会选择所有的服务端点。

### Ingress

- Ingress 公开从集群外部到集群内服务的 HTTP 和 HTTPS 路由。 流量路由由 Ingress 资源上定义的规则控制。
- Ingress 是对集群中服务的外部访问进行管理的 API 对象，典型的访问方式是 HTTP。
- Ingress 可以提供负载均衡、SSL 终结和基于名称的虚拟托管。
- Ingress 可为 Service 提供外部可访问的 URL、负载均衡流量、终止 SSL/TLS，以及基于名称的虚拟托管。 Ingress 控制器 通常负责通过负载均衡器来实现 Ingress，尽管它也可以配置边缘路由器或其他前端来帮助处理流量。
- Ingress 不会公开任意端口或协议。 将 HTTP 和 HTTPS 以外的服务公开到 Internet 时，通常使用 Service.Type=NodePort 或 Service.Type=LoadBalancer 类型的 Service

为了表达更加清晰，本指南定义了以下术语：

- 节点（Node）: Kubernetes 集群中的一台工作机器，是集群的一部分。
- 集群（Cluster）: 一组运行由 Kubernetes 管理的容器化应用程序的节点。 在此示例和在大多数常见的 Kubernetes 部署环境中，集群中的节点都不在公共网络中。
- 边缘路由器（Edge Router）: 在集群中强制执行防火墙策略的路由器。可以是由云提供商管理的网关，也可以是物理硬件。
- 集群网络（Cluster Network）: 一组逻辑的或物理的连接，根据 Kubernetes [网络模型](https://kubernetes.io/zh-cn/docs/concepts/cluster-administration/networking/)在集群内实现通信。
- 服务（Service）：Kubernetes [服务（Service）](https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/)， 使用[标签](https://kubernetes.io/zh-cn/docs/concepts/overview/working-with-objects/labels/)选择器（selectors）辨认一组 Pod。 除非另有说明，否则假定服务只具有在集群网络中可路由的虚拟 IP。

### CNI

Container Network Interface
https://github.com/containernetworking/cni

CNI (Container Network Interface), a Cloud Native Computing Foundation project, consists of a specification and libraries for writing plugins to configure network interfaces in Linux containers, along with a number of supported plugins.

### 使用 Service 连接到应用

https://kubernetes.io/zh-cn/docs/tutorials/services/connect-applications-service/

- Kubernetes 假设 Pod 可与其它 Pod 通信，不管它们在哪个主机上。 Kubernetes 给每一个 Pod 分配一个集群私有 IP 地址，所以没必要在 Pod 与 Pod 之间创建连接或将容器的端口映射到主机端口。 这意味着同一个 Pod 内的所有容器能通过 localhost 上的端口互相连通，集群中的所有 Pod 也不需要通过 NAT 转换就能够互相看到。 本文档的剩余部分详述如何在上述网络模型之上运行可靠的服务。
- 我们有一组在一个扁平的、集群范围的地址空间中运行 Nginx 服务的 Pod。 理论上，你可以直接连接到这些 Pod，但如果某个节点死掉了会发生什么呢？ Pod 会终止，Deployment 将创建新的 Pod，且使用不同的 IP。这正是 Service 要解决的问题。

- Kubernetes Service 是集群中提供相同功能的一组 Pod 的抽象表达。 当每个 Service 创建时，会被分配一个唯一的 IP 地址（也称为 clusterIP）。 **这个 IP 地址与 Service 的生命周期绑定在一起，只要 Service 存在，它就不会改变。** 可以配置 Pod 使它与 Service 进行通信，Pod 知道与 Service 通信将被自动地负载均衡到该 Service 中的某些 Pod 上。

Kubernetes 支持两种查找服务的主要模式：环境变量和 DNS。前者开箱即用，而后者则需要 CoreDNS 集群插件。
说明：
如果不需要服务环境变量（因为可能与预期的程序冲突，可能要处理的变量太多，或者仅使用 DNS 等），则可以通过在 pod spec 上将 enableServiceLinks 标志设置为 false 来禁用此模式。

Kubernetes 提供了一个自动为其它 Service 分配 DNS 名字的 DNS 插件 Service。 你可以通过如下命令检查它是否在工作：
`kubectl get services kube-dns --namespace=kube-system`

对应用的某些部分，你可能希望将 Service 暴露在一个外部 IP 地址上。 Kubernetes 支持两种实现方式：NodePort 和 LoadBalancer。 在上一段创建的 Service 使用了 NodePort，因此，如果你的节点有一个公网 IP，那么 Nginx HTTPS 副本已经能够处理因特网上的流量。

## 网络扩展

[安装扩展](https://kubernetes.io/zh-cn/docs/concepts/cluster-administration/addons/#networking-and-network-policy)

在网络语境中，容器运行时（Container Runtime）是在节点上的守护进程， 被配置用来为 kubelet 提供 CRI 服务。具体而言，容器运行时必须配置为加载所需的 CNI 插件，从而实现 Kubernetes 网络模型。
https://kubernetes.io/zh-cn/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/

## 拓扑感知

### 拓扑感知提示

https://kubernetes.io/zh-cn/docs/concepts/services-networking/topology-aware-hints/

**拓扑感知提示**包含客户怎么使用服务端点的建议，从而实现了拓扑感知的路由功能。 这种方法添加了元数据，以启用 EndpointSlice（或 Endpoints）对象的调用者， 这样，访问这些网络端点的请求流量就可以在它的发起点附近就近路由。

例如，你可以在一个地域内路由流量，以降低通信成本，或提高网络性能。

### 使用拓扑键实现拓扑感知的流量路由

https://kubernetes.io/zh-cn/docs/concepts/services-networking/service-topology/

服务拓扑（Service Topology）可以让一个服务基于集群的 Node 拓扑进行流量路由。 例如，一个服务可以指定流量是被优先路由到一个和客户端在同一个 Node 或者在同一可用区域的端点。

默认情况下，发往 ClusterIP 或者 NodePort 服务的流量可能会被路由到服务的任一后端的地址。 Kubernetes 1.7 允许将“外部”流量路由到接收到流量的节点上的 Pod。对于 ClusterIP 服务，无法完成同节点优先的路由，你也无法配置集群优选路由到同一可用区中的端点。 通过在 Service 上配置 topologyKeys，你可以基于来源节点和目标节点的标签来定义流量路由策略。

通过对源和目的之间的标签匹配，作为集群操作者的你可以根据节点间彼此“较近”和“较远” 来定义节点集合。你可以基于符合自身需求的任何度量值来定义标签。 例如，在公有云上，你可能更偏向于把流量控制在同一区内，因为区间流量是有费用成本的， 而区内流量则没有。 其它常见需求还包括把流量路由到由 DaemonSet 管理的本地 Pod 上，或者把将流量转发到连接在同一机架交换机的节点上，以获得低延时。

### 使用服务拓扑

如果集群启用了 ServiceTopology 特性门控， 你就可以在 Service 规约中设定 topologyKeys 字段，从而控制其流量路由。 此字段是 Node 标签的优先顺序字段，将用于在访问这个 Service 时对端点进行排序。 流量会被定向到第一个标签值和源 Node 标签值相匹配的 Node。 如果这个 Service 没有匹配的后端 Node，那么第二个标签会被使用做匹配， 以此类推，直到没有标签。

如果没有匹配到，流量会被拒绝，就如同这个 Service 根本没有后端。 换言之，系统根据可用后端的第一个拓扑键来选择端点。 如果这个字段被配置了而没有后端可以匹配客户端拓扑，那么这个 Service 对那个客户端是没有后端的，链接应该是失败的。 这个字段配置为 "\*" 意味着任意拓扑。 这个通配符值如果使用了，那么只有作为配置值列表中的最后一个才有用。

如果 topologyKeys 没有指定或者为空，就没有启用这个拓扑约束。

一个集群中，其 Node 的标签被打为其主机名，区域名和地区名。 那么就可以设置 Service 的 topologyKeys 的值，像下面的做法一样定向流量了。

- 只定向到同一个 Node 上的端点，Node 上没有端点存在时就失败： 配置 ["kubernetes.io/hostname"]。
- 偏向定向到同一个 Node 上的端点，回退同一区域的端点上，然后是同一地区， 其它情况下就失败：配置 ["kubernetes.io/hostname", "topology.kubernetes.io/zone", "topology.kubernetes.io/region"]。 这或许很有用，例如，数据局部性很重要的情况下。
- 偏向于同一区域，但如果此区域中没有可用的终结点，则回退到任何可用的终结点： 配置 ["topology.kubernetes.io/zone", "*"]。

## 代理

### kube-proxy

https://kubernetes.io/zh-cn/docs/reference/command-line-tools-reference/kube-proxy/

Kubernetes 网络代理在每个节点上运行。网络代理反映了每个节点上 Kubernetes API 中定义的服务，并且可以执行简单的 TCP、UDP 和 SCTP 流转发，或者在一组后端进行 循环 TCP、UDP 和 SCTP 转发。 当前可通过 Docker-links-compatible 环境变量找到服务集群 IP 和端口， 这些环境变量指定了服务代理打开的端口。 有一个可选的插件，可以为这些集群 IP 提供集群 DNS。 用户必须使用 apiserver API 创建服务才能配置代理。

```
kube-proxy [flags]
```

### 虚拟 IP 和服务代理

Kubernetes 集群中的每个[节点](https://kubernetes.io/zh-cn/docs/concepts/architecture/nodes/)会运行一个  [kube-proxy](https://kubernetes.io/zh-cn/docs/reference/command-line-tools-reference/kube-proxy/) （除非你已经部署了自己的替换组件来替代  `kube-proxy`）。

`kube-proxy`  组件负责除  `type`  为  [`ExternalName`](https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/#externalname)  以外的[服务](https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/)，实现**虚拟 IP**  机制。

一个时不时出现的问题是，为什么 Kubernetes 依赖代理将入站流量转发到后端。 其他方案呢？例如，是否可以配置具有多个 A 值（或 IPv6 的 AAAA）的 DNS 记录， 使用轮询域名解析？

使用代理转发方式实现 Service 的原因有以下几个：

- DNS 的实现不遵守记录的 TTL 约定的历史由来已久，在记录过期后可能仍有结果缓存。
- 有些应用只做一次 DNS 查询，然后永久缓存结果。
- 即使应用程序和库进行了适当的重新解析，TTL 取值较低或为零的 DNS 记录可能会给 DNS 带来很大的压力， 从而变得难以管理。

在下文中，你可以了解到 kube-proxy 各种实现方式的工作原理。 总的来说，你应该注意到，在运行  `kube-proxy`  时， 可能会修改内核级别的规则（例如，可能会创建 iptables 规则）， 在某些情况下，这些规则直到重启才会被清理。 因此，运行 kube-proxy 这件事应该只由了解在计算机上使用低级别、特权网络代理服务会带来的后果的管理员执行。 尽管  `kube-proxy`  可执行文件支持  `cleanup`  功能，但这个功能并不是官方特性，因此只能根据具体情况使用。

与实际路由到固定目标的 Pod IP 地址不同，Service IP 实际上不是由单个主机回答的。 相反，kube-proxy 使用数据包处理逻辑（例如 Linux 的 iptables） 来定义虚拟 IP 地址，这些地址会按需被透明重定向。

当客户端连接到 VIP 时，其流量会自动传输到适当的端点。 实际上，Service 的环境变量和 DNS 是根据 Service 的虚拟 IP 地址（和端口）填充的。

#### 代理模式

注意，kube-proxy 会根据不同配置以不同的模式启动。

- kube-proxy 的配置是通过 ConfigMap 完成的，kube-proxy 的 ConfigMap 实际上弃用了 kube-proxy 大部分标志的行为。
- kube-proxy 的 ConfigMap 不支持配置的实时重新加载。
- kube-proxy 不能在启动时验证和检查所有的 ConfigMap 参数。 例如，如果你的操作系统不允许你运行 iptables 命令，标准的 kube-proxy 内核实现将无法工作。 同样，如果你的操作系统不支持  `netsh`，它也无法在 Windows 用户空间模式下运行。

## 控制面

在 Kubernetes 中，控制器通过监控集群   的公共状态，并致力于将当前状态转变为期望的状态。

### 通过 API 服务器来控制

Job  控制器是一个 Kubernetes 内置控制器的例子。 内置控制器通过和集群 API 服务器交互来管理状态。

### 直接控制

相比 Job 控制器，有些控制器需要对集群外的一些东西进行修改。

和外部状态交互的控制器从 API 服务器获取到它想要的状态，然后直接和外部系统进行通信 并使当前状态更接近期望状态。

## Windows 支持

根据 https://kubernetes.io/zh-cn/docs/concepts/windows/intro/

支持 Windows  节点的前提是操作系统为 Windows Server 2019。

k8s 支持的操作系统较新, 并且存在一些限制, 考虑放弃适配和微隔离 agent 的配合工作.

## 参考

- [kube-controller-manager](https://kubernetes.io/zh-cn/docs/reference/command-line-tools-reference/kube-controller-manager/)
- [Kubernetes API](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/)
