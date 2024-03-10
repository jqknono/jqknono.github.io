---
title: string
---

# string

谈到字符串, 有两个概念需要区分: 字符(character)与编码(encoding).

- 字符是指计算机中的一个符号, 用于表示一个文本. 比如字母 a, 数字 1, 符号 !, 等等.
- 编码是指将字符转换为二进制的过程. 比如将字符 a 转换为二进制 01100001.

## 字符

不同编程语言中, 字符的位宽不同, 有的是 8 位, 有的是 16 位, 有的是 32 位.

| 语言       | 字符位宽 |
| ---------- | -------- |
| C          | 8        |
| C++        | 8        |
| C#         | 16       |
| go         | 8        |
| Java       | 16       |
| JavaScript | 16       |
| Python     | 16       |
| Swift      | 32       |
| lua        | 8        |

- 存在一些比较特殊的表达, 比如 wchar_t, char16_t, char32_t, 用于表示 16 位, 16 位, 32 位的字符.
- 在 Windows 中, 一个字符(wchar_t)的位宽是 16 位, 一个字符占用两个字节.

## 编码

encoding 是指将字符转换为二进制的过程. 常见的编码有:

| 编码     | 位宽 | 字节序 | 说明                                                                        |
| -------- | ---- | ------ | --------------------------------------------------------------------------- |
| ASCII    | 7    |        |                                                                             |
| UTF-8    | \*   |        | 可变长度, 一般一个字符占用一个字节, 但是有些字符占用多个字节. 是一种前缀码. |
| UTF-16   | 16   |        |                                                                             |
| UTF-16BE | 16   | BE     |                                                                             |
| UTF-16LE | 16   | LE     |                                                                             |
| UTF-32   | 32   |        |                                                                             |
| UTF-32BE | 32   | BE     |                                                                             |
| UTF-32LE | 32   | LE     |                                                                             |

## 字节序(byte order, endian)

字节序是指在多字节的编码中, 字节的排列顺序. 常见的字节序有:

- 大端序: 高位字节在前, 低位字节在后. 比如 0x1234, 大端序为 0x12 0x34.
- 小端序: 低位字节在前, 高位字节在后. 比如 0x1234, 小端序为 0x34 0x12.

## 转义(escape)

在字符串中, 有一些字符是具有特殊含义的, 比如换行符, 回车符, 制表符, 等等. 这些字符在字符串中需要进行转义.
常见的转义字符有:

| 转义字符 | 说明         |
| -------- | ------------ |
| `\n`     | 换行         |
| `\r`     | 回车         |
| `\t`     | 制表         |
| `\0`     | 空           |
| `\r\n`   | 回车换行     |
| `\u`     | Unicode 字符 |
| `\x`     | 十六进制字符 |
| `\\`     | 反斜杠       |
| `\"`     | 双引号       |
| `\'`     | 单引号       |
| `\a`     | 响铃         |
| `\b`     | 退格         |
| `\f`     | 换页         |
| `\v`     | 垂直制表符   |

通常不同语言使用的转义前缀都是`\`

## 原始字符串(raw string, literals)

不同语言避免字符串被转义的方式不同, 比如 C# 中使用 `@` 来表示字符串中的转义字符不进行转义.

- \`: backtick, 反引号
- @: at sign

| 语言       | Raw strings                                |
| ---------- | ------------------------------------------ |
| C          | `R"(strings strings)"`                     |
| C++        | `R"(strings strings)"`                     |
| C#         | `@"(strings strings)"`                     |
| go         | \`strings strings\`                        |
| Python     | `r"strings strings"`                       |
| JavaScript | \`strings with ${expression} string text\` |
| Swift      | `#"(strings strings)"`                     |
| lua        | `[[ (strings strings) ]]`                  |
| PowerShell | `@"(strings strings)"`                     |

## 超长字符串

| language   | Multiline literals        |
| ---------- | ------------------------- |
| C#         | `@""`                     |
| C++        | `R""`                     |
| C          | `R""`                     |
| go         | `""`                      |
| lua        | `[[`                      |
| PowerShell | `@`                       |
| Swift      | `"""(strings strings)"""` |

## 引号和其它符号

存在一些符号修饰字符串, 包括常见的单双引号, 反引号\`等, 它们在不同语言的字符串中有不同含义.

符号名

| 符号 | 中文     | 英文                |
| ---- | -------- | ------------------- |
| `'`  | 单引号   | single quote        |
| `"`  | 双引号   | double quote        |
| `    | 反引号   | backtick            |
| `@`  | at sign  | at sign             |
| `#`  | 井号     | pound sign          |
| `$`  | 美元符号 | dollar sign         |
| `%`  | 百分号   | percent sign        |
| `^`  | 插入符号 | caret               |
| `&`  | 与符号   | ampersand           |
| `*`  | 星号     | asterisk            |
| `(`  | 左圆括号 | left parenthesis    |
| `[`  | 左方括号 | left square bracket |
| `{`  | 左花括号 | left curly bracket  |

## 字符串搜索算法

### wildcard

### regex

## 字符串

在代码中使用字符串, 需要主意我们常常不仅仅只是支持英文的系统, 当需要支持更多语言时, 我们需要使用 [Unicode](https://zh.wikipedia.org/zh-hans/Unicode) 编码.
