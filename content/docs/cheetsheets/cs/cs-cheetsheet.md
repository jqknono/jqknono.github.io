---
title: cs-cheetsheet
---

# C#速查

# 字符串

## 格式化

`{index[,alignment][:formatstring]}`

`index`  
The zero-based index of the argument whose string representation is to be included at this position in the string. If this argument is null, an empty string will be included at this position in the string.

`alignment`  
Optional. A signed integer that indicates the total length of the field into which the argument is inserted and whether it is right-aligned (a positive integer) or left-aligned (a negative integer). If you omit alignment, the string representation of the corresponding argument is inserted in a field with no leading or trailing spaces.

If the value of alignment is less than the length of the argument to be inserted, alignment is ignored and the length of the string representation of the argument is used as the field width.

`formatString`  
Optional. A string that specifies the format of the corresponding argument's result string. If you omit formatString, the corresponding argument's parameterless ToString method is called to produce its string representation. If you specify formatString, the argument referenced by the format item must implement the IFormattable interface.

C#字符串有许多构建方法, 本文只推荐最优的一种, 其它方法只需看得懂, 不需要去写.

- 短字符串, 10k 字符(不严谨)以下都可以使用:

```cs
int num = 123;
string str = $"{num,10:x8}" + $"{num,-10:x8}";
Console.WriteLine(str);
```

- 长字符串使用[StringBuilder](https://docs.microsoft.com/en-us/dotnet/api/system.text.stringbuilder?view=net-5.0)

### 格式化参数(formatString)

- 整型和浮点型
  - 标准: <https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings>
  - 自定义: <https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-numeric-format-strings>
- 日期和日期偏移
  - 标准: <https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings>
  - 自定义: <https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings>
- 枚举
  - <https://docs.microsoft.com/en-us/dotnet/standard/base-types/enumeration-format-strings>
- TimeSpan
  - 标准: <https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-timespan-format-strings>
  - 自定义: <https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-timespan-format-strings>

## 字符串前缀

- `$`表示此字符串用到占位, 以大括号包裹引用对象, 实际上大括号里还可以包含一点逻辑处理, 可以使用格式化.

```cs
string myName = "jqknono";
Console.WriteLine($"My name is {myName, -10}");
```

- `@`阻止字符串转义, 做变量标识时无此功能.

```cs
string @name = "jqknono\n";   // 简单的标识符, 不阻止转义
string name = @"jqknono\n";   // 阻止转义
```

扩展阅读: [什么是转义?](https://zh.wikipedia.org/wiki/%E8%BD%AC%E4%B9%89%E5%AD%97%E7%AC%A6), 一句话解释, 纯文本在读取时将其中连续的几个字符序列转换含义, 如`\n`转义后会变为**换行**并不再显示, 未转义则直接显示`\n`.
