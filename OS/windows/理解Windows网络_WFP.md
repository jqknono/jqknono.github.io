# 理解 Windows 网络

- [ ] 理解 Windows 网络

## WFP

### 名词解释

https://learn.microsoft.com/en-us/windows/win32/fwp/object-model
https://learn.microsoft.com/en-us/windows/win32/fwp/basic-operation
https://learn.microsoft.com/en-us/windows-hardware/drivers/network

[callout](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/callout): A callout provides functionality that extends the capabilities of the Windows Filtering Platform. A callout consists of a set of callout functions and a GUID key that uniquely identifies the callout.
[callout driver](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/callout-driver): A callout driver is a driver that registers callouts with the Windows Filtering Platform. A callout driver is a type of filter driver.
[callout function](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/callout-function): A callout function is a function that is called by the Windows Filtering Platform to perform a specific task. A callout function is associated with a callout.
[filter](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/filter): A filter is a set of functions that are called by the Windows Filtering Platform to perform filtering operations. A filter consists of a set of filter functions and a GUID key that uniquely identifies the filter.
[filter engine](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/filter-engine): The filter engine is the component of the Windows Filtering Platform that performs filtering operations. The filter engine is responsible for calling the filter functions that are registered with the Windows Filtering Platform.
[filter layer](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/filter-layer): A filter layer is a set of functions that are called by the Windows Filtering Platform to perform filtering operations. A filter layer consists of a set of filter layer functions and a GUID key that uniquely identifies the filter layer.

Dispatcher队列触发回调是尽快触发形式, 不需要等队列满, 因此可以满足实时性.
当用户回调较慢时, 阻塞的报文会尽可能插入下个队列, 队列上限256. 更多的阻塞报文则由系统缓存, 粗略的测试缓存能力是16500, 系统缓存能力可能随机器性能和配置不同存在差异.
用户回调处理报文时, 存在两份报文实体:
内核报文, 在回调处理完队列后一并释放. 因此回调较慢时, 一次回调执行会最多锁定系统256个报文的缓存能力.
回调中的拷贝, 处理完单个报文后立即释放.

在FwppNetEvent1Callback中对报文进行拷贝组装, 不会操作原始报文, 对业务没有影响.

订阅可以使用模板过滤器, 以减少需要处理的报文:

https://learn.microsoft.com/en-us/windows/win32/api/fwpmtypes/ns-fwpmtypes-fwpm_net_event_enum_template0

filterCondition

An array of FWPM_FILTER_CONDITION0 structures that contain distinct filter conditions (duplicated filter conditions will generate an error). All conditions must be true for the action to be performed. In other words, the conditions are AND'ed together. If no conditions are specified, the action is always performed.

不可使用相同的filter
所有过滤器间的关系是"与", 需要全都满足
微软文档显示支持的过滤器有八种, 实际上支持的过滤器会更多.

FWPM_CONDITION_IP_PROTOCOL

The IP protocol number, as specified in RFC 1700.
FWPM_CONDITION_IP_LOCAL_ADDRESS

The local IP address.
FWPM_CONDITION_IP_REMOTE_ADDRESS

The remote IP address.
FWPM_CONDITION_IP_LOCAL_PORT

The local transport protocol port number. For ICMP, the message type.
FWPM_CONDITION_IP_REMOTE_PORT

The remote transport protocol port number. For ICMP, the message code.
FWPM_CONDITION_SCOPE_ID

The interface IPv6 scope identifier. Reserved for internal use.
FWPM_CONDITION_ALE_APP_ID

The full path of the application.
FWPM_CONDITION_ALE_USER_ID

The identification of the local user.
枚举系统已注册的订阅发现已有两个订阅, 查看其sessionKey GUID无法确认由谁注册, 对其进行分析发现两个订阅各自实现了以下功能:

订阅了所有FWPM_NET_EVENT_TYPE_CLASSIFY_DROP的数据包, 统计了所有被丢弃的包.
订阅了所有FWPM_NET_EVENT_TYPE_CLASSIFY_ALLOW的数据包, 可以用来做流量统计
这两个订阅用到的contition filter都是FWPM_CONDITION_NET_EVENT_TYPE(206e9996-490e-40cf-b831-b38641eb6fcb), 说明可以实现过滤的filter不止微软文档中提到的8个.

更多调研发现用户态调用接口仅能捕获drop的事件, 非drop事件需要使用内核模式获取, 因此微隔离不能使用FWPM_CONDITION_NET_EVENT_TYPE获取事件.