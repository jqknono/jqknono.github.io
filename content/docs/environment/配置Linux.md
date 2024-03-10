---
title: 配置Linux
---

# Linux

## ubuntu

```shell
# enable root
sudo passwd root

# allow root login
sudo nano /etc/ssh/sshd_config
# PermitRootLogin yes
# PasswordAuthentication yes
sudo service ssh restart

# add public key
mkdir ~/.ssh
nano ~/.ssh/authorized_keys
```

### network

```bash
# config the network as auto connect
ip addr show
nmtui
```

## 工具配置

让 linux 更好用

```shell
# bash-completion: ash-completion is a collection of command line
# command completions for the Bash shell,
# collection of helper functions to assist in creating new completions,
# and set of facilities for loading completions automatically on demand, as well as installing them.
apt install bash-completion
echo "source /etc/bash_completion" >> ~/.bashrc
## docker auto completion
curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh
```
