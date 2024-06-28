---
layout: blog
categories: 教程
tags: [教程, k8s]
published: false
draft: true
title: k8s架构
linkTitle: k8s架构
date: 2024-06-28 16:05:01 +0800
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

- [ ] k8s架构

# k8s 架构

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [k8s 架构](#-k8s-架构-)
  - [Kubernetes architecture](#-kubernetes-architecture-)
    - [Kubernetes architecture: the master](#-kubernetes-architecture-the-master-)
    - [Kubernetes architecture: the nodes](#-kubernetes-architecture-the-nodes-)
    - [What are all these pods?](#-what-are-all-these-pods-)
  - [使用 service 暴露应用](#-使用-service-暴露应用-)
  - [使用 label 和 selector 识别](#-使用-label-和-selector-识别-)

<!-- /code_chunk_output -->

## Kubernetes architecture

Master 负责管理整个集群。 Master 协调集群中的所有活动，例如调度应用、维护应用的所需状态、应用扩容以及推出新的更新。

Node 是一个虚拟机或者物理机，它在 Kubernetes 集群中充当工作机器的角色 每个 Node 都有 Kubelet , 它管理 Node 而且是 Node 与 Master 通信的代理。

- The Kubernetes API defines a lot of objects called resources
- These resources are organized by type, or Kind (in the API)
- A few common resource types are:
  - **node** (a machine --- physical or virtual --- in our cluster)
  - **pod** (group of containers running together on a node)
  - **service** (stable network endpoint to connect to one or multiple containers)
  - **namespace** (more-or-less isolated group of things)
  - **secret** (bundle of sensitive data to be passed to a container)
- And much more! (We can see the full list by running kubectl get)- node (a machine --- physical or virtual --- in our cluster)

### Kubernetes architecture: the master

- The Kubernetes logic (its "brains") is a collection of services:
  - the API server (our point of entry to everything!)
  - core services like the scheduler and controller manager
  - etcd (a highly available key/value store; the "database" of Kubernetes)
- Together, these services form what is called the "master"
- These services can run straight on a host, or in containers (that's an implementation detail)
- etcd can be run on separate machines (first schema) or co-located (second schema)
- We need at least one master, but we can have more (for high availability)

### Kubernetes architecture: the nodes

- The nodes executing our containers run another collection of services:

  - a container Engine (typically Docker)
  - kubelet (the "node agent")
  - kube-proxy (a necessary but not sufficient network component)

- Nodes were formerly called "minions"

- It is customary to not run apps on the node(s) running master components (Except when using small development clusters)

你可以使用 Kubernetes 命令行界面 Kubectl 创建和管理 Deployment。Kubectl 使用 Kubernetes API 与集群进行交互。Kubectl 会将所有的命令发送到 Kubernetes API Server，然后 Kubernetes API Server 会将命令发送到 Master 节点，Master 节点会将命令发送到 Node 节点，Node 节点会执行命令。

### What are all these pods?

- `etcd` is our etcd server
- `kube-apiserver` is the API server
- `kube-controller-manager` and `kube-scheduler` are other master components
- `kube-dns` is an additional component (not mandatory but super useful, so it's there)
- `kube-proxy` is the (per-node) component managing port mappings and such
- `weave` is the (per-node) component managing the network overlay
- the `READY` column indicates the number of containers in each pod
- the pods with a name ending with `-node1` are the master components (they have been specifically "pinned" to the master node)

## 使用 service 暴露应用

Node 可以包含多个 pod，pod 可以包含多个容器，容器可以包含多个进程。Node 是 Kubernetes 集群中的工作节点，它们可以是物理机或者虚拟机。Node 上运行的容器由 Pod 管理。Pod 是 Kubernetes 中最小的部署单元，一个 Pod 可以包含一个或者多个容器。Pod 中的容器共享网络和存储空间，可以通过 localhost 相互通信。Pod 中的容器可以是同一个镜像，也可以是不同的镜像。Pod 中的容器可以在同一个 Node 上运行，也可以在不同的 Node 上运行。

Service 是 Kubernetes 中的抽象概念，它定义了一组 Pod 的访问策略。Service 可以通过 Label Selector 来定义一组 Pod。Service 可以通过 ClusterIP、NodePort、LoadBalancer 暴露给外部。

## 使用 label 和 selector 识别

