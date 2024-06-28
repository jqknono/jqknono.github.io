---
layout: blog
title: 利用Fiddler抓包https
published: false
categories: 安全
tags: [安全]
date: 2024-05-05 11:20:52 +0800
draft: true
toc: false
comments: false
---

## 电脑端

打开 Fiddler，Tools -> Options，

- 配置 HTTPS
  - 勾选 Decrypt HTTPS traffic
  - 勾选 Ignore server certificate errors
- 配置 Connections
  - 勾选 Allow remote computers to connect
- 重启 Fiddler

## 手机端

- 设置手机代理, `192.168.xx.xx:8888`
- 安装证书
  - 打开手机浏览器，访问 `http://192.168.xx.xx:8888`
  - 下载证书
  - 安装到 CA 证书
