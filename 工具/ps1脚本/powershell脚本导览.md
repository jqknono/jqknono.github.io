---
layout: page
title: powershell脚本导览
published:  true
date: 2023-04-24 10:29:39
categories:  运维工具
tags:  运维工具, ps1脚本
---

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [为什么使用powershell](#为什么使用powershell)

<!-- /TOC -->

## 为什么使用powershell

首先明确powershell包含两种形式, Windows Powershell 以及 Powershell Core, 两者的区别在于前者是基于.Net Framework, 后者是基于.Net Core, 前者只能运行在Windows上, 后者支持跨平台, 所以建议选择使用后者 [Powershell Core](https://github.com/PowerShell/PowerShell).

bash脚本很流行, 但通常仅限于Linux, 它依赖操作系统本身提供的众多工具, 我不会推荐在powershell和bash中二选一, 最好同时掌握这两种脚本语言, 它们适合不太相同的运维环境.

**Powershell适合工作在Windows上更长时间, 熟悉C#的开发和运维人员.**

以下Powershell皆表示Powershell Core.

