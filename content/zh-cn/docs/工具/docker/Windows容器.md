---
title: Windows容器
---

# Windows 容器

Windows 容器提供四种基础镜像:

- Windows - 包含整套 Windows API 和系统服务（服务器角色除外）。
- Windows Server - 包含整套 Windows API 和系统服务。
- Windows Server Core - 一个较小的映像，包含部分 Windows Server API - 即完整的 .NET Framework。 它还包括大多数（但不是所有）服务器角色，例如不包含传真服务器。
- Nano Server - 最小的 Windows Server 映像，包括支持 .NET Core API 和某些服务器角色。

https://github.com/microsoft/Windows-Containers
This repository is offered for tracking features and issues with Windows Containers. The Windows Containers product team will monitor this repo in order to engage with our community and discuss questions, customer scenarios, or feature requests.

目前关注数较少, 说明使用人数较少, 发现问题和解决问题的人也较少.

## 限制

    若要在 Windows 10 或 11 上运行容器，需要以下各项：

    1. 需要 Windows10 或 11 的专业版或企业版, 且版本号大于等于 1607.
    2. 需要开启 Hyper-V 功能, 并且开启虚拟机功能.

    从 Windows 10 的 2018 年 10 月更新版开始，Microsoft 不再允许用户在 Windows 10 企业版或专业版上以进程隔离模式运行 Windows 容器进行开发/测试。 有关详细信息，请参阅常见问题解答。

    Windows Server 容器在 Windows 10 和 11 上默认使用 Hyper-V 隔离，为开发人员提供在生产中使用的相同内核版本和配置。 若要详细了解 Hyper-V 隔离，请查看[隔离模式](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/manage-containers/hyperv-container)。

    对于开发环境，若要运行 Windows Server 容器，需要一台运行 Windows Server 的物理服务器或虚拟机。

    要进行测试，可以下载 Windows Server 2022 评估版或 Windows Server Insider Preview 的副本。


用到 Hyper-V, 说明 Windows 的 Server 版和非 Server 版存在不可忽视的差异, 普通用户通常使用非 server 版, 非Server的Windows无法直接运行基于server的容器. 四个基础镜像里仅一个Windows可以提供普通用户使用, 另外三个都是基于Server, 对普通用户来说大部分镜像都不能使用.

- 使用非Server的Widnows能用到的镜像非常有限, 且不能使用Server的镜像.
- 如果使用虚拟机平台会造成性能负担, 已经失去使用容器的初衷.

截至**2023-02-07**, Windows的容器方案限制明显, Windows Server版仍然是微软难以抛弃的重要收入来源, 由于适用面狭窄, 生态匮乏, 因此建议对Windows容器的调研投入暂停.

## 参考

- [概述](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/about/)
- [快速入门](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/quick-start/set-up-environment)
