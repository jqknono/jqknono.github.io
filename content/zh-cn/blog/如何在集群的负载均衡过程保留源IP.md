---
layout: blog
title: 如何在集群的负载均衡过程保留请求源IP
published: true
categories: 网络
tags: [网络, blog]
date: 2024-05-27 11:52:22 +0800
draft: false
toc: false
comments: false
---

## 引言

**应用部署**不一定总是简单的**安装**和**运行**, 有时候还需要考虑**网络**的问题. 本文将介绍如何在**k8s集群**中使服务能获取到请求的**源IP**.

应用提供服务一般依赖输入信息, 输入信息如果不依赖**五元组**(源 IP, 源端口, 目的 IP, 目的端口, 协议), 那么该服务和**网络耦合性低**, 不需要关心网络细节.

因此, 对多数人来说都没有阅读本文的必要, 如果你对网络感兴趣, 或者希望拓宽一点视野, 可以继续阅读下文, 了解更多的服务场景.

本文基于 k8s `v1.29.4`, 文中部分叙述混用了 pod 和 endpoint, 本文场景下可以视为等价.

**如果有错误, 欢迎指正, 我会及时更正.**

## 为什么源 IP 信息会丢失?

我们首先明确源 IP 是什么, 当 A 向 B 发送请求, B 将请求转发给 C, 虽然 C 看到的 IP 协议的源 IP 是 B 的 IP, 但本文把**A的IP**看作源 IP.

主要有两类行为会导致源信息丢失:

1. **网络地址转换(NAT)**, 目的是节省公网 IPv4, 负载均衡等. 将导致服务端看到的源 IP 是 **NAT** 设备的 IP, 而不是真实的源 IP.
1. **代理(Proxy)**, **反向代理**(RP, Reverse Proxy)和**负载均衡**(LB, Load Balancer)都属于这一类, 下文统称**代理服务器**. 这类代理服务会将请求转发给后端服务, 但是会将源 IP 替换为自己的 IP.

