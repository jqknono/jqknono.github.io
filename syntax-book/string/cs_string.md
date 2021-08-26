# 字符串

## 格式化基本语法

`{index[,alignment][:formatstring]}`

`index`  
The zero-based index of the argument whose string representation is to be included at this position in the string. If this argument is null, an empty string will be included at this position in the string.

`alignment`  
Optional. A signed integer that indicates the total length of the field into which the argument is inserted and whether it is right-aligned (a positive integer) or left-aligned (a negative integer). If you omit alignment, the string representation of the corresponding argument is inserted in a field with no leading or trailing spaces.

If the value of alignment is less than the length of the argument to be inserted, alignment is ignored and the length of the string representation of the argument is used as the field width.

`formatString`  
Optional. A string that specifies the format of the corresponding argument's result string. If you omit formatString, the corresponding argument's parameterless ToString method is called to produce its string representation. If you specify formatString, the argument referenced by the format item must implement the IFormattable interface.

C#字符串有许多构建方法, 本文只推荐最优的一种, 其它方法只需看得懂, 不需要去写.

- 短字符串, 10k字符(不严谨)以下都可以使用:

```cs
int num = 123;
string str = $"{num,10:x8}" + $"{num,-10:x8}";
Console.WriteLine(str);
```

- 长字符串使用[StringBuilder](https://docs.microsoft.com/en-us/dotnet/api/system.text.stringbuilder?view=net-5.0)

## 格式化参数(formatString)

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

### 自己实现格式化

<https://docs.microsoft.com/en-us/dotnet/api/system.iformattable?view=net-5.0>
