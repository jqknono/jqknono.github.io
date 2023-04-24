# cpp_string

## 格式化

<!-- TODO: C++字符串格式化 -->

## 字符串前缀

| 前缀                                                   | 含义              |
| ------------------------------------------------------ | ----------------- |
| "s-char-sequence"                                      | (1)               |
| L"s-char-sequence"                                     | (2)               |
| u8"s-char-sequence"                                    | (3) (since C++11) |
| u"s-char-sequence"                                     | (4) (since C++11) |
| U"s-char-sequence"                                     | (5) (since C++11) |
| prefix(optional) R"delimiter(raw_characters)delimiter" | (6) (since C++11) |

1. 窄多字节字符串文字。不带前缀的字符串字面量的类型是 const char[N]，其中 N 是执行窄编码的代码单元中字符串的大小，包括空终止符。
1. 宽字符串文字。 L"..." 字符串文字的类型是 const wchar_t[N]，其中 N 是执行宽度编码的代码单元中字符串的大小，包括空终止符。
1. UTF-8 编码的字符串文字。 u8"..." 字符串文字的类型是 const char[N] (C++20 前)const char8_t[N] (C++20 起)，其中 N 是 UTF-8 中字符串的大小包括空终止符的代码单元。
1. UTF-16 编码的字符串文字。 u"..." 字符串文字的类型是 const char16_t[N]，其中 N 是 UTF-16 代码单元中的字符串大小，包括空终止符。
1. UTF-32 编码的字符串文字。 U"..." 字符串文字的类型是 const char32_t[N]，其中 N 是 UTF-32 代码单元中字符串的大小，包括空终止符。
1. 原始字符串文字。用于避免转义任何字符。分隔符之间的任何内容都成为字符串的一部分。前缀（如果存在）与上述含义相同。
