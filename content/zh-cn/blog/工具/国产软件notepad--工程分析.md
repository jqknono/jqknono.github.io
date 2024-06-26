---
layout: blog
categories: 工具
tags: [工具, 工具]
published: false
draft: true
title: 国产软件notepad--工程分析
linkTitle: 国产软件notepad--工程分析
date: 2024-06-28 16:21:51 +0800
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

- [ ] 国产软件notepad--工程分析

# 国产软件 notepad--工程分析

分析基于[notepad--v2.0](https://gitee.com/cxasm/notepad--/commit/c1ae9ac45b8efdf560cc12a5e36e8fb5dcf45660)

由于 notepad++作者过于强烈的政治倾向, 其软件网站声明造成了许多国人的不快, 大家都在寻找其它替代品, 避免工具影响心情. 首先, 的确存在不少替代品, 没有必要全新开发, 甚至可以直接 fork 一个[notepad++](https://github.com/notepad-plus-plus/notepad-plus-plus)继续开发, 其使用的开源协议是 GNU, 只要不修改协议, 不闭源, 不商业化即可. 但是, 有人喜欢自己造轮子, 于是就有了 notepad--.

`notepad--`的出现有振奋人心的意义, 但是在查看了工程后, 我发现这个工程的工程化一言难尽, 于是我决定对其进行分析, 以便于后续的工作.

## README

进入工程第一步是看`README.md`, 其应该包含以下内容:

- 项目介绍
- 项目依赖
- 项目编译
- 项目运行
- 项目测试
- 项目部署
- 项目贡献
- 项目许可

*项目介绍*中写了一些项目对中国人的意义, 那么不通畅的英文介绍就非常画蛇添足.

工程的编译指导另开了一个文件夹, 名为*how_build*, 指导文件名为*linux 开源编译及下载说明.txt*. 里边的描述事无巨细, 没必要以这种形式指导编译, 应尽量使用脚本, 使用代码去描述. 可以创建多个脚本, 描述脚本功能即可.

根目录的*编译说明.docx*文件, 也是一份编译指导, 但是这个文件是 Word 文档, 依赖 office 软件, 这是一个隐含的依赖, 实在是没有必要让开发者依赖 office 软件. 里边的描述也充满非常业余的描述, 比如:

- _不推荐 qtcreator，其在 windows 下面不好调试，调试比较麻烦。_
- _图中标红的地方，都检查一下。因为工程 vs 打开后，随着系统不同，或编译环境不同，可能存在差异。_
- _如果编译过程遇到莫名其妙的错误，还请把文件编码修改为 uft8-bom 。_

这些措辞都充满了不确定性, 作者完全不考虑这种 word 文档被人修改后如何检视.

## 工程结构

这个工程首先是几乎没有工程结构, 所有头文件和实现都在同一目录.
仅有的看似划分目录的行为也非常不规范, 二进制文件放在了目录中随代码分发, 应属于资源的图片等文件所在的目录名也非常迷惑, src 目录下你可以看到各种各样的东西.

## 代码质量

一言难尽的注释,

> /* 这里其实是穷举字符串的字符编码；ASNI utf8。目前只检测 GBK 和 utf8;其它语种没有穷举
> *GB2312 GBK GB18030 三种差别见https://cloud.tencent.com/developer/article/1343240 > _关于编码的详细说明，见https://blog.csdn.net/libaineu2004/article/details/19245205 > _/
> //这里是有限检查 utf8 的，如果出现 gbk，说明一定不是 utf8，因为 utf8 检查到错误码。

> //如果也不是 gbk，姑且按照 utf8 直接返回

> //可以防止某些屏幕下的字体拥挤重叠问题

> //不能开启，开启后相对路径打开文件失败
> //QDir::setCurrent(QCoreApplication::applicationDirPath());

> //这里的字体大小，务必要和查找结果框的高度匹配，否则会结构字体拥挤

由于作者的思维充满了漏洞, 我不认为这个本来存在意义就很渺茫的工程还有继续阅读的价值.


## 结语

这个工程居于gitee上编辑器类的第一名, 能理解国内开发者被政治冒犯后的心情, 但工程质量之差超出了我的想象, 由于其根基过于差, 我不认为有投入此工程的必要.
我的目的不是打击大家的爱国热情, 但是这个工程的一切都价值不大, 事实上, 想表达对notepad++的不满, 你只需要[fork一个notepad++](https://github.com/notepad-plus-plus/notepad-plus-plus/fork), 免费发布在任意喜欢的网站, 这就已经足够了. 这是合法的, 也是我认为权衡后最正确的做法.