- NAT 简单来说是**以端口空间换IP空间**, IPv4 地址有限, 一个 IP 地址可以映射 65535 个端口, 绝大多数时候这些端口没有用完, 因而可以多个子网 IP 共用一个公网 IP, 在端口上区分不同的服务. 其使用形式是: `public IP:public port -> private IP_1:private port`, 更多内容请自行参阅[网络地址转换](https://www.google.com/search?q=%E7%BD%91%E7%BB%9C%E5%9C%B0%E5%9D%80%E8%BD%AC%E6%8D%A2)
- 代理服务是为了**隐藏或暴露**, 代理服务会将请求转发给后端服务, 同时将源 IP 替换为自己的 IP, 以此来隐藏后端服务的真实 IP, 保护后端服务的安全. 代理服务的使用形式是: `client IP -> proxy IP -> server IP`, 更多内容请自行参阅[代理](https://www.google.com/search?q=%E4%BB%A3%E7%90%86)

**NAT**和**代理服务器**都非常常见, 多数服务都无法获得请求的源 IP.

_这是常见的两类修改源 IP 的途径, 如有其它欢迎补充._

## 如何保留源 IP?

以下是一个 `HTTP 请求`的例子:

| 字段          | 长度（字节） | 位偏移  | 描述                                            |
| ------------- | ------------ | ------- | ----------------------------------------------- |
| **IP 首部**   |              |         |                                                 |
| `源 IP`       | 4            | 0-31    | 发送方的 IP 地址                                |
| 目的 IP       | 4            | 32-63   | 接收方的 IP 地址                                |
| **TCP 首部**  |              |         |                                                 |
| 源端口        | 2            | 0-15    | 发送端口号                                      |
| 目的端口      | 2            | 16-31   | 接收端口号                                      |
| 序列号        | 4            | 32-63   | 用于标识发送方发送的数据的字节流                |
| 确认号        | 4            | 64-95   | 如果设置了 ACK 标志，则为下一个期望收到的序列号 |
| 数据偏移      | 4            | 96-103  | 数据起始位置相对于 TCP 首部的字节数             |
| 保留          | 4            | 104-111 | 保留字段，未使用，设置为 0                      |
| 标志位        | 2            | 112-127 | 各种控制标志，如 SYN、ACK、FIN 等               |
| 窗口大小      | 2            | 128-143 | 接收方可以接收的数据量                          |
| 检验和        | 2            | 144-159 | 用于检测数据是否在传输过程中发生了错误          |
| 紧急指针      | 2            | 160-175 | 发送方希望接收方尽快处理的紧急数据的位置        |
| 选项          | 可变         | 176-... | 可能包括时间戳、最大报文段长度等                |
| **HTTP 首部** |              |         |                                                 |
| 请求行        | 可变         | ...-... | 包括请求方法、URI 和 HTTP 版本                  |
| `头部字段`    | 可变         | ...-... | 包含各种头部字段，如 Host、User-Agent 等        |
| 空行          | 2            | ...-... | 用于分隔头部和主体部分                          |
| 主体          | 可变         | ...-... | 可选的请求或响应正文                            |

浏览以上 HTTP 请求结构, 可以发现, 有**TCP选项**,**请求行**, **头部字段**,**主体**是可变的, 其中**TCP选项**空间有限, 一般不会用来传递源 IP, **请求行**携带信息固定不能扩展, **HTTP主体**加密后不能修改, 只有`HTTP 头部字段`适合扩展传递源 IP.

HTTP header 中可以增加`X-REAL-IP`字段, 用来传递源 IP, 这个操作通常放在代理服务器上, 然后**代理服务器**会将请求发送给后端服务, 后端服务就可以通过这个字段获取到源 IP 信息.

注意, 需要保证**代理服务器**在**NAT**设备之前, 这样才能获取到真实的请求的源 whoami. 我们可以在阿里云的产品中看到[**负载均衡器**](https://slb.console.aliyun.com/overview)这个商品单独品类, 它在网络中的位置不同于普通的应用服务器.

## K8S 操作指导

以[whoami](https://github.com/traefik/whoami)项目为例进行部署.

### 创建 Deployment

首先创建服务:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: whoami
  template:
    metadata:
      labels:
        app: whoami
    spec:
      containers:
        - name: whoami
          image: docker.io/traefik/whoami:latest
          ports:
            - containerPort: 8080
```

这步会创建一个**Deployment**, 里面包含 3 个**Pod**, 每个 pod 包含一个容器, 该容器会运行**whoami**服务.

### 创建 Service

可以创建**NodePort**或者**LoadBalancer**类型的服务, 支持外部访问, 或者创建**ClusterIP**类型的服务, 仅支持集群内部访问, 再增加**Ingress**服务, 通过**Ingress**服务暴露外部访问.

**NodePort**既可以通过**NodeIP:NodePort**访问, 也可以通过**Ingess**服务访问, 方便测试, 本节使用**NodePort**服务.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: whoami-service
spec:
  type: NodePort
  selector:
    app: whoami
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
      nodePort: 30002
```

创建服务后, 以`curl whoami.example.com:30002`访问, 可以看到返回的 IP 是**NodeIP**, 而不是请求的源 whoami.

> 请注意，这并不是正确的客户端 IP，它们是集群的内部 IP。这是所发生的事情：
>
> - 客户端发送数据包到 node2:nodePort
> - node2 使用它自己的 IP 地址替换数据包的源 IP 地址（SNAT）
> - node2 将数据包上的目标 IP 替换为 Pod IP
> - 数据包被路由到 node1，然后到端点
> - Pod 的回复被路由回 node2
> - Pod 的回复被发送回给客户端

用图表示：

![](https://s2.loli.net/2024/05/27/fDg2tBx5FIcGMZN.png)

#### 配置 externalTrafficPolicy: Local

> 为避免这种情况，Kubernetes 有一个特性可以保留客户端源 IP。 如果将 service.spec.externalTrafficPolicy 设置为 Local， kube-proxy 只会将代理请求代理到本地端点，而不会将流量转发到其他节点。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: whoami-service
spec:
  type: NodePort
  externalTrafficPolicy: Local
  selector:
    app: whoami
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
      nodePort: 30002
```

使用`curl whoami.example.com:30002`进行测试, 当**whoami.example.com**映射到集群多个 node 的 IP 时, 有一定比例的几率无法访问. 需要确认域名记录只含有 endpoint(pod)所在 node(节点)的 ip.

这个配置**有其代价**, 那就是失去了集群内的负载均衡能力, 客户端只有访问部署了 endpoint 的 node 才会得到响应.

![访问路径限制](https://s2.loli.net/2024/05/27/PCgiTLF28XE4RKx.png)

当客户端访问 Node 2 时, 不会有响应.

### 创建 Ingress

多数服务提供给用户时使用 **http/https**, **https://ip:port**的形式可能让用户感到陌生. 一般会使用**Ingress**将上文创建的**NodePort**服务负载到一个域名的 **80/443** 端口下.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: whoami-ingress
  namespace: default
spec:
  ingressClassName: external-lb-default
  rules:
    - host: whoami.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: whoami-service
                port:
                  number: 80
```

应用后, 使用`curl whoami.example.com`访问测试, 可以看到 ClientIP 总是 endpoint 所在节点上的`Ingress Controller`的 Pod IP.

```shell
root@client:~# curl whoami.example.com
...
RemoteAddr: 10.42.1.10:56482
...

root@worker:~# kubectl get -n ingress-nginx pod -o wide
NAME                                       READY   STATUS    RESTARTS   AGE    IP           NODE          NOMINATED NODE   READINESS GATES
ingress-nginx-controller-c8f499cfc-xdrg7   1/1     Running   0          3d2h   10.42.1.10   k3s-agent-1   <none>           <none>
```

使用**Ingress**反向代理**NodePort**服务, 也就是在 endpoint 前套了两层 service, 下图展示了二者区别.

```mermaid
graph LR
    A[Client] -->|whoami.example.com:80| B(Ingress)
    B -->|10.43.38.129:32123| C[Service]
    C -->|10.42.1.1:8080| D[Endpoint]
```

```mermaid
graph LR
    A[Client] -->|whoami.example.com:30001| B(Service)
    B -->|10.42.1.1:8080| C[Endpoint]
```

在路径 1 中, 外部访问 Ingress 时, 流量先到达的 endpoint 是`Ingress Controller`, 然后再到达 endpoint **whoami**.  
而**Ingress Controller**实质是一个**LoadBalancer**的服务,

```shell
kubectl -n ingress-nginx get svc

NAMESPACE   NAME             CLASS   HOSTS                       ADDRESS                                              PORTS   AGE
default     echoip-ingress   nginx   ip.example.com       172.16.0.57,2408:4005:3de:8500:4da1:169e:dc47:1707   80      18h
default     whoami-ingress   nginx   whoami.example.com   172.16.0.57,2408:4005:3de:8500:4da1:169e:dc47:1707   80      16h
```

因此, 可以通过将前文提到的`externalTrafficPolicy`设置到 Ingress Controller 中来保留源 IP.

同时还需要设置`ingress-nginx-controller`的`configmap`中的`use-forwarded-headers`为`true`, 以便**Ingress Controller**能够识别`X-Forwarded-For`或`X-REAL-IP`字段.

```yaml
apiVersion: v1
data:
  allow-snippet-annotations: "false"
  compute-full-forwarded-for: "true"
  use-forwarded-headers: "true"
  enable-real-ip: "true"
  forwarded-for-header: "X-Real-IP" # X-Real-IP or X-Forwarded-For
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.10.1
  name: ingress-nginx-controller
  namespace: ingress-nginx
```

**NodePort**服务与**ingress-nginx-controller**服务的区别主要在于, **NodePort**的后端通常不部署在每台 node 上, 而**ingress-nginx-controller**的后端通常部署在每台对外暴露的 node 上.

与**NodePort**服务中设置`externalTrafficPolicy`会导致跨 node 的请求无响应不同, **Ingress**可以将请求先设置 HEADER 之后再进行代理转发, 实现了**保留源 IP**和**负载均衡**的两种能力.

## 总结

- **地址转换(NAT)**, **代理(Proxy)**,**反向代理(Reverse Proxy)**, **负载均衡(Load Balance)**会导致源 IP 丢失.
- 为防止源 IP 丢失, 可以代理服务器转发时将真实 IP 设置在 HTTP 头部字段`X-REAL-IP`中, 通过代理服务传递. 如果使用多层代理, 则可以使用`X-Forwarded-For`字段, 该字段以**栈**的形式记录了源 IP 及代理路径的 **IP list**.
- 集群**NodePort**服务设置`externalTrafficPolicy: Local`可以保留源 IP, 但会失去负载均衡能力.
- **ingress-nginx-controller**以**daemonset**形式部署在所有**loadbalancer**角色 node 上的前提下, 设置`externalTrafficPolicy: Local`可以保留源 IP, 且保留负载均衡能力.

## 参考

- [Kubernetes 使用源 IP](https://kubernetes.io/zh-cn/docs/tutorials/services/source-ip/)
- [Ingress-Nginx Controller:ConfigMap](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/)
- [Ingress Controller](https://kubernetes.io/zh-cn/docs/concepts/services-networking/ingress-controllers/)
