---
title: k8s安装配置
---

# k8s 安装配置

```shell
# 1. 安装docker
apt install docker.io
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# 2. 安装kubeadm
## 最新版本k8s
sudo mkdir -p /etc/apt/keyrings
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
apt install kubeadm
# 3. 安装kubelet
apt install kubelet
# 4. 安装kubectl
apt install kubectl
# 配置补全
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
# 5. 初始化master
kubeadm init --service-cidr=192.168.200.1/24 --pod-network-cidr=192.168.201.1/24
# 6. 加入node
kubeadm join 192.168.205.145:6443 --token {$token} --discovery-token-ca-cert-hash sha256:{$hash}
```

## tips

```shell
echo "alias k=kubectl" >> ~/.bashrc
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "complete -o default -F __start_kubectl k" >> ~/.bashrc
```

## test

```shell
# 预配置
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# 安装docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 配置docker
cat <<EOF | tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "insecure-registries": [
    "registry.qingteng.cn",
    "172.16.12.16:5000",
    "172.16.12.16:7000",
    "172.16.12.16:8000",
    "172.16.12.18:8000",
    "172.16.12.16:9000",
    "172.16.12.16:30082"
  ],
  "experimental": true,
  "registry-mirrors": [
    "https://sdwhknta.mirror.aliyuncs.com"
  ]
}
EOF
systemctl enable docker && systemctl restart docker

# container运行时
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# 设置必需的 sysctl 参数，这些参数在重新启动后仍然存在。
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# 应用 sysctl 参数而无需重新启动
sysctl --system

# 安装kubelet
apt install kubeadm kubelet kubectl kubernetes-cni

# 复原master设置
kubeadm reset

# --ignore-preflight-errors=all
# --image-repository=registry.aliyuncs.com/google_containers
# --service-cidr=10.1.0.0/16
# --kubernetes-version v1.26.0
kubeadm init --apiserver-advertise-address=10.106.121.47 --pod-network-cidr=10.244.0.0/16
kubeadm init --apiserver-advertise-address=10.106.121.47 --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16 --v=5
# 根据kubeadm init ... 最后一行的信息
# master节点生成加入集群的命令
kubeadm token create --print-join-command
# kubeadm join 192.168.205.145:6443 --node-name node1 --token noivw6.3gnbtv9zew25hzpt
        # --discovery-token-ca-cert-hash sha256:35de231851d610285903f84721677179675d4da6083772968768c49c4f6b5a54
kubeadm join 192.168.205.145:6443 --token 7qfjir.1k0b9cb4rxdpvgjl \
        --discovery-token-ca-cert-hash sha256:fb85e63016e3532f361e2a57f022758bf81d266c6e064b5f5654a90c7b709793

kubeadm join 192.168.205.145:6443 --token b7k8ui.whn9kw1c26a8ghtv --discovery-token-ca-cert-hash sha256:fb85e63016e3532f361e2a57f022758bf81d266c6e064b5f5654a90c7b709793

# 拷贝配置文件
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# containerd默认配置
containerd config default | sudo tee /etc/containerd/config.toml
# SystemdCgroup = true

# 关闭swap
sed -i '/swap/s/^/#/' /etc/fstab
echo "vm.swappiness = 0">> /etc/sysctl.conf
swapoff -a
reboot

# 关防火墙
ufw disable

systemctl restart kubelet
systemctl status kubelet
systemctl start containerd
systemctl status containerd
systemctl restart containerd

# 日志
journalctl -ru kubelet
journalctl -xeu kubelet
journalctl -fu kubelet

# 安装containerd
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install containerd.io

wget https://github.com/containerd/containerd/releases/download/v1.6.12/containerd-1.6.12-linux-amd64.tar.gz
tar xvf containerd-1.6.12-linux-amd64.tar.gz
systemctl stop containerd
cd bin
yes | cp * /usr/bin/
systemctl start containerd

# [failed to validate kubelet flags: the container runtime endpoint address was not specified or empty, use --container-runtime-endpoint to set]
# https://stackoverflow.com/questions/75131916/failed-to-validate-kubelet-flags-the-container-runtime-endpoint-address-was-not
wget https://github.com/containerd/containerd/releases/download/v1.6.12/containerd-1.6.12-linux-amd64.tar.gz
tar xvf containerd-1.6.12-linux-amd64.tar.gz
systemctl stop containerd
cd bin
cp * /usr/bin/
systemctl start containerd

# /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
# https://github.com/weaveworks/weave/issues/2789
modprobe br_netfilter

# /proc/sys/net/ipv4/ip_forward are not set to 1
sysctl -w net.ipv4.ip_forward=1

# get used ports
lsof -i -P -n
lsof -i -P -n | grep LISTEN


# [WARNING Port-10250]: Port 10250 is in use
rm -rf /root/.kube/
rm -rf /etc/kubernetes
kubeadm reset --cri-socket=/var/run/cri-dockerd.sock

# install flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# hostname
hostnamectl
hostnamectl set-hostname k8s-master
hostnamectl set-hostname k8s-worker1

# ssl error
export KUBECONFIG=/etc/kubernetes/kubelet.conf
kubectl get nodes
# or
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile
source /etc/profile

# coredns not run
kubectl describe pod coredns-5bbd96d687-6wfn6
kubectl describe -n kube-system
# https://github.com/kubernetes/kubernetes/issues/70202#issuecomment-481173403
# 解决方法手动配置flannel

# 安装成功
kubectl get pods -n kube-system
kubectl get pods --all-namespaces

kubectl get nodes
kubectl get nodes -o wide

# 修改设置后无法join
swapoff -a    # will turn off the swap
kubeadm reset
systemctl daemon-reload
systemctl restart kubelet
# will reset iptables
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
```
