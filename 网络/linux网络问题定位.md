# linux 网络问题定位

## 排障工具

| 工具       | 说明               | 用法                                                  | 说明 |
| ---------- | ------------------ | ----------------------------------------------------- | ---- |
| ping       | 测试网络连通性     | ping baidu.com                                        |
| traceroute | 路由跟踪           | traceroute ip                                         |
| route      | 路由表             | route -n                                              |
| netstat    | 网络连接           | netstat -ano                                          |
| nslookup   | DNS 解析           | nslookup baidu.com                                    |
| ifconfig   | 网络配置           | ifconfig                                              |
| arp        | ARP 缓存           | arp -a                                                |
| nbtstat    | NetBIOS            | nbtstat -n                                            |
| netsh      | 网络配置           | netsh                                                 |
| net        | 网络配置           | net                                                   |
| tcpdump    | 网络抓包           | tcpdump                                               |
| wireshark  | 网络抓包           | wireshark                                             |
| ip         | 网络配置           | ip addr show                                          |
| ss         | 网络连接           | ss -tunlp                                             |
| netstat    | 查看网络连接状态   | netstat -anp                                          |
| tcpdump    | 抓包工具           | tcpdump -i eth0 -nn -s 0 -c 1000 -w /tmp/tcpdump.pcap |
| iptables   | 防火墙             | iptables -L -n -v -t nat -t mangle -t filter          |
| ss         | netstat 的替代品   | ss -anp                                               |
| ifconfig   | 查看网卡信息       | ifconfig eth0                                         |
| ip         | 查看网卡信息       | ip addr show eth0                                     |
| route      | 查看路由表         | route -n                                              |
| traceroute | 查看路由跳数       | traceroute www.baidu.com                              |
| ping       | 测试网络连通性     | ping www.baidu.com                                    |
| telnet     | 测试端口连通性     | telnet www.baidu.com 80                               |
| nslookup   | 域名解析           | nslookup www.baidu.com                                |
| dig        | 域名解析           | dig www.baidu.com                                     |
| arp        | 查看 arp 缓存      | arp -a                                                |
| netcat     | 网络调试工具       | nc -l 1234                                            |
| nmap       | 端口扫描工具       | nmap -sT -p 80 www.baidu.com                          |
| mtr        | 网络连通性测试工具 | mtr www.baidu.com                                     |
| iperf      | 网络性能测试工具   | iperf -s -p 1234                                      |
| iptraf     | 网络流量监控工具   | iptraf -i eth0                                        |
| ipcalc     | IP 地址计算工具    | ipcalc                                                |
| iftop      | 网络流量监控工具   | iftop -i eth0                                         |
| iostat     | 磁盘 IO 监控工具   | iostat -x 1 10                                        |
| vmstat     | 虚拟内存监控工具   | vmstat 1 10                                           |
| sar        | 系统性能监控工具   | sar -n DEV 1 10                                       |
| lsof       | 查看文件打开情况   | lsof -i:80                                            |
| strace     | 跟踪系统调用       | strace -p 1234                                        |
| tcpflow    | 抓包工具           | tcpflow -i eth0 -c -C -p -o /tmp/tcpflow              |
| tcpick     | 抓包工具           | tcpick -i eth0 -C -p -o /tmp/tcpick                   |
| tcptrace   | 抓包工具           | tcptrace -i eth0 -C -p -o /tmp/tcptrace               |
| tcpslice   | 抓包工具           | tcpslice -i eth0 -C -p -o /tmp/tcpslice               |
| tcpstat    | 抓包工具           | tcpstat -i eth0 -C -p -o /tmp/tcpstat                 |
| tcpdump    | 抓包工具           | tcpdump -i eth0 -C -p -o /tmp/tcpdump                 |
| tshark     | 抓包工具           | tshark -i eth0 -C -p -o /tmp/tshark                   |
| wireshark  | 抓包工具           | wireshark -i eth0 -C -p -o /tmp/wireshark             |
| socat      | 网络调试工具       | socat -d -d TCP-LISTEN:1234,fork TCP:www.baidu.com:80 |
| ncat       | 网络调试工具       | ncat -l 1234 -c 'ncat www.baidu.com 80'               |
| netperf    | 网络性能测试工具   | netperf -H www.baidu.com -l 60 -t TCP_STREAM          |
| netcat     | 网络调试工具       | netcat -l 1234                                        |
| nc         | 网络调试工具       | nc -l 1234                                            |
| netpipe    | 网络性能测试工具   | netpipe -l 1234                                       |
| netkit     | 网络调试工具       | netkit -l 1234                                        |
| bridge     | 网桥工具           | bridge -s                                             |
