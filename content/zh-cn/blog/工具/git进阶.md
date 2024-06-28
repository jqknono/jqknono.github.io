---
layout: blog
categories: 工具
tags: [工具, 工具]
published: false
draft: true
title: git进阶
linkTitle: git进阶
date: 2024-06-28 16:11:42 +0800
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

- [ ] git进阶

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [配置覆盖](#配置覆盖)
  - [基于文件夹的配置](#基于文件夹的配置)
- [命令行基础](#命令行基础)

<!-- /TOC -->

## 配置覆盖

覆盖顺序, 后来的覆盖前面的

1. system
   - C:/Program Files/Git/etc/gitconfig
2. global
   - C:/Users/Username/.gitconfig
3. local
4. 此外还有一种基于文件路径引入新配置的方法 [基于文件夹的配置](#基于文件夹的配置)

### 基于文件夹的配置

```config
[include]
    path = D:/path/to/foo.inc;
[includeIf "gitdir/i:d:/gerrit/"]
    path = D:/gerrit/work.gitconfig
```

- 注意 include 后将覆盖上文配置, 注意根据需求灵活调整
- 一般来说, include 写在文件较前位置, includeIf 写在文件较后位置

## 命令行基础

帮助:

- 全局帮助: `git --help`
- 单命令帮助: `git branch -h`
- 可用命令的帮助: `git help -a`
- git 概念导览: `git help -g`
- 显示详细介绍网页: `git help branch`
