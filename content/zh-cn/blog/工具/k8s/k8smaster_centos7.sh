set -euxo pipefail
set +x

export basearch=$(uname -m)
export releasever=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+' | cut -d. -f1)

function set_third_repo() {
    curl -s https://mirrors.aliyun.com/repo/Centos-7.repo -o /etc/yum.repos.d/CentOS-Base.repo

    # usibg tsinghua repo
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|http://mirrors.aliyun.com/centos|https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo

    cat >/etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/yum/repos/kubernetes-el7-$basearch/
gpgcheck=0
enabled=1
EOF

    yum makecache
}

function install_prequisite() {
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
}

function clear_containerd() {
    rm -rf /var/lib/containerd/*
    rm -rf /etc/containerd/*
}

function uninstall_containerd() {
    yum remove -y docker-ce docker-ce-cli
    yum remove -y containerd.io
    rm -rf /etc/containerd
}

function install_containerd() {
    yum install -y containerd.io

    systemctl stop containerd
    wget -O containerd.tar.gz https://github.com/containerd/containerd/releases/download/v$containerd_ver/containerd-$containerd_ver-linux-amd64.tar.gz
    tar xvf containerd.tar.gz
    cp bin/* /usr/local/bin/
    mkdir -p /etc/containerd
    containerd config default >/etc/containerd/config.toml
    # fuser -k /usr/local/bin/containerd-shim-runc-v2

    systemctl daemon-reload
    systemctl restart containerd

    rm -rf containerd.tar.gz bin
}

function reset_kubeadm() {
    kubeadm reset -f
    rm -rf /etc/cni/net.d/*
    rm -rf /var/lib/kubelet/*
    rm -rf /etc/kubernetes/*
    rm -rf /var/lib/kubelet
    rm -rf /var/lib/cni/
}

function reset_iptables() {
    iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
    iptables -P FORWARD ACCEPT
}

function uninstall_kubelet() {
    yum remove -y kubelet kubeadm kubectl --disableexcludes=kubernetes
}

function install_kubelet() {
    yum install -y kubelet-$k8s_version kubeadm-$k8s_version kubectl-$k8s_version --disableexcludes=kubernetes
}

function config_system() {
    # config system
    swapoff -a && sysctl -w vm.swappiness=0
    sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab
    sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

    # config module
    cat >/etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF
    modprobe overlay
    modprobe br_netfilter

    # config sysctl
    cat <<EOF | tee /etc/sysctl.d/k8s.conf
vm.swappiness=0
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.ipv4.tcp_tw_recycle = 0
EOF
    sysctl --system
    sysctl -p /etc/sysctl.d/k8s.conf

    # config containerd
    mkdir -p /etc/containerd
    containerd config default >/etc/containerd/config.toml
    # replace sandbox_image = "registry.k8s.io" with sandbox_image = "registry.aliyuncs.com/google_containers"
    # sed -i 's/registry.k8s.io/registry.qingteng.cn\/registry.k8s.io/g' /etc/containerd/config.toml
    sed -i 's/registry.k8s.io/registry.aliyuncs.com\/google_containers/g' /etc/containerd/config.toml

    # config firewall
    systemctl stop firewalld
    systemctl disable firewalld

    # config hostname random
    # hostnamectl set-hostname $(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)

    # config system
    systemctl enable containerd
    systemctl enable kubelet
    systemctl daemon-reload
    systemctl restart containerd
    systemctl restart kubelet
}

function config_completion() {
    yum install -y bash-completion
    bash -c "source /usr/share/bash-completion/bash_completion"
    bash -c "source <(kubectl completion bash)"
    bash -c "source <(kubeadm completion bash)"

    # append "source <(kubectl completion bash)" to ~/.bashrc if not exists
    grep -q "source <(kubectl completion bash)" ~/.bashrc || echo "source <(kubectl completion bash)" >>~/.bashrc
    grep -q "source <(kubeadm completion bash)" ~/.bashrc || echo "source <(kubeadm completion bash)" >>~/.bashrc

    kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null
    grep -q "complete -o default -F __start_kubectl k" ~/.bashrc || echo "complete -o default -F __start_kubectl k" >>~/.bashrc
}

function config_env() {
    grep -q "export KUBECONFIG=/etc/kubernetes/admin.conf" ~/.bashrc || echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >>~/.bashrc
    grep -q "alias k=kubectl" ~/.bashrc || echo "alias k=kubectl" >>~/.bashrc
    grep -q "alias kap='kubectl get pod --all-namespaces'" ~/.bashrc || echo "alias kap='kubectl get pod --all-namespaces'" >>~/.bashrc
    grep -q "alias kas='kubectl get service --all-namespaces'" ~/.bashrc || echo "alias kas='kubectl get service --all-namespaces'" >>~/.bashrc
    grep -q "alias kad='kubectl get deployment --all-namespaces'" ~/.bashrc || echo "alias kad='kubectl get deployment --all-namespaces'" >>~/.bashrc
}

function install_calico() {
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml
}

function install_helm() {
    curl -fsSL https://mirrors.aliyun.com/kubernetes/helm/helm-v3.6.3-linux-amd64.tar.gz -o helm.tar.gz
    tar -zxvf helm.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm
    rm -rf linux-amd64 helm.tar.gz
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
}

function install_istio() {
    curl -L https://istio.io/downloadIstio | sh -
    cd istio-1.11.2
    export PATH=$PWD/bin:$PATH
    istioctl install --set profile=demo -y
    kubectl label namespace default istio-injection=enabled
    kubectl apply -f samples/addons
    cd ..
    rm -rf istio-1.11.2
}

function install_dashboard() {
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
    kubectl apply -f dashboard-adminuser.yaml
    kubectl apply -f dashboard-rolebinding.yaml
    kubectl apply -f dashboard-ingress.yaml
}

function install_ingress() {
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0/deploy/static/provider/baremetal/deploy.yaml
    kubectl apply -f ingress-nginx.yaml
}

function main() {
    set_third_repo
    install_prequisite
    uninstall_containerd
    clear_containerd
    install_containerd
    uninstall_kubelet
    install_kubelet
    reset_kubeadm
    config_system
    config_env
    config_completion
}

# check root
if [ $(id -u) -ne 0 ]; then
    echo -e "\033[31mPlease run as root\033[0m"
    exit 1
fi

# check SELinux
if [ $(getenforce) != "Disabled" ]; then
    echo -e "\033[31m[ERROR]Please disable SELinux with 'setenforce 0' and reboot\033[0m"
    exit 1
fi

# check args length:2
if [ $# -ne 2 ]; then
    echo -e "\033[33mUsage\033[0m: \033[31m$0\033[0m \033[32m<k8s_version> [master | worker]\033[0m"
    exit 1
fi

# https://kubernetes.io/releases/
ver_list=(1.24.0 1.24.1 1.24.2 1.24.3 1.24.4 1.24.5 1.24.6 1.24.7 1.24.8 1.24.9 1.24.10 1.24.11 1.24.12 1.24.13 1.25.0 1.25.1 1.25.2 1.25.3 1.25.4 1.25.5 1.25.6 1.25.7 1.25.8 1.25.9 1.26.0 1.26.1 1.26.2 1.26.3 1.26.4 1.27.0 1.27.1 1.27.2)
# exit if version not in list
if [[ ! " ${ver_list[@]} " =~ " $1 " ]]; then
    echo -e "\033[31m[ERROR]k8s_version not in support list\033[0m"
    exit 1
fi

# exit if $2 not in list
if [[ ! " master worker " =~ " $2 " ]]; then
    echo -e "\033[31m[ERROR]node_type not in support list\033[0m"
    exit 1
fi

# https://github.com/containerd/containerd/releases/
export containerd_ver=1.6.20

# set global var
export k8s_version=$1

# if $2 == "master" then init k8s cluster
if [ $2 == "master" ]; then
    export is_master=true
else
    export is_master=false
fi

echo -e "Using containerd \033[32m$containerd_ver\033[0m"
echo -e "Using k8s \033[32m$k8s_version\033[0m"
echo -e "Is master node: \033[32m$is_master\033[0m"

main

echo -e "\033[32m Install Kubernetes initial end. \033[0m"

if [ $is_master == true ]; then
    kubeadm reset -f
    # kubeadm init --pod-network-cidr=192.168.0.0/16 --image-repository registry.qingteng.cn/registry.k8s.io
    kubeadm init --pod-network-cidr=192.168.0.0/16 --image-repository registry.aliyuncs.com/google_containers
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    echo -e "\033[32m Run \033[33mkubeadm join\033[32m command on worker node \033[0m"
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

echo -e "\033[32m DONE! \033[0m"
echo -e "\033[32mRun\033[33m kubeadm token create --print-join-command \033[32mto get join command \033[0m"
echo -e "\033[36m kubectl apply -f {file} 无法创建镜像时, 使用以下命令应用阿里云镜像 \033[0m"
echo -e "\033[32msed -i 's/registry.k8s.io/registry.aliyuncs.com\/google_containers/g' apply.toml \033[0m"
source ~/.bashrc
