set -euxo pipefail
set +x

export basearch=$(uname -m)
export releasever=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+' | cut -d. -f1)

function set_third_repo() {
    codename=$(lsb_release -c | awk '{print $2}')

    cat >/etc/apt/sources.list <<EOF
    deb https://mirrors.aliyun.com/ubuntu/ $codename main restricted universe multiverse
    deb-src https://mirrors.aliyun.com/ubuntu/ $codename main restricted universe multiverse

    deb https://mirrors.aliyun.com/ubuntu/ $codename-security main restricted universe multiverse
    deb-src https://mirrors.aliyun.com/ubuntu/ $codename-security main restricted universe multiverse

    deb https://mirrors.aliyun.com/ubuntu/ $codename-updates main restricted universe multiverse
    deb-src https://mirrors.aliyun.com/ubuntu/$codename-updates main restricted universe multiverse
    
    deb https://mirrors.aliyun.com/ubuntu/ $codename-proposed main restricted universe multiverse
    deb-src https://mirrors.aliyun.com/ubuntu/ $codename-proposed main restricted universe multiverse

    deb https://mirrors.aliyun.com/ubuntu/ $codename-backports main restricted universe multiverse
    deb-src https://mirrors.aliyun.com/ubuntu/ $codename-backports main restricted universe multiverse
EOF

    curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
    cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

    apt update -y
}

function install_prequisite() {
    apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
}

function clear_containerd() {
    rm -rf /var/lib/containerd/*
    rm -rf /etc/containerd/*
}

function uninstall_containerd() {
    apt remove -y containerd
    rm -rf /etc/containerd
}

function install_containerd() {
    apt install -y containerd
    systemctl stop containerd
    wget -O containerd.tar.gz https://github.com/containerd/containerd/releases/download/v$containerd_ver/containerd-$containerd_ver-linux-amd64.tar.gz
    tar xvf containerd.tar.gz
    cp bin/* /usr/local/bin/
    mkdir -p /etc/containerd
    containerd config default >/etc/containerd/config.toml

    systemctl daemon-reload
    systemctl restart containerd

    rm -rf containerd.tar.gz bin
}

function reset_kubeadm() {
    kubeadm reset -f
    rm -rf /etc/cni/net.d/*
    rm -rf /var/lib/kubelet/*
    rm -rf /etc/kubernetes/*
}

function reset_iptables() {
    iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
    iptables -P FORWARD ACCEPT
}

function uninstall_kubelet() {
    apt remove -y kubelet kubeadm kubectl
}

function install_kubelet() {
    apt install -y kubelet=$k8s_version-00 kubeadm=$k8s_version-00 kubectl=$k8s_version-00
}

function config_system() {
    # config system
    swapoff -a && sysctl -w vm.swappiness=0
    sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab

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
EOF
    sysctl --system
    sysctl -p /etc/sysctl.d/k8s.conf

    # config containerd
    mkdir -p /etc/containerd
    containerd config default >/etc/containerd/config.toml
    # replace sandbox_image = "registry.k8s.io" with sandbox_image = "registry.aliyuncs.com/google_containers"
    sed -i 's/registry.k8s.io/registry.aliyuncs.com\/google_containers/g' /etc/containerd/config.toml

    # config firewall
    ufw disable

    # config hostname random
    hostnamectl set-hostname $(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)

    # config system
    systemctl enable containerd
    systemctl enable kubelet
    systemctl daemon-reload
    systemctl restart containerd
    systemctl restart kubelet
}

function config_completion() {
    apt install -y bash-completion
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
    echo "Please run as root"
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
    kubeadm init --pod-network-cidr=192.168.0.0/16 --image-repository registry.aliyuncs.com/google_containers
    echo -e "\033[32m Run \033[33mkubeadm join\033[32m command on worker node \033[0m"
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

echo -e "\033[32m DONE! \033[0m"
echo -e "\033[32mRun\033[33m kubeadm token create --print-join-command \033[32mto get join command \033[0m"
echo -e "\033[36m kubectl apply -f {file} 无法创建镜像时, 使用以下命令应用阿里云镜像 \033[0m"
echo -e "\033[32msed -i 's/registry.k8s.io/registry.aliyuncs.com\/google_containers/g' apply.toml \033[0m"
source ~/.bashrc
