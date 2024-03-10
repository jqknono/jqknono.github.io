---
title: Win-to-go
---

# Windows To Go
===

Windows To Go 的优点在于移动便携性, 缺点在于经典 Windows系统的数个功能受到限制.

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [前言](#前言)
* [Windows To Go Overview](#windows-to-go-overview)
* [Windows To Go 和传统 Windows 安装方式的区别](#windows-to-go-和传统-windows-安装方式的区别)
* [使用 Windows To Go 来移动工作](#使用-windows-to-go-来移动工作)
* [准备安装 Windows To Go](#准备安装-windows-to-go)
* [硬件要求](#硬件要求)
* [USB 硬盘或 U盘](#usb-硬盘或-u盘)
* [载体机器(Host computer)](#载体机器host-computer)
* [检查载体 PC 和 Windows To Go 盘的架构兼容性](#检查载体-pc-和-windows-to-go-盘的架构兼容性)
* [Windows To Go 的常见问题](#windows-to-go-的常见问题)

<!-- /code_chunk_output -->

## 前言

Windows To Go出现很多年了, 可是百度到的中文文档却如此少, 不禁为国内IT技术的发展而担忧.作者J参加工作时间不长, 能力有限, 但工作中接触大量英文开发文档, 因此仍希望能做一点基础的铺路工作, 方便后来者查阅, 有不当之处也请读者不吝指出. Windows To Go有详尽的官方文档, 有英文阅读能力的可以直接跳转到微软官方文档. 链接如下:

* [Windows To Go Overview](https://docs.microsoft.com/zh-cn/windows/deployment/planning/windows-to-go-overview)
* [Best practice recommendations for Windows To Go](https://docs.microsoft.com/zh-cn/windows/deployment/planning/best-practice-recommendations-for-windows-to-go)
* [Deployment considerations for Windows To Go](https://docs.microsoft.com/zh-cn/windows/deployment/planning/deployment-considerations-for-windows-to-go)
* [Prepare your organization for Windows To Go](https://docs.microsoft.com/zh-cn/windows/deployment/planning/prepare-your-organization-for-windows-to-go)
* [Security and data protection considerations for Windows To Go](https://docs.microsoft.com/zh-cn/windows/deployment/planning/security-and-data-protection-considerations-for-windows-to-go)
* [Windows To Go: frequently asked questions](https://docs.microsoft.com/zh-cn/windows/deployment/planning/windows-to-go-frequently-asked-questions)

本文主要会介绍 Overview, 和一些常见问题, 大部分内容为翻译, 少量作者的提醒以[J]来标注直至句号结束, 以确保不误导读者.

<!--more-->

## Windows To Go Overview

Windows To Go 是 Windows 企业版和教育版上的功能, 大多数家庭用户使用的家庭版没有此功能. 它使我们能创建从U盘或硬盘启动的便携Windows系统. Windows To Go 并不是创造出来取代传统工作工具的. 它的主要目的是为了使具有经常切换工作空间需求的人更有效率. 在开始使用 Windows To Go 之前, 使用者必须了解以下注意事项:

* Windows To Go 和传统 Windows 安装方式的区别;
* 使用 Windows To Go 来移动工作;
* 准备安装 Windows To Go;
* 硬件要求.

## Windows To Go 和传统 Windows 安装方式的区别

Windows To Go 的工作环境和传统 Windows 几乎一样, 只有以下几点不同:

* 除了使用中的U盘, 机器的其它硬盘默认为离线状态. 即在文件管理器里不可见, 这是为了保护数据的安全. [J]但你仍然有方法可以使其它硬盘出现, 并修改里边的文件.
* TPM 信任平台模块不可用. TPM 模块会绑定到特定某台电脑, 以保护商业数据. [J]多数民用电脑没有TPM模块, 但如果你的商用电脑已经加入了公司的域, 最好不要尝试在该电脑上使用 Windows To Go, 否则建议您先准备好下份工作的简历.
* Windows To Go的休眠默认被禁用, 但仍可以通过组策略来打开. [J]很多机器在休眠会断开和USB设备的连接, 导致不能从休眠中恢复, 这很好理解, 微软已经替我们考虑到了这点, 所以没必要去修改这个设置.
* Windows 的恢复(Restore)功能被禁用. 如果系统出现问题, 只能重装Windows了.
* 恢复到出厂设置不可用, 重置Windows不可用.
* 升级不可用. Windows 只能停留在安装时的版本, 不能从Windows 7 升到8, 也不能从 Windows 10 Red Stone 1 升级到 Red Stone 2.

## 使用 Windows To Go 来移动工作

Windows To Go 可以在多台机器之间切换, 系统会自动决定设备启动需要的驱动程序. 有一些和系统硬件强关联的应用可能无法运行. [J]比如Thinkpad触控板的设置程序, 指纹识别设置程序等.

## 准备安装 Windows To Go

可以使用 **System Center Configuration Manager**, 或者 Windows 的标准部署工具, 例如 **DiskPart**, **Deployment Image Servicing and Management (DISM)**. 需要注意以下问题:

* 是否有需要注入到 Windows To Go 镜像的驱动?
* 在不同机器上移动工作时时, 怎样合适的存储及同步数据?
* 32位还是64位? [J]新的机器都支持64位, 64位处理器的机器也能运行32位系统, 32位处理器不能运行64位的系统, 64位系统运行时占用更大的硬盘空间和内存空间. 如果你需要迁移使用的机器处理器架构有只支持32位的处理器, 或者机器内存少于4G, 建议你使用32位系统.
* 从协作网络以外的网络远程连接时的分辨率应该设为多少?

## 硬件要求

### USB 硬盘或 U盘

Windows To Go针对以下列出的设备已做出了特别优化来满足需求, 包括

* 优化USB设备的高随机读写, 以使日常操作更流畅.
* 在已认证的设备上可以启动Windows 7及后续系统.
* 即使运行Windows To Go, USB设备也享受原厂保修支持. [J]没说插U盘的电脑会享受保修.

没有通过认证的 USB 设备, 不支持使用 Windows To Go. [J]能不能使用试试就知道了, 不行也知道是为什么. [J]同时网上有修改 U 盘厂商和型号来达到强制支持的另类方法, 不做赘述.

### 载体机器(Host computer)

* 认证支持Windows 7及后续系统.
* 运行Windows RT系统的电脑不受支持.
* 苹果Mac电脑不受支持. [J]尽管网络上遍布谈Windows To Go在Mac上运行的体验, 但官方文档明确说了, 不支持Mac的使用场景.

以下列出载体电脑的最低配置.

|Item|Requirement|
|-----|-----|
|启动方式|可以USB启动|
|固件|从USB启动的设置打开|
|处理器架构|必须支持Windows To Go|
|外置USB Hub|不支持. Windows To Go 设备必须直接接在载体电脑上|
|处理器|1GHz以上|
|RAM|2 GB以上|
|显卡|有WDDM1.2的DirectX 9及以上|
|USB端口| USB 2.0及以上|

### 检查载体 PC 和 Windows To Go 盘的架构兼容性

|Host PC Firmware Type|Host PC Processor Architecture|Compatible Windows To Go Image Architecture|
|---|---|---|
|Legacy BIOS|32-bit|32-bit only|
|Legacy BIOS|64-bit|32-bit and 64-bit|
|UEFI BIOS|32-bit|32-bit only|
|UEFI BIOS|64-bit|64-bit only|

## Windows To Go 的常见问题

[Windows To Go: frequently asked questions](https://docs.microsoft.com/zh-cn/windows/deployment/planning/windows-to-go-frequently-asked-questions)