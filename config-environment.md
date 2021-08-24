# config-environment

## Windows

使能ps脚本运行: `Set-ExecutionPolicy RemoteSigned`

### proxy

做开发工作, 代理是必须的, 没有代理许多依赖都无法下载, 不能顺畅访问海量的英文资源.

tool: [shadowsocks-windows](https://github.com/shadowsocks/shadowsocks-windows)

service:  

- [justmysocks](https://justmysocks.net/members/cart.php)
- [v2.fit](https://v2.fit/cart.php)

#### UWP

Each run will cause all uwp applications to go through proxy.

```ps1
foreach($f in Get-ChildItem $env:LOCALAPPDATA\Packages) {CheckNetIsolation.exe LoopbackExempt -a "-n=$($f.Name)"}
```

```ps1
CheckNetIsolation.exe LoopbackExempt –a –n=<App Directory>
```

change `<App Directory>` to the directory name in %LOCALAPPDATA%\Packages directory with your app name.

### Beyond Compare

用于对比文件.

https://www.scootersoftware.com/download.php

持续试用: `reg delete "HKCU\Software\Scooter Software\Beyond Compare 4" /v CacheID /f`

### Everything

用于全局搜索文件, 基于文件名, 非文件内容.

建议关掉Windows Search.

https://www.voidtools.com/zh-cn/downloads/

## Mac

## Linux

