---
layout: page
title: 墙内使用k8s
published: true
categories: 运维
tags: 
  - 运维
  - k8s
date: 2023-05-04 18:58:22
---

发布此文时, k8s 经历一次大的改变, `k8s.gcr.io container image registry is being redirected to registry.k8s.io`, 墙内默认无法访问海外网络服务, 需要一些额外的工作以使用 k8s.

有以下几种方案:

- 代理, 由于 k8s 的组网较复杂, 实测非透明代理方案无法使用
- 替换镜像

## 代理

仅支持透明代理.

- 设置 proxy 会导致镜像拉取问题.
- k8s 非常依赖 netfilter, 使用代理软件有不可预知的后果.

## 替换镜像

需考虑两类镜像源, 一是 k8s 配置环境使用的镜像, 二是 k8s 学习测试使用的镜像.

### 配置环境

#### 安装

镜像源使用阿里源替换:

debian/ubuntu:
https://mirrors.aliyun.com/kubernetes/apt/

```shell
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

centos/rhel:
https://mirrors.aliyun.com/kubernetes/yum/

```shell
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl
```

#### 初始化

安装过程所需的容器镜像, 两种方式获取:

1. 替换容器镜像源
2. 手动下载

##### 替换容器镜像源

k8s 在 1.26 版本以后 推荐容器 containerd

```shell
sed -i 's/registry.k8s.io/registry.aliyuncs.com\/google_containers/g' /etc/containerd/config.toml
systemctl restart containerd
```

##### 手动下载

由于默认的镜像仓库 k8s.gcr.io 国内一般无法访问，因此我们需要先使用国内镜像源拉下来，再改镜像的 tag

1. 执行`kubeadm config images list`，查看安装所需镜像

```shell
k8s.gcr.io/kube-apiserver:v1.22.3
k8s.gcr.io/kube-controller-manager:v1.22.3
k8s.gcr.io/kube-scheduler:v1.22.3
k8s.gcr.io/kube-proxy:v1.22.3
k8s.gcr.io/pause:3.5
k8s.gcr.io/etcd:3.5.0-0
k8s.gcr.io/coredns/coredns:v1.8.4
```

2. 从阿里云镜像中心拉取镜像，并修改对应的 tag

```shell
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.22.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.22.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.22.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.22.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.5
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.0-0
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.8.4

docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.22.3 k8s.gcr.io/kube-apiserver:v1.22.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.22.3 k8s.gcr.io/kube-controller-manager:v1.22.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.22.3 k8s.gcr.io/kube-scheduler:v1.22.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.22.3 k8s.gcr.io/kube-proxy:v1.22.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.5 k8s.gcr.io/pause:3.5
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.0-0 k8s.gcr.io/etcd:3.5.0-0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.8.4 k8s.gcr.io/coredns/coredns:v1.8.4
```

### gcr.io 镜像

gcr.io/google-samples 镜像无法下载, 使用方案:

```shell
# kubectl create deployment kb --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --replicas=3
# 替换gcr.io/google-samples/ => anjia0532/google-samples.
kubectl create deployment kb --image=anjia0532/google-samples.kubernetes-bootcamp:v1 --replicas=3
```
