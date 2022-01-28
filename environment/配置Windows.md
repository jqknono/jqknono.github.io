# Windows

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Windows](#windows)
  - [系统配置](#系统配置)
  - [建议的应用](#建议的应用)
  - [可选应用](#可选应用)
  - [循环任务](#循环任务)

<!-- /code_chunk_output -->

## 系统配置

```batch
rem 关掉 Windows Search
sc stop "wsearch" && sc config "wsearch" start=disabled
```

```ps1
# 使能 ps 脚本运行
Set-ExecutionPolicy RemoteSigned

# 关闭Real-time protection
Set-MpPreference -DisableRealtimeMonitoring $true
# 关闭smart Screen
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d Off

# 映射Capslock为Ctrl, 重启生效
$hexified = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"};
$kbLayout = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';
New-ItemProperty -Path $kbLayout -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexified);

# 支持Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

## 建议的应用

```ps1
# ide
winget install --id Git.Git
winget install --id Microsoft.VisualStudioCode
winget install --id Microsoft.VisualStudio.2022.Community
winget install --id Microsoft.VisualStudio.2019.BuildTools
# tool
winget install --id Microsoft.WindowsTerminal
winget install "Sysinternals Suite"
winget install --id 7zip.7zip
winget install --id ShareX.ShareX
winget install --id WinSCP.WinSCP
winget install --id ScooterSoftware.BeyondCompare4
winget install --id voidtools.Everything
winget install --id XMind.XMind
winget install --id 7zip.7zip
winget install --id Notepad++.Notepad++
winget install --id Docker.DockerDesktop
winget install --id WiresharkFoundation.Wireshark
winget install --id Kitware.CMake
# lang
winget install --id Python.Python.3
winget install --id OpenJS.NodeJS.LTS
winget install --id GoLang.Go
```

## 可选应用

```ps1
# dev
winget install --id Oracle.MySQL
winget install --id Microsoft.SQLServer.2019.Express
winget install --id Tencent.wechat-devtool
winget install --id Google.AndroidStudio
# tool
winget install --id Cppcheck.Cppcheck
winget install --id Hiresolution.X-MouseButtonControl
winget install --id Tencent.WeChat
winget install --id Adobe.Acrobat.Reader.32-bit
winget install --id DominikReichl.KeePass
winget install --id Google.Drive
winget install --id Google.Chrome
winget install --id SoftDeluxe.FreeDownloadManager
winget install --id Lexikos.AutoHotkey
winget install --id DeepL.DeepL
winget install --id Microsoft.VC++2015-2022Redist-x64
winget install --id Microsoft.VC++2013Redist-x64
winget install --id Microsoft.VC++2015-2022Redist-x86
winget install --id Microsoft.VC++2013Redist-x86
winget install "OneNote for Windows 10"
winget install --id Microsoft.PowerShell
winget install --id Microsoft.OneDrive
winget install --id JGraph.Draw
```

## 循环任务

```ps1
$action = New-ScheduledTaskAction -Execute "C:\Python39\python.exe D:\private-code\ddns-client.py"
$trigger1 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 10) -Once -At 12am
$trigger2 = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "system"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger1 $trigger2 -Settings $settings
Register-ScheduledTask T1 -InputObject $task -TaskPath "jqknono"

Unregister-ScheduledTask -TaskName "T1" -Confirm:$false
```
