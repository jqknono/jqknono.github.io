---
title: 为什么不建议使用闭源clash
---

# 为什么不建议使用闭源 clash

目前常用的 clash 工具有以下几种:

| 工具名                                                                   | 仓库地址                                                | Starred | Fork              | 作者        | 开源协议 | 语言   | 平台                  | 描述                                                                                     |
| ------------------------------------------------------------------------ | ------------------------------------------------------- | ------- | ----------------- | ----------- | -------- | ------ | --------------------- | ---------------------------------------------------------------------------------------- |
| [clash](https://github.com/Dreamacro/clash)                              | https://github.com/Dreamacro/clash                      | 36.4k   | 4.8k              | Dreamacro   | MIT      | Go     | Linux, Windows, macOS | A rule-based tunnel in Go.                                                               |
| [clash premium](https://github.com/Dreamacro/clash/releases/tag/premium) | https://github.com/Dreamacro/clash/releases/tag/premium | ?       | ?                 | Dreamacro   | ?        | ?      | Linux, Windows, macOS | A rule-based tunnel in Go.                                                               |
| [Clash.Meta](https://github.com/MetaCubeX/Clash.Meta)                    | https://github.com/MetaCubeX/Clash.Meta                 | 2.9k    | forked from Clash | MetaCubeX   | GPL-3.0  | GO     | Linux, Windows, macOS | A rule-based tunnel for Windows.                                                         |
| [clash for windows](https://github.com/Fndroid/clash_for_windows_pkg)    | https://github.com/Fndroid/clash_for_windows_pkg        | 44.8k   | 5.7k              | Fndroid     | ?        | ?      | Linux, Windows, macOS | A Windows/macOS/Linux GUI based on Clash and Electron.                                   |
| [ClashForAndroid](https://github.com/Kr328/ClashForAndroid)              | https://github.com/Kr328/ClashForAndroid                | 20.4k   | 2.3k              | Kr328       | GPL-3.0  | Kotlin | Android               | A rule-based tunnel for Android.                                                         |
| [clashX](https://github.com/yichengchen/clashX)                          | https://github.com/yichengchen/clashX                   | 22.5k   | 2.9k              | yichengchen | AGPL-3.0 | Swift  | macOS                 | ClashX 旨在提供一个简单轻量化的代理客户端，如果需要更多的定制化，可以考虑使用 CFW Mac 版 |
| [clashN](https://github.com/2dust/clashN)                                | https://github.com/2dust/clashN                         | 1.4k    | 155               | 2dust       | GPL-3.0  | C#     | Windows               | A clash client for Windows, support clash core and Clash.Meta core                       |
| etc.                                                                     |                                                         |         |                   |             |          |        |                       |                                                                                          |

可以看到最受欢迎的工具是`clash for windows`, 但它是最不建议使用的应用.
事实上, `clash for windows`是闭源的, 作者是`Fndroid`, 他的其他项目也是闭源的.
`clash premium` 是`clash`的闭源版本, 许多高级功能都只在闭源版本中实现.
使用代理的人群中, 有很多人是为了隐私, 但是使用闭源的软件, 就是在自己的隐私上做出了妥协. 早期被安利使用clash时发现premium版本功能更强大, 但是闭源让人不安.
经过搜索, 发现 `Clash.Meta`, `clashN` 这两个开源的项目, 可以解决在Windows上的代理需求.

盘点代理软件发展史:

1. 简单代理, 通常系统都自带代理设置, 但许多软件不支持系统代理
2. 透明代理, 无感的转发流量, 需要在路由器上设置或者在系统上设置, 设置相对复杂
3. 基于规则的代理, 浏览器插件, SwitchyOmega. 选择部分流量代理
4. 自定义的混淆协议, 例如 shadowsocks, shadowsocksR, v2ray, trojan, VMess
5. GUI 客户端种类繁多, 例如 clash for windows, clash for android, clashX, clashN

按时间顺序出现过的代理手段:

协议类:

1. [shadowsocks](https://github.com/clowwindy/shadowsocks-libev/tree/master)
2. shadowsocksR
3. [v2ray](https://github.com/v2ray/v2ray-core)
4. [trojan](https://github.com/trojan-gfw/trojan)
5. etc.

规则类:

1. [gfwlist](https://github.com/gfwlist/gfwlist)
2. [chnroute](https://github.com/misakaio/chnroutes2)
3. [SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega), 一款浏览器插件, 用于选择部分流量代理
4. [clash](https://github.com/Dreamacro/clash)
5. etc.

界面类:

1. [shadowsocks-windows](https://github.com/shadowsocks/shadowsocks-windows)
2. [shadowsocks-android](https://github.com/shadowsocks/shadowsocks-android)
3. [clash for windows](https://github.com/Fndroid/clash_for_windows_pkg)
4. [ClashForAndroid](https://github.com/Kr328/ClashForAndroid)
5. [v2rayN](https://github.com/2dust/v2rayN)
6. [v2rayNG](https://github.com/2dust/v2rayNG)
7. [ShadowRocket](https://apps.apple.com/us/app/shadowrocket/id932747118)
8. etc.

