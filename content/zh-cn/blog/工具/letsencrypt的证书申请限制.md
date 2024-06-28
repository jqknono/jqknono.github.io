---
layout: blog
categories: 工具
tags: [工具, 工具]
published: false
draft: true
title: letsencrypt的证书申请限制
linkTitle: letsencrypt的证书申请限制
date: 2024-06-28 16:12:01 +0800
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

- [ ] letsencrypt的证书申请限制

## 简洁总结

- 每个注册域名每周最多 50 个证书
- 每个账户每三小时最多 300 次请求
- 每份证书最多 100 个域名
- 每周最多 5 张重复证书
- **续期证书不受限制**
- 每个 IP 每三小时最多创建 10 个账户
- 每个 IPv6/48 每三小时最多创建 500 个账户

如果你需要给很多个子域名申请证书, 可以结合`每个注册域名每周最多 50 个证书`和`每份证书最多 100 个域名`, 实现每周最多 5000 个子域名的证书申请.

## 参考

[速率限制](https://letsencrypt.org/zh-cn/docs/rate-limits/)
