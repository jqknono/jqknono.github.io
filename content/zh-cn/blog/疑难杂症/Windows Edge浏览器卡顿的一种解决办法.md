---
layout: blog
title: Windows Edge浏览器卡顿的一种解决办法
published: true
categories: 疑难杂症
tags: [疑难杂症, blog]
date: 2024-05-07 11:48:37 +0800
draft: false
toc: false
comments: false
---

## 浏览器版本

`122.0.2365.80+`

## 卡顿现象

- 打开个人 profile 时卡顿
- 打开和搜索存储密码时卡顿
- 新建和关闭 tab 时卡顿
- 在新建的 tab 中输入字符时卡顿

目前发现仅中文版 Windows 系统会出现此类型的卡顿.

## 解决办法

中文浏览器设置路径: `隐私-搜索-服务 -> 地址栏和搜索 -> 搜索建议和筛选器 -> 搜索筛选器`, **关闭**搜索筛选器.

英文浏览器设置路径: `Privacy search and services -> Address bar and search -> Search sugesstion and filters -> Search filters`, **TURN OFF** Search filters.

![设置指导](https://s2.loli.net/2024/05/07/yhBqcLiaFAkdp3G.png)
