---
layout: blog
title: 自建K8S集群使用阿里云分布存储
linkTitle: 自建K8S集群使用阿里云分布存储
published: true
categories: 集群
tags: [集群, Kubenetes集群系列]
date: 2024-06-14 12:53:46 +0800
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

## 引言

本文写作于 2024.06.14, 介绍如何在阿里云的自建集群中使用阿里云分布存储, 最后附上文档连接, 其中阿里云的官方文档是中文, 但阿里云存储插件安装在 github 上, 目前只有英文文档, 建议有条件的读者尽量阅读原文.

## 存储插件安装

1. 创建自定义权限策略: https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver/blob/master/docs/ram-policies/disk.json
1. 创建 RAM 角色, 授予自定义权限策略, 暂存`accesskey` 和 `secret`
   1. `kubectl create secret -n kube-system generic csi-access-key --from-literal=id='{id}' --from-literal=secret='{secret}'`
1. 安装 CSI 驱动, 没有 helm chart, 只能本地安装(20240613).
   1. `git clone https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver.git`
   1. `cd alibaba-cloud-csi-driver/deploy`
   1. 如果是安装在阿里云的 ecs 上的自建集群, 可直接执行下一句, **如果不是, 请自行阅读**: https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver/blob/master/docs/install.md
   1. `helm upgrade --install alibaba-cloud-csi-driver ./chart --values chart/values-ecs.yaml --namespace kube-system`
1. 确认, `watch kubectl get pods -n kube-system -l app=csi-plugin`

## 存储类型选型参考

- ECS 云盘创建的最小容量是 20GB, IOPS 3000, 这个容量是比较大的, 并不太划算.
  - 云盘动态存储卷
    - 官方文档:
      - 云盘不支持跨可用区使用，为非共享存储，且只能同时被一个 Pod 挂载。(实测可以被同一个 deployment 的多个 pod 挂载)
      - 云盘类型和 ECS 类型需要匹配才可以挂载，否则会挂载失败。关于云盘类型和 ECS 类型的匹配关系，请参见[实例规格族](https://help.aliyun.com/zh/ecs/user-guide/overview-of-instance-families#concept-sx4-lxv-tdb)。
      - 在应用部署时，通过 StorageClass 自动创建 PV 购买云盘。如果您已经购买云盘，推荐使用云盘静态存储卷。
      - 申请云盘的大小，不能超出云盘的单盘容量范围。
      - 当 Pod 重建时，会重新挂载原云盘。若由于其他限制无法调度到原可用区，则 Pod 将会处于 Pending 状态。
      - 动态创建的云盘为按量付费的云盘
    - 其它测试总结:
      - 虽然云盘可以被多 pod 挂载, 但只有一个 pod 可以读写, 其他 pod 不能读写. 因此 pvc 中`accessModes`只能设置为`ReadWriteOnce`, 修改不会得到正确结果.
      - 如果 StorageClass 的`reclaimPolicy`设置为`Delete`，则删除 PVC 时，云盘也可以被自动删除。
      - 如果 StorageClass 的`reclaimPolicy`设置为`Retain`，则删除 PVC 时，云盘不会被自动删除，需要手动在集群和阿里云控制台删除。
    - 难以找到合适使用场景.
  - 云盘静态存储卷
    - 官方文档:
      - 手动创建 PV 及 PVC
      - 云盘不支持跨可用区使用，为非共享存储，且只能同时被一个 Pod 挂载。
      - 云盘类型和 ECS 类型需要匹配才可以挂载，否则会挂载失败。
      - 可以选择与集群属于相同地域和可用区下处于待挂载状态的云盘。
- NAS 操作延时较大, 表现最好 2ms, 深度存储 10ms, 按量计费, 读写性能相对于对象存储 OSS 高
- OSS 存储卷, https://help.aliyun.com/zh/ack/ack-managed-and-ack-dedicated/user-guide/oss-volume-overview-1?spm=a2c4g.11186623.0.0.43166a351NbtvU
  - OSS 为共享存储，可以同时为多个 Pod 提供共享存储服务。
  - (20240613)目前支持 CentOS、Alibaba Cloud Linux、ContainerOS 和龙蜥操作系统。
  - 使用数据卷时，每个应用使用独立的 PV 名称。
  - OSS 数据卷是使用 ossfs 文件进行挂载的 FUSE 文件系统。
    - 适合于读文件场景。例如，读配置文件、视频、图片文件等场景。
    - 不适用于写文件的应用场景。如需写入文件，建议您使用 SDK 实现写操作或者使用 NAS 存储卷服务。
  - ossfs 可以通过调整配置参数的方式，优化其在缓存、权限等方面的表现
  - ossfs 使用限制
    - 随机或者追加写文件操作将导致所有文件重写。
    - 因为需要远程访问 OSS 服务器，list directory 等元数据操作的性能较差。
    - 文件、文件夹的 rename 操作不是原子的。
    - 多个客户端挂载同一个 OSS Bucket 时，依赖用户自行协调各个客户端的行为，例如，避免多个客户端写入同一个文件等。
    - 不支持硬链接（Hard Link）。
    - CSI plugin 为 v1.20.7 以下的版本时，仅检测本地修改，而不能检测其他客户端或工具的外部修改。
    - 为避免系统的负载升高，请勿在高并发读写的场景中使用。
- 如果是混合集群(部分节点不属于阿里云), 则只能使用 NAS 和 OSS 静态卷.
- 云盘, nas 和 oss 都有其区域限制.

总结, 云盘以硬盘整体的形式申请和挂载, 不便共享. OSS 操作颗粒度到文件, 高并发读写存在性能问题, 并且支持系统有限.

- 云盘适合数据库等需要大量空间及高性能的场景
- 其它性能要求不高的都可以选择 NAS
- OSS 不适合阿里云集群的高并发写场景, 可以应用于并发读的场景.

阿里云的官方文档存在位置不统一和相互矛盾的问题, 读者需要根据文档的日期自行判断, 有的声明不支持的特性随着版本的更新可能已经支持了, 需要自行做一些尝试.

## 操作步骤

这是阿里云官方指导文档, 按照上文指导安装好阿里云存储插件后, 可以按照[使用 NAS 静态存储卷](https://help.aliyun.com/zh/ack/ack-managed-and-ack-dedicated/user-guide/mount-statically-provisioned-nas-volumes?spm=a2c4g.11186623.0.0.125672b9VnrKw6), 进行部署测试.

**注意**: k3s 用户会遇到 local-path-storage 的问题, 报错信息可能有,

> - failed to provision volume with StorageClass "local-path": claim.Spec.Selector is not supported
> - Waiting for a volume to be created either by the external provisioner 'localplugin.csi.alibabacloud.com' or manually by the system administrator. If volume creation is delayed, please verify that the provisioner is running and correctly registered.

需要将**persistentVolumeClaim**的**storageClassName**设置为空, 避免使用 k3s 默认的 local-path-storage.

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-nas
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
  selector:
    matchLabels:
      alicloud-pvname: pv-nas
  storageClassName: ""
```

## 参考

- https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver
- https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver/blob/master/docs/disk.md
- https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver/blob/master/docs/install.md
- https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver/blob/master/docs/ram-policies/disk.json
- https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver/blob/master/deploy/chart/values.yaml
- https://help.aliyun.com/zh/ack/ack-managed-and-ack-dedicated/user-guide/use-dynamically-provisioned-disk-volumes?#6d16e8a415nie
- https://help.aliyun.com/zh/ack/ack-managed-and-ack-dedicated/user-guide/mount-statically-provisioned-nas-volumes?spm=a2c4g.11186623.0.0.125672b9VnrKw6
