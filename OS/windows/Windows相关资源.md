# Windows 资源整理


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Windows 资源整理](#windows-资源整理)
  - [工具篇](#工具篇)
    - [监控&分析](#监控分析)
    - [AntiRootkit 工具](#antirootkit-工具)
    - [PE 工具](#pe-工具)
    - [逆向&调试](#逆向调试)
    - [注入工具](#注入工具)
    - [网络](#网络)
    - [压测工具](#压测工具)
    - [其他](#其他)
  - [代码篇](#代码篇)
    - [操作系统](#操作系统)
    - [内核封装](#内核封装)
    - [VT 技术](#vt-技术)
    - [其他](#其他-1)
  - [CTF 资源](#ctf-资源)
  - [渗透相关](#渗透相关)
  - [专利免费查询](#专利免费查询)

<!-- /code_chunk_output -->


这里只列举了一些 Windows 上调试，排查问题以及测试的一些常用工具，其他的加壳脱壳，加密解密，文件编辑器以及编程工具不进行整理了。

## 工具篇

### 监控&分析

| 工具名                | 下载地址                                                                   | 说明                                                                                                                                       |
| :-------------------- | :------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------- |
| **DebugView**         | <https://docs.microsoft.com/zh-cn/sysinternals/downloads/debugview>        | sysinternals 里面的工具，可用来查看、控制内核及用户态调式输出                                                                              |
| **Process Monitor**   | <https://docs.microsoft.com/zh-cn/sysinternals/downloads/procmon>          | sysinternals 里面的工具，实时监视文件系统，注册表，进程，线程以及 DLL 的活动，方便排查问题                                                 |
| **Process Explorer**  | <https://docs.microsoft.com/zh-cn/sysinternals/downloads/process-explorer> | sysinternals 里面的工具，进程查看器，可以浏览加载的 DLL，调用堆栈以及查找文件被哪些进程打开                                                |
| **WinObj**            | <https://docs.microsoft.com/zh-cn/sysinternals/downloads/winobj>           | sysinternals 里面的工具，对象管理器命名空间的查看利器，没有加载驱动而是使用系统 API 实现,可参考 GitHub 中的 WinObjEx64                     |
| **WinObjEx64**        | <https://github.com/hfiref0x/WinObjEx64>                                   | 对象管理器命名空间的查看利器，开源的                                                                                                       |
| **Handle**            | <https://docs.microsoft.com/zh-cn/sysinternals/downloads/handle>           | sysinternals 里面的工具，查看特定的文件或者目录被哪个应用程序占用                                                                          |
| **sysinternals**      | <https://live.sysinternals.com/>                                           | sysinternals 里面还有很多工具，一般用不着，暂时不进行罗列，上面几个是常用的工具                                                            |
| **CPU-Z**             | <https://www.cpuid.com/softwares/cpu-z.html>                               | CPU 实时监测工具                                                                                                                           |
| **ProcMonX**          | <https://github.com/zodiacon/ProcMonX>                                     | 使用 ETW 实现的类似于 Process Monitor 功能的工具，开源 C#语言编写                                                                          |
| **ProcMonXv2**        | <https://github.com/zodiacon/ProcMonXv2>                                   | 使用 ETW 实现的类似于 Process Monitor 功能的工具，开源 C#语言编写,第二版                                                                   |
| **processhacker**     | <https://github.com/processhacker/processhacker>                           | 开源的类似于 Process Explorer 的工具，支持 GPU 相关的信息显示                                                                              |
| **API Monitor**       | <http://www.rohitab.com/apimonitor>                                        | 通过跟踪 API 的调用，用来查看应用程序和服务的工作方式或跟踪应用程序中存在的问题，可修改 API 的入参及出参                                   |
| **Dependency Walker** | <http://www.dependencywalker.com/>                                         | 扫描任何 32 位或 64 位 Windows 模块,列出了该模块导出的所有功能等                                                                           |
| **DeviceTree**        | <http://www.osronline.com/article.cfm%5earticle=97.htm>                    | 显示系统的所有驱动对象以及相关设备栈信息                                                                                                   |
| **Unlocker**          | <https://www.softpedia.com/get/System/System-Miscellaneous/Unlocker.shtml> | 解锁占用文件的，很多类似的工具以及开源代码                                                                                                 |
| **RpcView**           | <https://github.com/silverf0x/RpcView>                                     | 显示以及反编译当前系统的 RPC 接口等信息，分析 RPC 的情况下可以借以辅助                                                                     |
| **RequestTrace**      | <https://the-sz.com/products/rt/>                                          | 可以查看 WINDOWS 上 IRP、SRB、URB 的详细信息，包含数据缓存等，一般也不会使用，因为 WINDBG 调试就可以分析数据，不调试的情况可以使用它来辅助 |
| **IRPMon**            | <https://github.com/MartinDrab/IRPMon>                                     | 通过挂钩驱动对象，实现类似于 RequestTrace、IrpTracker 的功能，监控驱动对象的所有 IRP 等形式的请求                                          |
| **IRPTrace**          | <https://github.com/haidragon/drivertools>                                 | 里面有一些其他工具                                                                                                                         |

### AntiRootkit 工具

| 工具名                      | 下载地址                                                | 说明                                                                                                                   |
| :-------------------------- | :------------------------------------------------------ | :--------------------------------------------------------------------------------------------------------------------- |
| **PcHunter**                | <https://www.anxinsec.com/view/antirootkit/>            | 安全分析工具，为了对抗 Rootkit，使用穿透技术进行文件，网络，注册表等的操作，并提供线程、进程以及内核模块的各种详细信息 |
| **Windows-Kernel-Explorer** | <https://github.com/AxtMueller/Windows-Kernel-Explorer> | 类似于 Pchunter，不开源，如果 PcHunter 没有支持最新系统，可以尝试这个软件                                              |
| **PowerTool**               |                                                         | 目前没咋更新，朋友公司的同事开发的，据说代码很乱。。。                                                                 |
| **py**                      | <https://github.com/antiwar3/py>                        | 飘云 ark                                                                                                               |

### PE 工具

| 工具名           | 下载地址                          | 说明     |
| :--------------- | :-------------------------------- | :------- |
| **CFF Explorer** | <https://ntcore.com/?page_id=388> | 还不错的 |
| **ExeinfoPe**    | <http://www.exeinfo.xn.pl/>       |          |

### 逆向&调试

| 工具名              | 下载地址                                                 | 说明                                                                                                 |
| :------------------ | :------------------------------------------------------- | :--------------------------------------------------------------------------------------------------- | --- |
| **Ghidra**          | <https://www.nsa.gov/resources/everyone/ghidra/>         | 由美国国家安全局（NSA）研究部门开发的软件逆向工程（SRE）套件，用于支持网络安全任务                   |
| **IDA**             | <https://down.52pojie.cn/>                               | 最新的破解版吧好像是 7.5，可在吾爱破解论坛查找下载地址                                               |
| **dnSpy**           | <https://github.com/dnSpy/dnSpy>                         | .NET 程序的逆向工具，对于不混淆不加密的.NET 程序相当于看源代码了，前提是了解.NET 框架                |
| **OllyDbg**         | <https://down.52pojie.cn/Tools/Debuggers//>              | 用于逆向分析应用程序，插件丰富，但是不开源也不支持 x64 程序                                          |
| **x64DBG**          | <https://x64dbg.com/>                                    | 用于逆向分析应用程序，开源，支持 x64 程序，相对于 windbg 来说操作更方便点，和 OD 比较建议选择 x64dbg |
| **CheatEngine**     | <https://www.cheatengine.org/>                           | 逆向破解的神器，支持各种内存搜索、修改以及一些其他的高级逆向功能                                     |
| **VirtualKD-Redux** | <https://github.com/4d61726b/VirtualKD-Redux/releases>   | Windbg 虚拟机调试的全自动化辅助工具，不再需要设置一堆环境变量，支持最新 VMWare                       |
| **Driver Loader**   | <http://www.osronline.com/article.cfm%5Earticle=157.htm> | OSR 提供的工具，进行驱动的安装，加载以及卸载                                                         |     |
| reverse-engineering | <https://github.com/wtsxDev/reverse-engineering>         | 基本上逆向需要得工具都可以在这里找到                                                                 |

### 注入工具

| 工具名              | 下载地址                                       | 说明                                             |
| :------------------ | :--------------------------------------------- | :----------------------------------------------- | ------------------------------------------------------------ |
| **yapi**            | <https://github.com/ez8-co/yapi>               | 一个程序注入 x64/x86 进程                        | 开源，使用少，可重点查看源码，支持 32 位程序向 64 位程序注入 |
| **Xenos**           | <https://github.com/DarthTon/Xenos>            | 开源，而且使用了鼎鼎大名的黑古工程，支持内核注入 |
| **ExtremeInjector** | <https://github.com/master131/ExtremeInjector> | 应用层注入工具，支持 32 位程序向 64 位程序注入   |

### 网络

| 工具名         | 下载地址                                  | 说明                                                                                   |
| :------------- | :---------------------------------------- | :------------------------------------------------------------------------------------- |
| **Fiddler**    | <https://www.telerik.com/fiddler>         | 可直接中间人劫持，不需要手动添加证书等，支持脚本进行流量劫持,同事也提供了 SDK 进行编码 |
| **Wireshark**  | <https://www.wireshark.org/download.html> | 这个就不多介绍了                                                                       |
| **Burp Suite** | <https://portswigger.net/burp>            | 渗透的好像都偏爱这个抓包工具，依赖 JDK，可在吾爱下载破解版                             |

### 压测工具

| 工具名                   | 下载地址                                                                                 | 说明                                                    |
| :----------------------- | :--------------------------------------------------------------------------------------- | :------------------------------------------------------ |
| **Driver Verifier**      | <https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/driver-verifier>      | 系统自带，驱动稳定性测试工具                            |
| **Application Verifier** | <https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/application-verifier> | 系统自带，应用层的压测工具                              |
| **CPUStress**            | <https://docs.microsoft.com/en-us/sysinternals/downloads/cpustres>                       | 让 CPU 负荷工作，测试极端情况下软件的稳定性以及响应度等 |

### 其他

| 工具名                       | 下载地址                                                                                                                                                     | 说明                    |
| :--------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------- |
| **game-hacking**             | <https://github.com/dsasmblr/game-hacking>                                                                                                                   |                         |
| **awesome-malware-analysis** | <https://github.com/rootkiter/awesome-malware-analysis>                                                                                                      | 病毒分析工具集合        |
| **drawio**                   | <https://github.com/jgraph/drawio-desktop>                                                                                                                   | 绘图神器                |
| RazorSQL                     | <https://www.razorsql.com/>                                                                                                                                  | SQLite3 数据库 GUI 工具 |
| Git 学习笔记                 | <https://github.com/No-Github/1earn/blob/master/1earn/Develop/%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6/Git%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0.md>               | Git 版本管理知识        |
| Markdown 语法学习            | <https://github.com/No-Github/1earn/blob/master/1earn/Develop/%E6%A0%87%E8%AE%B0%E8%AF%AD%E8%A8%80/Markdown/Markdown%E8%AF%AD%E6%B3%95%E5%AD%A6%E4%B9%A0.md> | Markdown 语法学习       |

## 代码篇

### 操作系统

| 工具名       | 下载地址                                                                        | 说明                                                             |
| :----------- | :------------------------------------------------------------------------------ | :--------------------------------------------------------------- |
| **ReactOS**  | <https://github.com/reactos/reactos>                                            | 好像是逆向 windows 2000 的开源系统，可以替换 win 2000 的内核程序 |
| **wrk-v1.2** | <https://github.com/jmcjmmcjc/wrk-v1.2>                                         | Windows NT 5.2 Partial Source Code                               |
| **WinNT4**   | <https://github.com/ZoloZiak/WinNT4>                                            | Windows NT4 Kernel Source code                                   |
| whids        | https://github.com/0xrawsec/whids/tree/a826d87e0d035daac10bfa96b530c5deff6b9915 | Open Source EDR for Windows                                      |

### 内核封装

| 工具名                                      | 下载地址                                                                     | 说明                                                           |
| :------------------------------------------ | :--------------------------------------------------------------------------- | :------------------------------------------------------------- |
| **CPPHelper**                               | <https://github.com/Chuyu-Team/CPPHelper>                                    | C++基础辅助类库                                                |
| **cpp_component**                           | <https://github.com/skyformat99/cpp_component>                               | 对 cpp 一些常用的功能进行封装                                  |
| **WinToolsLib**                             | <https://github.com/deeonis-ru/WinToolsLib>                                  | Suite of classes for Windows programming                       |
| **KDU**                                     | <https://github.com/hfiref0x/KDU>                                            |                                                                |
| **KTL**                                     | <https://github.com/MeeSong/KTL>                                             |                                                                |
| **Kernel-Bridge**                           | <https://github.com/HoShiMin/Kernel-Bridge>                                  |                                                                |
| **KernelForge**                             | <https://github.com/killvxk/KernelForge>                                     |                                                                |
| **ExecutiveCallbackObjects**                | <https://github.com/0xcpu/ExecutiveCallbackObjects>                          | 内核下的各种回调研究                                           |
| **SyscallHook**                             | <https://github.com/AnzeLesnik/SyscallHook>                                  | System call hook for Windows 10 20H1                           |
| **Antivirus_R3_bypass_demo**                | <https://github.com/huoji120/Antivirus_R3_bypass_demo>                       | 分别用 R3 的 0day 与 R0 的 0day 来干掉杀毒软件                 |
| **KernelHiddenExecute**                     | <https://github.com/zouxianyu/KernelHiddenExecute>                           | 在内核地址空间中隐藏代码/数据                                  |
| **DriverInjectDll**                         | <https://github.com/strivexjun/DriverInjectDll>                              | 内核模式下全局注入，内存注入，支持 WIN7-WIN10                  |
| **zwhawk**                                  | <https://github.com/eLoopWoo/zwhawk>                                         | Windows 远程命令和控制界面的内核 rootkit                       |
| **ZeroBank-ring0-bundle**                   | <https://github.com/Trietptm-on-Coding-Algorithms/ZeroBank-ring0-bundle>     | 连接到远程服务器以发送和接收命令的内核模式 rootkit             |
| **kdmapper**                                | <https://github.com/z175/kdmapper>                                           | About driver manual mapper (outdated/for educational purposes) |
| **antispy**                                 | <https://github.com/mohuihui/antispy>                                        | a free but powerful anti virus and rootkits toolkit            |
| **windows_kernel_resources**                | <https://github.com/sam-b/windows_kernel_resources>                          |                                                                |
| **HookLib**                                 | <https://github.com/HoShiMin/HookLib>                                        | UserMode and KernelMode support                                |
| **Kernel-Whisperer**                        | <https://github.com/BrunoMCBraga/Kernel-Whisperer>                           | 内核模块封装                                                   |
| SQLiteCpp                                   | <https://github.com/SRombauts/SQLiteCpp>                                     | a smart and easy to use C++ SQLite3 wrapper                    |
| awesome-windows-kernel-security-development | <https://github.com/ExpLife0011/awesome-windows-kernel-security-development> | 各种内核技术得代码合集                                         |

### VT 技术

| 工具名                      | 下载地址                                                  | 说明 |
| :-------------------------- | :-------------------------------------------------------- | :--- |
| **hvpp**                    | <https://github.com/wbenny/hvpp>                          |      |
| **HyperBone**               | <https://github.com/DarthTon/HyperBone>                   |      |
| **HyperWin**                | <https://github.com/amiryeshurun/HyperWin>                |      |
| **Hypervisor**              | <https://github.com/Bareflank/hypervisor>                 |      |
| **HyperPlatform**           | <https://github.com/tandasat/HyperPlatform>               |      |
| **Hyper-V-Internals**       | <https://github.com/gerhart01/Hyper-V-Internals>          |      |
| **Hypervisor-From-Scratch** | <https://github.com/SinaKarvandi/Hypervisor-From-Scratch> |      |
| **KasperskyHook**           | <https://github.com/iPower/KasperskyHook>                 |      |
| **awesome-virtualization**  | <https://github.com/Wenzel/awesome-virtualization>        |      |
| **ransomware_begone**       | <https://github.com/ofercas/ransomware_begone>            |      |

### 其他

| 工具名              | 下载地址                                                                       | 说明                                                   |
| :------------------ | :----------------------------------------------------------------------------- | :----------------------------------------------------- |
| **Divert**          | <https://github.com/basil00/Divert>                                            | 将数据流量转发给应用程序，可以修改，丢弃等操作网络流量 |
| **Blackbone**       | <https://github.com/DarthTon/Blackbone>                                        | 内核模式下的几种注入方式，包括了内核模式下的内存注入   |
| **NetWatch**        | <https://github.com/huoji120/NetWatch>                                         | 威胁流量检测系统，可以做虚拟内存补丁                   |
| **x64_AOB_Search**  | <https://github.com/wanttobeno/x64_AOB_Search>                                 | 快速内存搜索算法，商用级别,支持通配符                  |
| **DuckMemoryScan**  | <https://github.com/huoji120/DuckMemoryScan>                                   | 检测绝大部分所谓的内存免杀马                           |
| **FSDefender**      | <https://github.com/Randomize163/FSDefender>                                   | 文件驱动监控 + 云备份方案                              |
| **AntiRansomware**  | <https://github.com/clavis0x/AntiRansomware>                                   | 防勒索方案，不让覆盖，写就进行扫描                     |
| **Lazy**            | <https://github.com/moonAgirl/Lazy>                                            | (恶意)勒索软件终结者                                   |
| awesome-cheatsheets | <https://github.com/skywind3000/awesome-cheatsheets/blob/master/tools/git.txt> | 各种 python,git 速查表                                 |

## CTF 资源

| 仓库名             | 仓库地址                                      | 说明                              |
| :----------------- | :-------------------------------------------- | :-------------------------------- |
| **CTF-All-In-One** | <https://github.com/firmianay/CTF-All-In-One> |                                   |
| **ctf-book**       | <https://github.com/firmianay/ctf-book>       | CTF 竞赛权威指南(Pwn 篇) 相关资源 |

## 渗透相关

| 仓库名                    | 仓库地址                                                  | 说明                                              |
| :------------------------ | :-------------------------------------------------------- | :------------------------------------------------ |
| **Web-Security-Learning** | <https://github.com/CHYbeta/Web-Security-Learning>        |                                                   |
| **pentest**               | <https://github.com/r0eXpeR/pentest>                      | 内网渗透中的一些工具及项目资料                    |
| **K8tools**               | <http://k8gege.org/p/72f1fea6.html>                       | K8tools 工具合集                                  |
| **Awesome-Red-Teaming**   | <https://github.com/yeyintminthuhtut/Awesome-Red-Teaming> | List of Awesome Red Teaming Resources             |
| **Awesome-Hacking**       | <https://github.com/Hack-with-Github/Awesome-Hacking>     | A collection of various awesome lists for hackers |
| awesome-web-hacking       | <https://github.com/infoslack/awesome-web-hacking>        | 渗透知识                                          |

## 专利免费查询

| 仓库名               | 仓库地址                   | 说明 |
| :------------------- | :------------------------- | :--- |
| **专利信息服务平台** | <http://search.cnipr.com/> |      |
| **patents**          | <www.google.com/patents>   |      |
| **incopat**          | <www.incopat.com>          |      |
| **佰腾**             | <https://www.baiten.cn/>   |      |
| **rainpat**          | <https://www.rainpat.com/> |      |
| **度衍**             | <https://www.uyanip.com/>  |      |


