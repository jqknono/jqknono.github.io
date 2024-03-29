---
title: 配置Windows
---

# Windows

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [系统配置](#系统配置)
- [建议的应用](#建议的应用)
- [可选应用](#可选应用)
- [配置计划任务](#配置计划任务)
- [工具配置](#工具配置)
- [Windows远程ssh登录](#windows远程ssh登录)
- [疑难杂症](#疑难杂症)
- [第三方工具](#第三方工具)

<!-- /TOC -->

## 系统配置

```ps1
# 使能 ps 脚本运行
Set-ExecutionPolicy RemoteSigned
Set-ExecutionPolicy Bypass -Scope Process

# 设置defender
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -RealTimeScanDirection 1
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -ScanAvgCPULoadFactor 5
Set-MpPreference -CheckForSignaturesBeforeRunningScan $false
Set-MpPreference -DisableDatagramProcessing $true
Set-MpPreference -DisableCpuThrottleOnIdleScans $false
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -DisableAutoExclusions $true
Set-MpPreference -DisableCatchupFullScan $true
Set-MpPreference -DisableCatchupQuickScan $true
Set-MpPreference -DisableEmailScanning $true
Set-MpPreference -DisableRemovableDriveScanning $true
Set-MpPreference -DisableRestorePoint $true
Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan $true
Set-MpPreference -DisableScanningNetworkFiles $true
Set-MpPreference -PUAProtection Disabled
Set-MpPreference -EnableNetworkProtection Disabled
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -EnableLowCpuPriority $true
Set-MpPreference -EnableFileHashComputation $false
Set-MpPreference -EnableFullScanOnBatteryPower $false
Set-MpPreference -DisableTlsParsing $true
Set-MpPreference -DisableHttpParsing $true
Set-MpPreference -DisableDnsParsing $true
Set-MpPreference -DisableDnsOverTcpParsing $true
Set-MpPreference -DisableSshParsing $true
Set-MpPreference -DisableInboundConnectionFiltering $true
Set-MpPreference -DisableRdpParsing $true

# 关闭smart Screen
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d Off

# 映射Capslock为Ctrl, 重启生效
$hexified = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"};
$kbLayout = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';
New-ItemProperty -Path $kbLayout -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexified);

# 支持Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# 切换回经典右键菜单
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# 恢复到新版右键菜单
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f

# IPv4 ping echo
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow

# IPv6 ping echo
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol="icmpv6:8,any" dir=in action=allow

# 使能Container
Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V", "Containers") -All

# 使能 IIS
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-ManagementConsole, IIS-HttpErrors, IIS-HttpRedirect, IIS-WindowsAuthentication, IIS-StaticContent, IIS-DefaultDocument, IIS-HttpCompressionStatic, IIS-DirectoryBrowsing

# 使能沙箱
Enable-WindowsOptionalFeature  -Online -FeatureName "Containers-DisposableClientVM" -All

# 移除phone link
Get-AppxPackage Microsoft.YourPhone -AllUsers | Remove-AppxPackage

# 使能powershell package get
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -Force
Install-Module PowerShellGet -AllowClobber -Force

# 移除explorer中的无用文件夹
# 3D Object
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
# Desktop
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
# Music
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
# Downloads
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
# Pictures
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
# Videos
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
# Documents
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f

# 禁用windows service
sc stop "wsearch" && sc config "wsearch" start=disabled
set-service -name "wsearch" -status Stopped -StartupType Disabled
get-service -name "*office*" | set-service -status Stopped -StartupType Disabled
get-service -name "*phone*" | set-service -status Stopped -StartupType Disabled
get-service -name "*vmware*" | set-service -status Stopped -StartupType manual

# 禁用defender
Set-MpPreference -DisableRealtimeMonitoring $true
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force

# openssh shell set to PowerShell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# 移动docker-desktop-data
wsl --shutdown
wsl --export docker-desktop-data E:\docker\docker-desktop-data.tar
wsl --unregister docker-desktop-data
wsl --import docker-desktop-data E:\docker E:\docker\docker-desktop-data.tar --version 2

# 同时连接有线和无线网络
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" -Name "fMinimizeConnections" -PropertyType DWORD -Value 0
```

## 建议的应用

```ps1
# ide
winget install --id Git.Git
winget install --id Microsoft.VisualStudioCode
winget install --id Microsoft.VisualStudio.2022.Professional
winget install --id Microsoft.VisualStudio.2019.BuildTools
# tool
winget install --id Microsoft.WindowsTerminal
winget install "Sysinternals Suite"
winget install DevToys
winget install --id 7zip.7zip
winget install --id ShareX.ShareX
winget install --id WinSCP.WinSCP
winget install --id ScooterSoftware.BeyondCompare4
winget install --id voidtools.Everything
winget install --id XMind.XMind
winget install --id vim.vim
winget install --id Docker.DockerDesktop
winget install --id WiresharkFoundation.Wireshark
winget install --id Kitware.CMake
winget install --id Google.Chrome
winget install --id DBBrowserForSQLite.DBBrowserForSQLite
winget install --id Canonical.Ubuntu.2204
winget install --id Insecure.Nmap
# lang
winget install --id Python.Python.3.11
winget install --id OpenJS.NodeJS.LTS
winget install --id GoLang.Go
winget install --id Microsoft.ASPNetCore.6-x64
winget install --id Microsoft.DotNet.SDK.7
```

## 可选应用

```ps1
# dev
winget install --id Oracle.MySQL
winget install --id Microsoft.SQLServer.2019.Express
winget install --id Tencent.wechat-devtool
winget install --id Google.AndroidStudio
winget install --id Postman.Postman
winget install --id Microsoft.OpenJDK.17
# tool
winget install --id Microsoft.WinDbg
winget install --id AOMEI.PartitionAssistant
winget install --id Cppcheck.Cppcheck
winget install --id Hiresolution.X-MouseButtonControl
winget install --id Tencent.WeChat
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
winget install --id VMware.WorkstationPlayer
winget install --id VMware.WorkstationPro
winget install --id Figma.Figma
winget install --id TimKosse.FileZilla.Client
winget install --id TimKosse.FileZilla.Server
winget install --id Valve.Steam
```

## 配置计划任务

```ps1
Unregister-ScheduledTask -TaskName "T1" -Confirm:$false

$action = New-ScheduledTaskAction -Execute "D:\code_private\jqknono.github.io\test.exe"
$trigger1 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -Once -At 12am
$trigger2 = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "system"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger1 $trigger2 -Settings $settings
Register-ScheduledTask -TaskName "T1" -TaskPath "jqknono" -InputObject $task

Set-ScheduledTask -TaskName "T1" -TaskPath "jqknono" -Trigger $trigger1
```

## 工具配置

## Windows远程ssh登录

```ps1
# https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement
# Get the public key file generated previously on your client
$authorizedKey = Get-Content -Path $env:USERPROFILE\.ssh\id_rsa.pub

# Generate the PowerShell to be run remote that will copy the public key file generated previously on your client to the authorized_keys file on your server
$remotePowershell = "powershell Add-Content -Force -Path $env:ProgramData\ssh\administrators_authorized_keys -Value '$authorizedKey';icacls.exe ""$env:ProgramData\ssh\administrators_authorized_keys"" /inheritance:r /grant ""Administrators:F"" /grant ""SYSTEM:F"""

# Connect to your server and run the PowerShell using the $remotePowerShell variable
ssh jqknono@homecenter $remotePowershell
```

## 疑难杂症

```ps1
# ipv6不更新
# delete registry HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6
Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6" -Force
# delete reg HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP6TUNNEL
Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6TUNNEL" -Force

# running scripts is disabled on this system
Set-ExecutionPolicy RemoteSigned
```

## 第三方工具

```ps1
# https://github.com/ChrisTitusTech/winutil
irm christitus.com/win | iex
```
