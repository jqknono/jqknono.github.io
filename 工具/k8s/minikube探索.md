# minikube 探索

- 应使用非 root 用户运行 minikube

```shell
# 自动补全
# auto complete kubectl, 自动补全
apt install bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
source ~/.bashrc

kubectl create deployment kb --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --replicas=3 --port 8080
```

## 参考

- [kubernetes-bootcamp](https://kubernetesbootcamp.github.io/kubernetes-bootcamp/index.html)
