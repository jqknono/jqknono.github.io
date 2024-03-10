---
title: gcc-cheetsheet
---

# gcc 速查

g++ 等价于 `gcc -xc++ -lstdc++ -shared-libgcc`

## 常用选项

| 选项                     | 说明                 | 例子                              |
| ------------------------ | -------------------- | --------------------------------- |
| -E                       | 预处理               | gcc -E file.c                     |
| -S                       | 生成汇编代码         | gcc -S file.i                     |
| -c                       | 只编译，不链接       | gcc -c file.s                     |
| -o                       | 指定输出文件名       | gcc file.c -o file                |
| -g                       | 生成调试信息         | gcc -g file.c                     |
| -s                       | 去除符号表           | gcc -s file.c                     |
| -fPIC                    | 生成位置无关代码     | gcc -fPIC file.c                  |
| -D{macro}                | 定义宏               | gcc -D5969 file.c                 |
| -Werror                  | 将所有警告当作错误   | gcc -Werror file.c                |
| @{file_contains_options} | 从文件中读取编译选项 | gcc file.c @file_contains_options |
| -MM                      | 生成依赖关系         | gcc -MM file.c                    |
| -m32                     | 生成 32 位程序       | gcc -m32 file.c                   |
| -l                       | 链接库               | gcc -lstdc++ file.c               |
| -save-temps              | 保存中间文件         | gcc -save-temps file.c            |

## 文件后缀含义

| 后缀 | 说明                                                       |
| ---- | ---------------------------------------------------------- |
| .o   | Relocatable File, 目标文件, 也就是编译后的文件, 可重定位的 |
| .i   | Preprocessed File, 预处理后的文件                          |
| .s   | Assembly File, 汇编文件                                    |
| .out | Executable File, 可执行文件                                |
| .so  | Shared Object File, 共享库文件                             |

更多: [[文件后缀含义]]

## 更多编译选项

常用 gcc 参数:

很多线上版本都是使用`-O2 -g`的编译选项进行编译的，这样可以保证编译出来的程序既可以调试，又可以运行的快。

| args                            | desc                                                                     |
| ------------------------------- | ------------------------------------------------------------------------ |
| -s                              | 生成可执行文件                                                           |
| -g                              | 生成调试信息                                                             |
| -g1                             | 生成调试信息，不包含符号表                                               |
| -g2                             | 生成调试信息，包含符号表, 默认-g 的调试级别                              |
| -g3                             | 生成调试信息，包含符号表和行号                                           |
| -MM                             | 生成 Makefile                                                            |
| -m32                            | 指定 32 位架构                                                           |
| -fomit-frame-pointer            | 不使用 rbp 寄存器                                                        |
| -fno-omit-frame-pointer         | 使用 rbp 寄存器                                                          |
| -fno-stack-protector            | 不使用栈保护                                                             |
| -fno-asynchronous-unwind-tables | 不使用异步 unwind 表                                                     |
| -fno-ident                      | 不生成 ident 信息                                                        |
| -fno-dwarf2-cfi-asm             | 不生成 dwarf2 cfi 信息                                                   |
| -masm=intel                     | 汇编代码使用 intel 语法                                                  |
| -masm=att                       | 汇编代码使用 att 语法                                                    |
| -masm=gnu                       | 汇编代码使用 gnu 语法                                                    |
| -masm=auto                      | 汇编代码使用 auto 语法                                                   |
| -masm=rdi                       | 汇编代码使用 rdi 语法                                                    |
| -masm=ms                        | 汇编代码使用 ms 语法                                                     |
| -masm=go                        | 汇编代码使用 go 语法                                                     |
| -masm=arm                       | 汇编代码使用 arm 语法                                                    |
| -masm=arm64                     | 汇编代码使用 arm64 语法                                                  |
| -fverbose-asm                   | 详细的汇编代码                                                           |
| -fdiagnostics-color=always      | 高亮错误信息                                                             |
| -E                              | 预处理                                                                   |
| -S                              | 编译                                                                     |
| -c                              | 汇编                                                                     |
| -o                              | 链接                                                                     |
| -O0                             | 不优化, 默认的优化选项，减少编译时间和生成完整的调试信息                 |
| -O                              | 不优化                                                                   |
| -O1                             | 尝试减少代码段大小和优化程序的执行时间                                   |
| -O2                             | 牺牲了更多编译时间，但提高了程序的性能                                   |
| -O3                             | 在-O2 的基础上，level 3 的级别优化                                       |
| -Og                             | 优化调试信息。相对于-O0 生成的调试信息，-Og 是为了能够生成更好的调试信息 |
| -Os                             | 优化生成的目标文件的大小。-Os 是基于-O2 的优化选项                       |
| -Oall                           | 优化                                                                     |
| -Ofast                          | 为了提高程序的执行速度，GCC 可以无视严格的语言标准                       |
| -Wall                           | 打开所有警告                                                             |
| -Werror                         | 把警告当作错误                                                           |
| -Wextra                         | 打开额外的警告                                                           |
| -Wpedantic                      | 打开标准警告                                                             |
| -Wno-                           | 关闭某个警告                                                             |

## 编译基础

### 预处理

from file.c -> file.i

```bash
gcc -E file.c -o file.i
```

### 编译

from file.i -> file.s

```bash
gcc -S file.i -o file.s
```

### 汇编

from file.s -> file.o

```bash
gcc -c file.s -o file.o
```

### 链接

from file.o -> file

```bash
gcc file.o -o file
```

[//begin]: # "Autogenerated link references for markdown compatibility"
[文件后缀含义]: ../others/文件后缀含义.md "文件后缀含义"
[//end]: # "Autogenerated link references"