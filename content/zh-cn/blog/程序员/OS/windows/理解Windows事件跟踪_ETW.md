---
layout: blog
categories: 系统
tags: [系统, windows]
published: true
draft: false
title: 理解Windows事件跟踪_ETW
linkTitle: 理解Windows事件跟踪_ETW
date: 2024-06-28 17:12:21 +0800
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

- [ ] 理解Windows事件跟踪_ETW

# 理解 ETW

筛除了一些不必要的信息, 完整文档参阅: <https://docs.microsoft.com/en-us/windows/win32/etw/event-tracing-portal>

## 理解基础

https://learn.microsoft.com/en-us/windows/win32/etw/about-event-tracing

![架构](https://learn.microsoft.com/en-us/windows/win32/etw/images/etdiag2.png)

## Session

存在四种 session

| session 种类                                                                                                                                 | 使用                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 限制                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 特点                     |
| -------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| [Event Tracing Session](https://learn.microsoft.com/en-us/windows/win32/etw/configuring-and-starting-an-event-tracing-session)(Standard ETW) | 1. [EVENT_TRACE_PROPERTIES](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/ns-evntrace-event_trace_properties)2. [StartTrace](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-starttracea), 创建 session3. EnableTrace 1. [EnableTrace](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-enabletrace) for classic provider 2. [EnableTraceEx](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-enabletraceex) for manifest-based provider4. [ControlTrace](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-controltracea)  停止 session | - 一个 manifest-based provider 仅支持提供事件到至多 8 个 session- 一个 classic provider, 仅能服务一个 session.- session 抢占 provider 行为是后来居上.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | 标准 ETW.                |
| [SystemTraceProvider Session](https://learn.microsoft.com/en-us/windows/win32/etw/configuring-and-starting-a-systemtraceprovider-session)    | 1. [EVENT_TRACE_PROPERTIES](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/ns-evntrace-event_trace_properties)->**EnableFlags**2. [StartTrace](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-starttracea)3. [ControlTrace](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-controltracea)  停止 session                                                                                                                                                                                                                                                                               | - **SystemTraceProvider **是一个内核事件 provider, 提供一套[预定义的内核事件](https://learn.microsoft.com/en-us/windows/win32/etw/nt-kernel-logger-constants).- **[NT Kernel Logger session](https://learn.microsoft.com/en-us/windows/win32/etw/configuring-and-starting-the-nt-kernel-logger-session)**是系统预置 session, 记录一系列系统预定义的内核事件- **Win7/WinServer2008R2**仅 NT Kernel Logger session 可使用 SystemTraceProvider - **Win8/WinServer2012**的 SystemTraceProvider 可以提供事件给**8 个 logger session**, 其中两个固定为 NT Kernel Logger 和 Circular Kernel Context Logger.- **Win10 20348**之后, 各 Systerm provider 可以被单独控制. | 获取系统内核预定义事件.  |
| [AutoLogger session](https://learn.microsoft.com/en-us/windows/win32/etw/configuring-and-starting-an-autologger-session)                     | 1. 修改注册表 2. [EnableTraceEx](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-enabletraceex)3. [ControlTrace](https://learn.microsoft.com/en-us/windows/win32/api/evntrace/nf-evntrace-controltracea)  停止 session                                                                                                                                                                                                                                                                                                                                                                                                         | - **[Global Logger Session](https://learn.microsoft.com/en-us/windows/win32/etw/configuring-and-starting-the-global-logger-session)**是特殊独立的 session, 记录系统启动时事件.- 普通 AutoLogger 需要自行使能 provider, GlobleLogger 不需要.- AutoLogger 不支持 NT Kernel Logger 事件, 仅 GlobalLogger 支持.- 影响启动时间, 节制使用                                                                                                                                                                                                                                                                                                                            | 记录操作系统启动期间事件 |
| [Private Logger Session](https://learn.microsoft.com/en-us/windows/win32/etw/configuring-and-starting-a-private-logger-session)              | -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | - User-mode ETW- 仅进程内使用- 不计入 64 session 并行限制.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 进程私有                 |

## 工具

- [logman](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/logman)
- [wevtutil](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wevtutil)
  - xpath 查询实例: `wevtutil qe Security /c:2 /q:"*[System[EventID=5157]]" /f:text`
- [tracelog](https://learn.microsoft.com/zh-cn/windows-hardware/drivers/devtest/tracelog)
  - 使用 viusal studio 的`tracelog`工具, 可以在运行时动态的添加和删除 ETW Provider, 以及动态的添加和删除 ETW Session
- [mc](https://learn.microsoft.com/en-us/windows/win32/wes/message-compiler--mc-exe-)
- [etw-providers-docs](https://github.com/repnz/etw-providers-docs)
