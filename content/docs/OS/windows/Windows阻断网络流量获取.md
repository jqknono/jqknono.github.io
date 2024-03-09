# Windows 阻断网络流量获取

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Windows 阻断网络流量获取](#-windows-阻断网络流量获取-)
  - [搭建测试工程](#-搭建测试工程-)
  - [通过审计获取 block 事件](#-通过审计获取-block-事件-)
    - [获取 provider 信息](#-获取-provider-信息-)
    - [构造 block 事件](#-构造-block-事件-)
  - [监控网络事件(NET_EVENT)](#-监控网络事件net_event-)
  - [监控网络链接(NetConnection)](#-监控网络链接netconnection-)
  - [Application Layer Enforcement(ALE)介绍](#-application-layer-enforcementale介绍-)
  - [编码](#-编码-)
  - [结论](#-结论-)
  - [附录](#-附录-)
    - [WFP 体系结构](#-wfp-体系结构-)
    - [数据流](#-数据流-)
    - [参考链接](#-参考链接-)

<!-- /code_chunk_output -->

- 需要识别出被阻断的流量, 被阻断的流量包括出站入站方向.
- 阻断的两种形式, 基于链接(connection), 和基于数据包(packet). 数据包的丢弃较为频繁常见, 需要审查丢弃原因, 基于链接的阻断更符合实际需关注的阻断场景.
- 许多正常处理的报文也会被 drop, 因此需要区分 drop 和 block 行为, 我们主要关注 block 的情况.

## 搭建测试工程

WFP 主要工作在 usermode, 另一部分在 kernalmode, 能力以驱动形式体现, 搭建测试环境的方法比较复杂. 推荐的方法是测试机使用另一台物理机, 开发机编译好后, 发送至测试机远程调试.
受条件限制, 我们也可以直接在本地进行调试.

- [Microsoft WFP Sample 工程](https://github.com/microsoft/Windows-driver-samples)
  - 只关注: Windows-driver-samples\network\trans\WFPSampler
- [WFPSampler 工程指导](https://docs.microsoft.com/zh-cn/samples/microsoft/windows-driver-samples/windows-filtering-platform-sample/)

编译问题:

- [缺失 api-ms-win-net-isolation-l1-1-0](https://github.com/microsoft/Windows-driver-samples/pull/538)
- [wfpcalloutsclassreg-not-found](https://stackoverflow.com/questions/44837612/wfpsampler-compilation-issue-wfpcalloutsclassreg-not-found)

其它问题:

- [驱动程序无法运行](https://answers.microsoft.com/en-us/protect/forum/all/your-organization-used-windows-defender/ef12b7be-41f5-4b71-a73c-e4f99ba944f7)
- [如何签名](https://stackoverflow.com/questions/84847/how-do-i-create-a-self-signed-certificate-for-code-signing-on-windows)
- [准备部署的测试机](https://docs.microsoft.com/zh-cn/windows-hardware/drivers/develop/preparing-a-computer-for-manual-driver-deployment)

## 通过审计获取 block 事件

- [Auditing 文档](https://docs.microsoft.com/en-us/windows/win32/fwp/auditing-and-logging)
- [auditpol 文档](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/auditpol)

默认情况下，禁用对 WFP 的审核。

- 可以通过组策略对象编辑器 MMC 管理单元、本地安全策略 MMC 管理单元或 auditpol.exe 命令，按类别(category)启用审核。
- 可以通过 auditpol.exe 命令按子类别(subcategory)启用审核。
- 应该使用 guid 进行设置, 否则不同语言系统有本地化的问题.
- 审计使用循环日志, 128KB 不用担心资源消耗

类别<https://docs.microsoft.com/en-us/windows/win32/secauthz/auditing-constants>

| Category/Subcategory | GUID                                   |
| -------------------- | -------------------------------------- |
| ...                  | ...                                    |
| **Object Access**    | {6997984A-797A-11D9-BED3-505054503030} |
| **Policy Change**    | {6997984D-797A-11D9-BED3-505054503030} |
| ...                  | ...                                    |

**Object Access** 子类和对应 GUID <https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-gpac/77878370-0712-47cd-997d-b07053429f6d>

| Object Access Subcategory          | Subcategory GUID                       | Inclusion Setting |
| ---------------------------------- | -------------------------------------- | ----------------- |
| ...                                | ...                                    | ...               |
| **Filtering Platform Packet Drop** | {0CCE9225-69AE-11D9-BED3-505054503030} | No Auditing       |
| **Filtering Platform Connection**  | {0CCE9226-69AE-11D9-BED3-505054503030} | No Auditing       |
| **Other Object Access Events**     | {0CCE9227-69AE-11D9-BED3-505054503030} | No Auditing       |
| ...                                | ...                                    | ...               |

**Policy Change** 子类和对应 GUID:

| Policy Change Subcategory            | Subcategory GUID                       |
| ------------------------------------ | -------------------------------------- |
| **Audit Policy Change**              | {0CCE922F-69AE-11D9-BED3-505054503030} |
| Authentication Policy Change         | {0CCE9230-69AE-11D9-BED3-505054503030} |
| Authorization Policy Change          | {0CCE9231-69AE-11D9-BED3-505054503030} |
| MPSSVC Rule-Level Policy Change      | {0CCE9232-69AE-11D9-BED3-505054503030} |
| **Filtering Platform Policy Change** | {0CCE9233-69AE-11D9-BED3-505054503030} |
| Other Policy Change Events           | {0CCE9234-69AE-11D9-BED3-505054503030} |

```ps1
# auditpol手册参阅: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/auditpol
# 本段主要关注 'Object Access' 类别
# 获取可查询的字段
# -v 显示GUID, -r显示csv报告
auditpol /list /category /v
auditpol /list /subcategory:* /v
# 获取某个子类别的审计设置
auditpol /get /category:'Object Access' /r | ConvertFrom-Csv| Get-Member
# 查询guid
auditpol /get /category:'Object Access' /r | ConvertFrom-Csv| Format-Table Subcategory,'Subcategory GUID','Inclusion Setting'
# 查找subcategory
auditpol /list /subcategory:"Object Access","Policy Change" -v
# 备份
auditpol /backup /file:d:\audit.bak
# 还原
auditpol /restore /file:d:\audit.bak
# 修改Policy
# **Policy Change**    | {6997984D-797A-11D9-BED3-505054503030}
auditpol /set /category:"{6997984D-797A-11D9-BED3-505054503030}" /success:disable /failure:disable
# Filtering Platform Policy Change | {0CCE9233-69AE-11D9-BED3-505054503030}
auditpol /set /subcategory:"{0CCE9233-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

# **Object Access**    | {6997984A-797A-11D9-BED3-505054503030}
auditpol /get /category:"{6997984A-797A-11D9-BED3-505054503030}"
auditpol /set /category:"{6997984A-797A-11D9-BED3-505054503030}" /success:disable /failure:disable
# Filtering Platform Packet Drop | {0CCE9225-69AE-11D9-BED3-505054503030}
auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable
# Filtering Platform Connection  | {0CCE9226-69AE-11D9-BED3-505054503030}
auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable
```

```ps1
# 读取日志
$Events = Get-WinEvent -LogName 'Security'
foreach ($event in $Events) {
    ForEach ($line in $($event.Message -split "`r`n")) {
        Write-host $event.RecordId ':' $Line
        break
    }
}
```

事件说明:

| Event ID    | Explanation                                                                                                                 |
| ----------- | --------------------------------------------------------------------------------------------------------------------------- |
| 5031(F)     | The Windows Firewall Service **blocked** an application from accepting incoming connections on the network.                 |
| 5150(-)     | The Windows Filtering Platform **blocked** a **packet**.                                                                    |
| 5151(-)     | A more restrictive Windows Filtering Platform filter has **blocked** a **packet**.                                          |
| 5152(F)     | The Windows Filtering Platform **blocked** a **packet**.                                                                    |
| 5153(S)     | A more restrictive Windows Filtering Platform filter has **blocked** a **packet**.                                          |
| 5154(S)     | The Windows Filtering Platform has permitted an application or service to listen on a port for incoming connections.        |
| 5155(F)     | The Windows Filtering Platform has **blocked** an application or service from listening on a port for incoming connections. |
| 5156(S)     | The Windows Filtering Platform has permitted a connection.                                                                  |
| **5157(F)** | The Windows Filtering Platform has **blocked** a connection.                                                                |
| 5158(S)     | The Windows Filtering Platform has permitted a bind to a local port.                                                        |
| 5159(F)     | The Windows Filtering Platform has **blocked** a bind to a local port.                                                      |

关注的事件详细说明:

- [Audit Filtering Platform Packet Drop](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/audit-filtering-platform-packet-drop)
  - 这类事件产生量非常大，建议关注**5157**事件, 它记录了几乎相同的信息, 但是 5157 基于链接记录而不是基于数据包.
  - Failure events volume typically is very high for this subcategory and typically used for troubleshooting. If you need to monitor blocked connections, it is better to use “5157(F): The Windows Filtering Platform has blocked a connection,” because it contains almost the same information and generates per-connection, not per-packet.
    ![建议5157](https://s2.loli.net/2023/05/06/gaoLAnlNu1QT3zf.png)  


  - ~~[5152](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5152)~~
  - ~~[5153](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5153)~~
- [Audit Filtering Platform Connection](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/audit-filtering-platform-connection)
  - 建议只关注失败事件, 如被阻止的连接, 按需关注允许的链接.
  - [5031](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5031)
    - If you don’t have any firewall rules (Allow or Deny) in Windows Firewall for specific applications, you will get this event from Windows Filtering Platform layer, because by default this layer is denying any incoming connections.
  - ~~[5150](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5150)~~
  - ~~[5151](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5151)~~
  - [5155](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5155)
  - [5157](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5157)
  - [5159](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5159)

### 获取 provider 信息

```ps1
# 获取security相关的provider信息
Get-WinEvent -ListProvider "*Security*"  | Select-Object providername,id
# Microsoft-Windows-Security-Auditing                             54849625-5478-4994-a5ba-3e3b0328c30d
# 获取provider提供的task信息
Get-WinEvent -ListProvider "Microsoft-Windows-Security-Auditing"  | Select-Object -ExpandProperty tasks
# SE_ADT_OBJECTACCESS_FIREWALLCONNECTION       12810 Filtering Platform Connection          00000000-0000-0000-0000-000000000000
```

| ProviderName                                                    | Id                                   |
| --------------------------------------------------------------- | ------------------------------------ |
| Security Account Manager                                        | 00000000-0000-0000-0000-000000000000 |
| Security                                                        | 00000000-0000-0000-0000-000000000000 |
| SecurityCenter                                                  | 00000000-0000-0000-0000-000000000000 |
| Microsoft-Windows-Security-SPP-UX-GenuineCenter-Logging         | fb829150-cd7d-44c3-af5b-711a3c31cedc |
| Microsoft-Windows-Security-Mitigations                          | fae10392-f0af-4ac0-b8ff-9f4d920c3cdf |
| Microsoft-Windows-VerifyHardwareSecurity                        | f3f53c76-b06d-4f15-b412-61164a0d2b73 |
| Microsoft-Windows-SecurityMitigationsBroker                     | ea8cd8a5-78ff-4418-b292-aadc6a7181df |
| Microsoft-Windows-Security-Adminless                            | ea216962-877b-5b73-f7c5-8aef5375959e |
| Microsoft-Windows-Security-Vault                                | e6c92fb8-89d7-4d1f-be46-d56e59804783 |
| Microsoft-Windows-Security-Netlogon                             | e5ba83f6-07d0-46b1-8bc7-7e669a1d31dc |
| Microsoft-Windows-Security-SPP                                  | e23b33b0-c8c9-472c-a5f9-f2bdfea0f156 |
| Microsoft-Windows-Windows Firewall With Advanced Security       | d1bc9aff-2abf-4d71-9146-ecb2a986eb85 |
| Microsoft-Windows-Security-SPP-UX-Notifications                 | c4efc9bb-2570-4821-8923-1bad317d2d4b |
| Microsoft-Windows-Security-SPP-UX-GC                            | bbbdd6a3-f35e-449b-a471-4d830c8eda1f |
| Microsoft-Windows-Security-Kerberos                             | 98e6cfcb-ee0a-41e0-a57b-622d4e1b30b1 |
| Microsoft-Windows-Security-ExchangeActiveSyncProvisioning       | 9249d0d0-f034-402f-a29b-92fa8853d9f3 |
| Microsoft-Windows-NetworkSecurity                               | 7b702970-90bc-4584-8b20-c0799086ee5a |
| Microsoft-Windows-Security-SPP-UX                               | 6bdadc96-673e-468c-9f5b-f382f95b2832 |
| Microsoft-Windows-Security-Auditing                             | 54849625-5478-4994-a5ba-3e3b0328c30d |
| Microsoft-Windows-Security-LessPrivilegedAppContainer           | 45eec9e5-4a1b-5446-7ad8-a4ab1313c437 |
| Microsoft-Windows-Security-UserConsentVerifier                  | 40783728-8921-45d0-b231-919037b4b4fd |
| Microsoft-Windows-Security-IdentityListener                     | 3c6c422b-019b-4f48-b67b-f79a3fa8b4ed |
| Microsoft-Windows-Security-EnterpriseData-FileRevocationManager | 2cd58181-0bb6-463e-828a-056ff837f966 |
| Microsoft-Windows-Security-Audit-Configuration-Client           | 08466062-aed4-4834-8b04-cddb414504e5 |
| Microsoft-Windows-Security-IdentityStore                        | 00b7e1df-b469-4c69-9c41-53a6576e3dad |

### 构造 block 事件

**必须非常注意，在构造 block 事件时， 会影响本地其它软件的运行！**
可及时使用`.\WFPSampler.exe -clean`来清理过滤器.

操作步骤:

1. 打开 Filtering Platform Connection 的审计开关, `auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable`
1. 打开 Event Viewer, 构造一个 Custom View, 创建过滤器, 我们暂只关注 5155, 5157, 5159 三个事件.
   ![filter example](https://s2.loli.net/2023/05/06/TjfMkws8pu4NZRW.png)  


1. 构造一个过滤器, 我们使用**WFPSampler.exe**来构造过滤器, 阻止监听本地的**80**端口, `.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_AUTH_LISTEN_V4 -iplp 80`
1. 使用一个第三方(非 IIS)的 http server, 这里使用的 nginx, 默认监听 80 端口, 双击启动启动则触发 5155 事件
   ![触发审计事件示例](https://s2.loli.net/2023/05/06/V6vlyFZ4bQa5G9Y.png)  


1. 还原过滤器, `.\WFPSampler.exe -clean`
1. 还原审计开关, `auditpol /set /category:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable`

```ps1
# 5155 blocked an application or service from listening on a port for incoming connections
.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_AUTH_LISTEN_V4
# 5157 blocked a connection
.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_AUTH_RECV_ACCEPT_V4
.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_AUTH_CONNECT_V4
# 5159, blocked a bind to a local port
.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_RESOURCE_ASSIGNMENT_V4

# Other
.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_RESOURCE_ASSIGNMENT_V4_DISCARD
.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_AUTH_RECV_ACCEPT_V4_DISCARD
.\WFPSampler.exe -s BASIC_ACTION_BLOCK -l FWPM_LAYER_ALE_AUTH_CONNECT_V4_DISCARD

# To find a specific Windows Filtering Platform filter by ID, run the following command:
netsh wfp show filters
# To find a specific Windows Filtering Platform layer ID, you need to execute the following command:
netsh wfp show state
```

## 监控网络事件(NET_EVENT)

- 网络事件支持枚举查找, 支持订阅.
- 枚举方式支持定制过滤条件, 获取一段时间内的网络事件.
- 订阅方式可以注入一个 callback 函数, 实时反馈.

支持的事件种类:

```c
typedef enum FWPM_NET_EVENT_TYPE_ {
  FWPM_NET_EVENT_TYPE_IKEEXT_MM_FAILURE = 0,
  FWPM_NET_EVENT_TYPE_IKEEXT_QM_FAILURE,
  FWPM_NET_EVENT_TYPE_IKEEXT_EM_FAILURE,
  FWPM_NET_EVENT_TYPE_CLASSIFY_DROP,
  FWPM_NET_EVENT_TYPE_IPSEC_KERNEL_DROP,
  FWPM_NET_EVENT_TYPE_IPSEC_DOSP_DROP,
  FWPM_NET_EVENT_TYPE_CLASSIFY_ALLOW,
  FWPM_NET_EVENT_TYPE_CAPABILITY_DROP,
  FWPM_NET_EVENT_TYPE_CAPABILITY_ALLOW,
  FWPM_NET_EVENT_TYPE_CLASSIFY_DROP_MAC,
  FWPM_NET_EVENT_TYPE_LPM_PACKET_ARRIVAL,
  FWPM_NET_EVENT_TYPE_MAX
} FWPM_NET_EVENT_TYPE;
```

支持的过滤条件(FWPM_NET_EVENT_ENUM_TEMPLATE):

| Value                            | Meaning                                                                |
| -------------------------------- | ---------------------------------------------------------------------- |
| FWPM_CONDITION_IP_PROTOCOL       | The IP protocol number, as specified in RFC 1700.                      |
| FWPM_CONDITION_IP_LOCAL_ADDRESS  | The local IP address.                                                  |
| FWPM_CONDITION_IP_REMOTE_ADDRESS | The remote IP address.                                                 |
| FWPM_CONDITION_IP_LOCAL_PORT     | The local transport protocol port number. For ICMP, the message type.  |
| FWPM_CONDITION_IP_REMOTE_PORT    | The remote transport protocol port number. For ICMP, the message code. |
| FWPM_CONDITION_SCOPE_ID          | The interface IPv6 scope identifier. Reserved for internal use.        |
| FWPM_CONDITION_ALE_APP_ID        | The full path of the application.                                      |
| FWPM_CONDITION_ALE_USER_ID       | The identification of the local user.                                  |

非 driver 调用的方式只能获得普通的 drop 事件.

## 监控网络链接(NetConnection)

相较监控网络事件, 监控链接需要更高权限.
[callback 方式](https://docs.microsoft.com/en-us/windows/win32/api/fwpmu/nf-fwpmu-fwpmconnectionsubscribe0)

> The caller needs FWPM_ACTRL_ENUM access to the connection objects' containers and FWPM_ACTRL_READ access to the connection objects. See Access Control for more information.

**暂未能成功监控网络链接.**

查到同样问题, [Receiving in/out traffic stats using WFP user-mode API](https://stackoverflow.com/questions/63038046/receiving-in-out-traffic-stats-using-wfp-user-mode-api), 和我调研中遇到的现象一样, 订阅函数收不到任何上报, 得不到任何事件, 没有报错. 开审计, 提权都没有成功. 有人提示非内核模式只能得到 drop 事件的上报, 这不能满足获取阻断事件的需求.

添加 security descriptor 示例: <https://docs.microsoft.com/en-us/windows/win32/fwp/reserving-ports>

## Application Layer Enforcement(ALE)介绍

- ALE 包含一系列在内核模式下的过滤器, 支持状态过滤.
- ALE 层的过滤器可授权链接的创建, 端口分配, 套接字管理, 原始套接字创建, 和混杂模式接收.
- ALE 层过滤器的分类基于链接(connection), 或基于套接字(socket), 其它层的过滤器只能基于数据包(packet)进行分类.
- ALE 过滤器参考 [ale-layers](https://docs.microsoft.com/en-us/windows/win32/fwp/ale-layers)
  - 更多过滤器参考 [filtering-layer-identifiers](https://docs.microsoft.com/en-us/windows/win32/fwp/management-filtering-layer-identifiers-)

## 编码

大多数 WFP 函数都可以从用户模式或内核模式调用。 但是，用户模式函数返回表示 Win32 错误代码的 DWORD 值，而内核模式函数返回表示 NT 状态代码的 NTSTATUS 值。 因此，函数名称和语义在用户模式和内核模式之间是相同的，但函数签名则不同。 这需要函数原型的单独用户模式和内核模式特定标头。 用户模式头文件名以"u"结尾，内核模式头文件名以"k"结尾。

## 结论

需求仅需要知道事件发生, 不需要即时处理事件, 另外开发驱动会带来更大的风险, 因此决定使用事件审计, 监控日志生成事件的方式来获得阻断事件.  
新开一个线程来使用[NotifyChangeEventLog](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-notifychangeeventlog)来监控日志记录事件.

## 附录

### WFP 体系结构

WFP(Windows Filter Platform) ![Windows 筛选平台的基本体系结构](https://docs.microsoft.com/en-us/windows/win32/fwp/images/wfp-architecture.png)

### 数据流

Data flow:

1. A packet comes into the network stack.
1. The network stack finds and calls a shim.
1. The shim invokes the classification process at a particular layer.
1. During classification, filters are matched and the resultant action is taken. (See Filter Arbitration.)
1. If any callout filters are matched during the classification process, the corresponding callouts are invoked.
1. The shim acts on the final filtering decision (for example, drop the packet).

### 参考链接

- [过滤器种类](https://docs.microsoft.com/en-us/windows/win32/fwp/management-filtering-layer-identifiers-)
- [过滤器的附加条件](https://docs.microsoft.com/en-us/windows/win32/fwp/filtering-conditions-available-at-each-filtering-layer)
- [error code](https://docs.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-)
- [WFP error code](https://docs.microsoft.com/en-us/windows/win32/fwp/wfp-error-codes)
