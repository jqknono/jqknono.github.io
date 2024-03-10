---
title: minikube探索
---

# minikube 探索

- 应使用非 root 用户运行 minikube

## Start

```bash
minikube start -p minikube --nodes 3 --cni calico --kubernetes-version v1.26.3 --driver=docker --vm --addons ingress-dns --addons ingress --addons metrics-server --addons dashboard
```

## 前期准备

```shell
# 自动补全
# auto complete kubectl, 自动补全
apt install bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'alias m=minikube' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
source ~/.bashrc
```

## default pods

```shell
kubectl create deployment kb --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --replicas=3
kubectl expose deployment kb --type="NodePort" --port=8080

kubectl create deployment es --image=kicbase/echo-server:1.0 --replicas=3
kubectl expose deployment es --type="NodePort" --port=8080

minikube service kb --url
minikube service es --url
```

## dashbaord

```shell
minikube addons enable metrics-server
minikube addons enable dashboard
# or
minikube dashboard

kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'
# or
kubectl proxy --address='0.0.0.0' --disable-filter=true
```

如果需要从外部访问 dashboard, 则需要运行 `kubectl proxy --address='0.0.0.0' --disable-filter=true`

## 参考

- [kubernetes-bootcamp](https://kubernetesbootcamp.github.io/kubernetes-bootcamp/index.html)
