---
layout: blog
categories: 教程
tags: [教程, k8s]
published: false
draft: true
title: 快捷输入completion
linkTitle: 快捷输入completion
date: 2024-06-28 16:06:01 +0800
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

- [ ] 快捷输入completion

# 快捷输入

```bash
# 设置自动补全
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

source /etc/bash_completion

alias k=kubectl
alias kap='kubectl get pod --all-namespaces'
alias kas='kubectl get service --all-namespaces'
alias kad='kubectl get deployment --all-namespaces'
source <(kubectl completion bash)
complete -o default -F __start_kubectl k

alias m=minikube
# alias kubectl="minikube kubectl --"
source <(minikube completion bash)
complete -o default -F __start_minikube m
```
