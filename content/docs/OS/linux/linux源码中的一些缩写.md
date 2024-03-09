# linux 源码中的一些缩写

| 缩写          | 全称                                       |
| ------------- | ------------------------------------------ |
| APIC          | Advanced Programmable Interrupt Controller |
| APM           | Advanced Power Management                  |
| ATA           | Advanced Technology Attachment             |
| BIOS          | Basic Input/Output System                  |
| BSS           | Block Started by Symbol                    |
| BTRFS         | B-tree file system                         |
| BZ2           | BZip2                                      |
| CIFS          | Common Internet File System                |
| CMA           | Contiguous Memory Allocator                |
| COBALT        | Real-Time Linux                            |
| CPIO          | Cyclic Redundancy Check                    |
| CR0           | Control Register 0                         |
| CR2           | Control Register 2                         |
| CR3           | Control Register 3                         |
| CR4           | Control Register 4                         |
| CR8           | Control Register 8                         |
| CRC           | Cyclic Redundancy Check                    |
| CROSS_COMPILE | 编译交叉编译器                             |
| CRS           | Cyclic Redundancy Check                    |
| DAX           | Direct Access                              |
| DMA           | Direct Memory Access                       |
| DTB           | Device Tree Blob                           |
| DTS           | Device Tree Source                         |
| EFI           | Extensible Firmware Interface              |
| EFLAGS        | Extended Flags                             |
| EISA          | Extended Industry Standard Architecture    |
| EISA          | Extended Industry Standard Architecture    |
| ESR           | Error Status Register                      |
| FAT           | File Allocation Table                      |
| FAT32         | File Allocation Table                      |
| FDT           | Flattened Device Tree                      |
| FIFO          | First In First Out                         |
| FPU           | Floating Point Unit                        |
| FS            | File System                                |
| GDT           | Global Descriptor Table                    |
| GFP           | Get Free Pages                             |
| GIC           | Generic Interrupt Controller               |
| GPT           | GUID Partition Table                       |
| HDD           | Hard Disk Drive                            |
| HDMI          | High-Definition Multimedia Interface       |
| HID           | Human Interface Device                     |
| HLE           | Hardware Lock Elision                      |
| HPC           | High Performance Computing                 |
| HRT           | High Resolution Timer                      |
| HVM           | Hardware Virtual Machine                   |
| I/O           | Input/Output                               |
| I/O           | Input/Output                               |
| IDE           | Integrated Drive Electronics               |
| IOAPIC        | Input/Output Advanced Programmable Interr  |
| IOMMU         | Input/Output Memory Management Unit        |
| IOVA          | Input/Output Virtual Address               |
| IRQ           | Interrupt Request                          |
| IRQ           | Interrupt Request                          |
| ISA           | Industry Standard Architecture             |
| ISR           | Interrupt Service Routine                  |
| MMU           | Memory Management Unit                     |

## 局部变量

| 缩写 | 全称                                  |
| ---- | ------------------------------------- |
| ah   | authentication header                 |
| bh   | buffer header                         |
| cb   | control block                         |
| hal  | hardware abstraction layer            |
| hrt  | high resolution timer                 |
| icmp | internet control message protocol     |
| ih   | ip header                             |
| ihl  | internet header length                |
| ip   | internet protocol                     |
| ipv6 | internet protocol version 6           |
| mss  | maximum segment size                  |
| mss  | maximum segment size                  |
| mtu  | maximum transmission unit             |
| mmu  | memory management unit                |
| napi | network address portability interface |
| nd   | network device                        |
| p    | page                                  |
| p    | pointer                               |
| sk   | socket                                |
| skb  | socket buffer                         |
| skbp | socket buffer pointer                 |
| skbs | socket buffer size                    |
| tcp  | transmission control protocol         |
| th   | tcp header                            |
| ts   | timestamp                             |
| udp  | user datagram protocol                |

## 内核源码目录结构

| 目录                               | 说明                                                                                    |
| ---------------------------------- | --------------------------------------------------------------------------------------- |
| include                            | 内核头文件，需要提供给外部模块（例如用户空间代码）使用。                                |
| kernel                             | Linux 内核的核心代码，包含了 3.2 小节所描述的进程调度子系统，以及和进程调度相关的模块。 |
| mm                                 | 内存管理子系统（3.3 小节）。                                                            |
| fs                                 | VFS 子系统（3.4 小节）。                                                                |
| net                                | 不包括网络设备驱动的网络子系统（3.5 小节）。                                            |
| ipc                                | IPC（进程间通信）子系统。                                                               |
| arch/                              | 体系结构相关的代码，例如 arm, x86 等等。                                                |
| arch//mach-                        | 具体的 machine/board 相关的代码。                                                       |
| arch//include/asm                  | 体系结构相关的头文件。                                                                  |
| arch//boot/dts                     | 设备树（Device Tree）文件。                                                             |
| init                               | Linux 系统启动初始化相关的代码。                                                        |
| block                              | 提供块设备的层次。                                                                      |
| sound                              | 音频相关的驱动及子系统，可以看作“音频子系统”。                                          |
| drivers                            | 设备驱动（在 Linux kernel 3.10 中，设备驱动占了 49.4 的代码量）。                       |
| lib                                | 实现需要在内核中使用的库函数，例如 CRC、FIFO、list、MD5 等。                            |
| crypto                             | - 加密、解密相关的库函数。                                                              |
| security                           | 提供安全特性（SELinux）。                                                               |
| virt                               | 提供虚拟机技术（KVM 等）的支持。                                                        |
| usr                                | 用于生成 initramfs 的代码。                                                             |
| firmware                           | 保存用于驱动第三方设备的固件。                                                          |
| samples                            | 一些示例代码。                                                                          |
| tools                              | 一些常用工具，如性能剖析、自测试等。                                                    |
| Kconfig, Kbuild, Makefile, scripts | 用于内核编译的配置文件、脚本等。                                                        |
| COPYING                            | 版权声明。                                                                              |
| MAINTAINERS                        | 维护者名单。                                                                            |
| CREDITS                            | Linux 主要的贡献者名单。                                                                |
| REPORTING-BUGS                     | Bug 上报的指南。                                                                        |
| Documentation, README              | 帮助、说明文档。                                                                        |
