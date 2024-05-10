---
title: wireguard对抗运营商
---

# wireguard 对抗运营商

wireguard 是一个配置极其简单, 速度很快的 VPN 工具. 但是由于其基于 UDP 通信, 在运营商处会有一些限制, 本文介绍几种解决方案.

运营商对 UDP 封锁/限速(UDP QoS)无非通过五元组, 其中 IP 我们不可改变, 因而只能从协议和端口入手.

`WireGuard over TCP`方案需要服务端和客户端配合都使用 TCP, 其原理很简单, 就是在客户端和服务端各自本地增加 UDP 转 TCP 的中间件, 通过 TCP 转发 UDP 包, 从而绕过运营商的限制.
这种方案简单易理解, 但是会带来配置上的繁琐, 以及性能上的损失. 因此本文只简单介绍此方案, 主要介绍的是**端口规避**的方案.

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [基础](#基础)
  - [Install Server](#install-server)
  - [Install Client](#install-client)
- [WireGuard over TCP](#wireguard-over-tcp)
- [WireGuard 监听多端口](#wireguard-监听多端口)

<!-- /TOC -->

## 基础

### Install Server

使用脚本按指示安装: https://github.com/angristan/wireguard-install

```bash
curl -O https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
chmod +x wireguard-install.sh
./wireguard-install.sh
```

### Install Client

#### Linux

```bash
sudo apt install wireguard openresolv
sudo install -o root -g root -m 600 <username>.conf /etc/wireguard/wg0.conf

# Start the WireGuard VPN:
sudo systemctl start wg-quick@wg0

# Check that it started properly:
sudo systemctl status wg-quick@wg0

# Verify the connection to the AlgoVPN:
sudo wg

# Optionally configure the connection to come up at boot time:
sudo systemctl enable wg-quick@wg0
```

#### Windows

下载地址: https://download.wireguard.com/windows-client/wireguard-installer.exe

手动点击安装, wireguard 的安全程序做的事情很少, 我们自行配置防火墙:

```ps1
New-NetFirewallRule -DisplayName "@wg0" -Direction Inbound  -RemoteAddress 10.66.66.1/24 -Action Allow
New-NetFirewallRule -DisplayName "@wg0" -Direction Outbound -RemoteAddress 10.66.66.1/24 -Action Allow
```

## WireGuard over TCP

参考: https://gist.github.com/insdavm/90cbeffe76ba4a51251d83af604adf94

```bash
sudo apt install udptunnel
udptunnel -s 8080 127.0.0.1/52630
```

## WireGuard Server 监听多端口

实际上 wireguard 服务只能监听一个端口, 但是我们可以通过 iptables NAT 转发, 将多个端口转发到一个端口上, 实现监听多端口的效果.

对运营商来说, 我们的 UDP 报文的目的端口已改变, 但对于 wireguard 服务来说, 它收到的 UDP 报文的目的端口是正确的, 因此可以正常解析.

```bash
# 监听多端口
iptables -t nat -I PREROUTING -i eth0 -p udp -m multiport --dports 51001:52000  -j REDIRECT --to-ports 51000
# remove
iptables -t nat -D PREROUTING -i eth0 -p udp -m multiport --dports 51001:52000  -j REDIRECT --to-ports 51000
```

## WireGuard Client 定时更换端口

Linux & Windows 通用, 使用 powershell 脚本实现.

```ps1
$rangeStart = 51000
$rangeEnd = 52000

$wg_path = ''
if ($IsWindows) {
    $wg_path = 'C:\Program Files\WireGuard\wg.exe'
}
else {
    $wg_path = '/usr/bin/wg'
}

# get wg.exe location
$wg_exe = Get-ChildItem -Path $wg_path -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

# exit if wg.exe not found
if ($null -eq $wg_exe) {
    Write-Host 'wg.exe not found, exiting...' -ForegroundColor Red
    exit
}

# get interface name
$interface_name = & $wg_exe show | Select-String -Pattern 'interface: ' | Select-Object -First 1 | ForEach-Object { $_.ToString().Split(' ')[1] }

# get peer public key
$peer_public_key = & $wg_exe show | Select-String -Pattern 'peer: ' | Select-Object -First 1 | ForEach-Object { $_.ToString().Split(' ')[1] }

# get endpoint ip and port
$endpoint_ip = & $wg_exe show | Select-String -Pattern 'endpoint: ' | Select-Object -First 1 | ForEach-Object { $_.ToString().Split(':')[1] }
$endpoint_ip = $endpoint_ip.Trim()
$endpoint_port = & $wg_exe show | Select-String -Pattern 'endpoint: ' | Select-Object -First 1 | ForEach-Object { $_.ToString().Split(':')[2] }
$endpoint_port = [int]$endpoint_port

# endpoint_port add 1 if endpoint_port less than $rangeEnd, else assign $rangeStart
if ($endpoint_port -lt $rangeEnd) {
    $endpoint_port = $endpoint_port + 1
}
else {
    $endpoint_port = $rangeStart
}

Write-Host "peer_public_key: $peer_public_key" -ForegroundColor Green
Write-Host "endpoint_ip: $endpoint_ip" -ForegroundColor Green
Write-Host "endpoint_port: $endpoint_port" -ForegroundColor Green

# set endpoint ip and port
& $wg_exe set $interface_name peer $peer_public_key endpoint ${endpoint_ip}:${endpoint_port}

& $wg_exe show
```
