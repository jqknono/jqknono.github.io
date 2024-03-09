# DDoS 防范

[DDoS 定义]https://en.wikipedia.org/wiki/Denial-of-service_attack

两种 DoS 攻击方式:

- 使服务崩溃
- 使网络拥塞

## 攻击类型

| 攻击类型                                                 | 攻击方式                                                                                                                                                                                                         | 应对方式                              |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| Distributed DoS                                          | 多台独立 IP 的机器同时开始攻击                                                                                                                                                                                   | 1. 降级服务 2. 黑名单 3. 关闭网络设备 |
| Yo-yo attack 悠悠球攻击                                  | 对有自动扩展资源能力的服务, 在资源减少的间隙进行攻击                                                                                                                                                             | 黑名单                                |
| Application layer attacks 应用层攻击                     | 针对特定的功能或特性进行攻击，[LAND](https://en.wikipedia.org/wiki/LAND) 攻击属于这种类型                                                                                                                        | 黑名单                                |
| LANS                                                     | 这种攻击方式采用了特别构造的 TCP SYN 数据包（通常用于开启一个新的连接），使目标机器开启一个源地址与目标地址均为自身 IP 地址的空连接，持续地自我应答，消耗系统资源直至崩溃。这种攻击方法与 SYN 洪泛攻击并不相同。 | 黑名单                                |
| Advanced persistent DoS 高级持续性 DoS                   | 反侦察/目标明确/逃避反制/长时间攻击/大算力/多线程攻击                                                                                                                                                            | 降级服务                              |
| HTTP slow POST DoS attack 慢 post 攻击                   | 创造合法连接后以极慢的速度发送大量数据, 导致服务器资源耗尽                                                                                                                                                       | 降级服务                              |
| Challenge Collapsar (CC) attack 挑战 Collapsar (CC) 攻击 | 将标准合法请求频繁发送，该请求会占用较多资源，比如搜索引擎会占用大量的内存                                                                                                                                       | 降级服务，内容识别                    |
| ICMP flood Internet 控制消息协议 (ICMP) 洪水             | 大量 ping/错误 ping 包 /Ping of death(malformed ping packet)                                                                                                                                                     | 降级服务                              |
| 永久拒绝服务攻击 Permanent denial-of-service attacks     | 对硬件进行攻击                                                                                                                                                                                                   | 内容识别                              |
| 反射攻击 Reflected attack                                | 向第三方发送请求，通过伪造地址，将回复引导至真正受害者                                                                                                                                                           | ddos 范畴                             |
| Amplification 放大                                       | 利用一些服务作为反射器，将流量放大                                                                                                                                                                               | ddos 范畴                             |
| Mirai botnet 僵尸网络                                    | 利用被控制的物联网设备                                                                                                                                                                                           | ddos 范畴                             |
| SACK Panic 麻袋恐慌                                      | 操作最大段大小和选择性确认，导致重传                                                                                                                                                                             | 内容识别                              |
| Shrew attack 泼妇攻击                                    | 利用 TCP 重传超时机制的弱点，使用短暂的同步流量突发中断同一链路上的 TCP 连接                                                                                                                                     | 超时丢弃                              |
| 慢读攻击 Slow Read attack                                | 和慢 post 类似，发送合法请求，但读取非常慢， 以耗尽连接池，通过为 TCP Receive Window 大小通告一个非常小的数字来实现                                                                                              | 超时断连，降级服务，黑名单            |
| SYN flood SYN 洪水                                       | 发送大量 TCP/SYN 数据包， 导致服务器产生半开连接                                                                                                                                                                 | 超时机制                              |
| 泪珠攻击 Teardrop attacks                                | 向目标机器发送带有重叠、超大有效负载的损坏 IP 片段                                                                                                                                                               | 内容识别                              |
| TTL 过期攻击                                             | 当由于 TTL 过期而丢弃数据包时，路由器 CPU 必须生成并发送 ICMP 超时响应。生成许多 ​​ 这样的响应会使路由器的 CPU 过载                                                                                              | 丢弃流量                              |
| UPnP 攻击                                                | 基于 DNS 放大技术，但攻击机制是一个 UPnP 路由器，它将请求从一个外部源转发到另一个源，而忽略 UPnP 行为规则                                                                                                        | 降级服务                              |
| SSDP 反射攻击                                            | 许多设备，包括一些住宅路由器，都在 UPnP 软件中存在漏洞，攻击者可以利用该漏洞从端口号 1900 获取对他们选择的目标地址的回复。                                                                                       | 降级服务， 封禁端口                   |
| ARP 欺骗                                                 | 将 MAC 地址与另一台计算机或网关（如路由器）的 IP 地址相关联，导致原本用于原始真实 IP 的流量重新路由到攻击者，导致拒绝服务。                                                                                      | ddos 范畴                             |

## 防范措施

1. 识别攻击流量
   - 破坏服务
     - 识别流量内容
   - 拥塞服务
     - 记录访问时间
2. 对攻击流量进行处理
   - 丢弃攻击流量
   - 封禁攻击 ip
     - ipv4 ip 数量有限, 容易构造黑名单
     - ipv6 数量较多, 不容易构造黑名单. 可以使用 ipv6 的地址段, 但有错封禁的风险
   - 控制访问频率

## 开源工具

### 攻击工具

- ~~https://github.com/palahsu/DDoS-Ripper~~
  - 162 forks, 755 stars
- https://github.com/MHProDev/MHDDoS
  - 539 forks, 2.2k stars
  - MHDDoS - DDoS Attack Script With 40 Methods
- https://github.com/NewEraCracker/LOIC
  - 539 forks, 1.9k stars
  - C#
  - network stress tool
- https://github.com/PraneethKarnena/DDoS-Scripts
  - 165 forks, 192 stars
  - C, Python
- https://github.com/theodorecooper/awesome-ddos-tools
  - 46 stars
  - collection of ddos tools

### 防御工具

- https://github.com/AltraMayor/gatekeeper
  - GPL-3.0 License
  - 159 forks, 737 stars
  - C, Lua
  - Gatekeeper is the first open source DoS protection system.
- ~~https://github.com/Exa-Networks/exabgp~~
  - Apache like license
  - 415 forks, 1.8k stars
  - Python
  - The BGP swiss army knife of networking
- https://github.com/curiefense/curiefense
  - Apache 2.0 License
  - 60 forks, 386 stars
  - Application-layer protection
  - protects sites, services, and APIs
- https://github.com/qssec/Hades-lite
  - GPL-3.0 License
  - 24 forks, 72 stars
  - C
  - 内核级 Anti-ddos 的驱动程序
- https://github.com/snort3/snort3
  - GPL-2.0 License
  - 372 forks, 1.4k stars
  - next generation Snort IPS (Intrusion Prevention System)
  - C++

### 流量监控

- https://github.com/netdata/netdata
  - GPL-3.0 License
  - 5.2k forks, 58.3k stars
  - C
- https://github.com/giampaolo/psutil
  - BSD-3-Clause License
  - 1.2 forks, 8.2k stars
  - Python, C
  - Cross-platform lib for process and system monitoring in Python, also network monitoring
- https://github.com/iptraf-ng/iptraf-ng
  - GPL-2.0 License
  - 22 forks, 119 stars
  - C
  - IPTraf-ng is a console-based network monitoring program for Linux that displays information about IP traffic.