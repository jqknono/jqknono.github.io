# k8s 管理

- `-o wide`: more info
- `-o yaml`: yaml

## 管理容器

```shell
# 在容器中执行命令
kubectl exec <$pod_name> -- env
kubectl exec -it <$pod_name> -- /bin/bash
```

## 查看信息

```shell
kubectl get nodes
kubectl describe node <$node_name>
```

## 服务管理

```shell
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --replicas=3 --port 8080
kubectl get deployments
curl http://localhost:8001/api/v1/namespaces/default/pods/${POD_NAME}/proxy/
kubectl delete kubernetes-bootcamp

# expose service
kubectl expose deployment kubernetes-bootcamp --type="NodePort" --port 8080
kubectl get services
curl http://localhost:31061

# scale
kubectl scale --replicas=4 deployment kubernetes-bootcamp
```

## 权限管理

```shell
# 创建role
kubectl create clusterrole deployer --verb=get,list,watch,create,delete,patch,update --resource=deployments.apps
kubectl create clusterrolebinding deployer-srvacct-default-binding --clusterrole=deployer --serviceaccount=default:default
kubectl create clusterrolebinding deployer-srvacct-default-binding --clusterrole=deployer --serviceaccount=system:node:k8s-worker1

# add role
set
kubectl label node {$master} node-role.kubernetes.io/deployer=deployer
kubectl label node <node1> node-role.kubernetes.io/<role name>=<key - (any name)>
kubectl label node <node1> node-role.kubernetes.io/<role name>-
```

## 仅学习研究用(WARNING)

```shell
kubectl create clusterrolebinding serviceaccounts-cluster-admin \
  --clusterrole=cluster-admin \
  --group=system:serviceaccounts
```

## tips

```shell
# auto complete kubectl, 自动补全
apt install bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
source ~/.bashrc
```

## 界面

https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

```shell
# 部署Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl create serviceaccount admin-user -n kubernetes-dashboard
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:admin-user
kubectl -n kubernetes-dashboard create token admin-user
# 第二种方法, token不过期 https://www.cnblogs.com/ll409546297/p/16739351.html
# kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep dashboard-admin | awk '{print $1}')
```

## iptables

```shell
# will reset iptables
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
```