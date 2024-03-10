---
title: k8s介绍
---

# k8s 介绍

k8s 的出现是保障服务的技术发展历史中的一环.

1. 早期, 工程师编写单一应用程序, 提供单一服务, 部署在单一服务器上.
1. 编写多个应用程序, 应用间协同提供服务, 部署在单一服务器上.
1. 服务部署在多个服务器, 通过负载均衡提供服务.
1. 细分服务, 一个或一系列应用程序, 部署在多个服务器, 使机器资源得到充分利用.
1. 直接分发应用/服务, 每个环境单独调整
1. 由应用/服务自身检测并配置环境
1. 容器化应用/服务, 携带环境分发, docker container
1. 多个容器组成一个服务, docker compose
1. 监控服务状态, 手动重启服务, 调整服务资源
1. 自动调整服务资源--k8s

为实现自动化管理, 需要将此前的资源做新的抽象:

1. 一些列应用可以存在于一个 container 中, 多个 container 组成一个**pod**
1. 抽象部署行为, 一个**deployment**可以部署多个**pod**, 部署中定义了部署策略, 如何更新, 回滚等
1. 将部署运行起来, 成为一个**service**, 通过**service**可以访问部署的**pod**, 此时**service**可以是内部服务, 也可以是外部服务
1. 实际占用计算资源的单位是**pod**, 其载体是**node**, **node**是**pod**的运行环境, **node**可以是物理机, 也可以是虚拟机, 也可以是容器.
1. **deployment**和**service**管理的 pods 常常分属不同的**nodes**, 为访问真正做计算工作的**pod**, 需要精心设计相关的网络.

这就是 k8s 所做的工作, 这一系列抽象每层都会增加额外的性能负担, 增加资源消耗, 但是为了实现自动化管理, 这是必要的. 开发效率, 部署效率, 运维效率等, 也非常重要.

## Kubernetes concepts

- Kubernetes is a container management system
- It runs and manages containerized applications on a cluster

## Basic things we can ask Kubernetes to do

- Start 5 containers using image atseashop/api:v1.3
- Place an internal load balancer in front of these containers
- Start 10 containers using image atseashop/webfront:v1.3
- Place a public load balancer in front of these containers
- It’s Black Friday (or Christmas), traffic spikes, grow our cluster and add containers
- New release! Replace my containers with the new image atseashop/webfront:v1.4
- Keep processing requests during the upgrade; update my containers one at a time

### Other things that Kubernetes can do for us

- Basic autoscaling
- Blue/green deployment, canary deployment
- Long running services, but also batch (one-off) jobs
- Overcommit our cluster and evict low-priority jobs
- Run services with stateful data (databases etc.)
- Fine-grained access control defining what can be done by whom on which resources
- Integrating third party services (service catalog)
- Automating complex tasks (operators)
