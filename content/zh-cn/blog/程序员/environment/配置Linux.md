---
layout: blog
categories: 工具
tags: [工具, environment]
published: false
draft: true
title: 配置Linux
linkTitle: 配置Linux
date: 2024-06-28 16:40:14 +0800
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

- [ ] 配置Linux

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
