---
layout: blog
categories: 网络
tags: [网络, 网络]
published: true
draft: true
title: windows网络问题定位
linkTitle: windows网络问题定位
date: 2024-06-28 17:19:41 +0800
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

- [ ] windows网络问题定位

# windows 网络问题定位

<!-- todo: 未完待续 -->

## 排障工具

| 工具名称 | 作用           | 示例               | 备注 |
| -------- | -------------- | ------------------ | ---- |
| ping     | 测试网络连通性 | ping baidu.com     |      |
| tracert  | 路由跟踪       | tracert baidu.com  |      |
| route    | 路由表         | route print        |      |
| netstat  | 网络连接       | netstat -ano       |      |
| nslookup | DNS 解析       | nslookup baidu.com |      |
| ipconfig | 网络配置       | ipconfig /all      |      |
| arp      | ARP 缓存       | arp -a             |      |
| nbtstat  | NetBIOS        | nbtstat -n         |      |
| netsh    | 网络配置       | netsh              |      |
| net      | 网络配置       | net                |      |

## ping

```ps1
PS E:\code\jqknono.github.io> ping
Usage: ping [-t] [-a] [-n count] [-l size] [-f] [-i TTL] [-v TOS]
            [-r count] [-s count] [[-j host-list] | [-k host-list]]
            [-w timeout] [-R] [-S srcaddr] [-c compartment] [-p]
            [-4] [-6] target_name

Options:
    -t             Ping the specified host until stopped.
                   To see statistics and continue - type Control-Break;
                   To stop - type Control-C.
    -a             Resolve addresses to hostnames.
    -n count       Number of echo requests to send.
    -l size        Send buffer size.
    -f             Set Dont Fragment flag in packet (IPv4-only).
    -i TTL         Time To Live.
    -v TOS         Type Of Service (IPv4-only. This setting has been deprecated
                   and has no effect on the type of service field in the IP
                   Header).
    -r count       Record route for count hops (IPv4-only).
    -s count       Timestamp for count hops (IPv4-only).
    -j host-list   Loose source route along host-list (IPv4-only).
    -k host-list   Strict source route along host-list (IPv4-only).
    -w timeout     Timeout in milliseconds to wait for each reply.
    -R             Use routing header to test reverse route also (IPv6-only).
                   Per RFC 5095 the use of this routing header has been
                   deprecated. Some systems may drop echo requests if
                   this header is used.
    -S srcaddr     Source address to use.
    -c compartment Routing compartment identifier.
    -p             Ping a Hyper-V Network Virtualization provider address.
    -4             Force using IPv4.
    -6             Force using IPv6.
```

## tracert

```ps1
PS E:\code\jqknono.github.io> tracert

Usage: tracert [-d] [-h maximum_hops] [-j host-list] [-w timeout]
               [-R] [-S srcaddr] [-4] [-6] target_name

Options:
    -d                 Do not resolve addresses to hostnames.
    -h maximum_hops    Maximum number of hops to search for target.
    -j host-list       Loose source route along host-list (IPv4-only).
    -w timeout         Wait timeout milliseconds for each reply.
    -R                 Trace round-trip path (IPv6-only).
    -S srcaddr         Source address to use (IPv6-only).
    -4                 Force using IPv4.
    -6                 Force using IPv6.
```

### ETW(Widnows 事件追踪器)

```ps1
# Filtering Platform Packet Drop, event id 5152
auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable
# Filtering Platform Connection, event id 5157
auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable

logman stop "qt_5157" -ets
logman stop "NT Kernel Logger" -ets
logman query providers
logman query -ets
logman start "WFPSession" -p Microsoft-Windows-WFP -o WFP.etl -ets
logman stop "WFPSession" -ets
wevtutil gp Microsoft-Windows-Security-Auditing
wevtutil gli security
wevtutil qe Security /q:"*[System/EventID=5152]" /c:5 /rd:true /f:text
```

事件筛选器:

```xml
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and (EventID=5155 or EventID=5157 or EventID=5159 or EventID=5152)] and EventData[Data[@Name='DestPort']='1900']]</Select>
  </Query>
</QueryList>
```

### netsh

```bat
rem 查看网络连接
netsh interface show interface
rem 查看端口占用
netstat -ano
rem 显示过滤器
netsh wfp show filter
rem 显示过滤器状态
netsh wfp show state
```

### net

```ps1
PS E:\code\jqknono.github.io> net
The syntax of this command is:

NET
    [ ACCOUNTS | COMPUTER | CONFIG | CONTINUE | FILE | GROUP | HELP |
      HELPMSG | LOCALGROUP | PAUSE | SESSION | SHARE | START |
      STATISTICS | STOP | TIME | USE | USER | VIEW ]
```
