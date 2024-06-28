---
layout: blog
title: 宝塔docker源加速
description:
published: true
categories: 运维
tags: [运维, 宝塔系列]
date: 2024-06-03 18:31:48 +0800
draft: false
toc: true
toc_hide: false
math: false
comments: false
giscus_comments: true
hide_summary: false
hide_feedback: false
---

![](https://s2.loli.net/2024/06/03/BT8s1ldrF7wyUYP.png)

宝塔 8.2 及以下版本设置 docker 源加速无效, 并且界面上手动设置配置文件内容无效.

这是由于 docker 配置文件位于`/etc/docker/daemon.json`, 该文件及其文件夹默认不存在, 直接修改文件不会保存成功.

只需要执行`mkdir /etc/docker`, 然后再在界面上修改加速配置即可生效.
