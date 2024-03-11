---
layout: page
title: copilot的用法分享
published: true
categories: 评测
tags: 
  - 评测
  - AI
date: 2023-05-06 16:14:26
---

[视频分享](https://qingteng.feishu.cn/minutes/obcnj9f86gvr3o863mb88p99)

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [Copilot Labs 能力](#copilot-labs-能力)
- [Copilot 是什么](#copilot-是什么)
- [理解](#理解)
- [建议](#建议)
- [调试](#调试)
- [检视](#检视)
- [重构](#重构)
- [文档](#文档)
- [使用 Custom 扩展 Copilot 边界](#使用-custom-扩展-copilot-边界)
- [获得更专业的建议](#获得更专业的建议)
- [纯文本的建议](#纯文本的建议)
- [设置项](#设置项)
- [数据安全](#数据安全)
- [常见问题](#常见问题)

<!-- /TOC -->

CoPilot 是一款基于机器学习的代码补全工具，它可以帮助你快速编写代码，提高编码效率。

## Copilot Labs 能力

| 能力                   | 说明                   | 备注                                                     | example                                                           |
| ---------------------- | ---------------------- | -------------------------------------------------------- | ----------------------------------------------------------------- |
| `Explain`              | 生成代码片段的解释说明 | 有高级选项定制提示词, 更清晰说明自己的需求               | ![picture 1](https://s2.loli.net/2023/05/06/BHCu27UmD19Nwit.png)  |
| `Show example code`    | 生成代码片段的示例代码 | 有高级选项定制                                           | ![picture 2](https://s2.loli.net/2023/05/06/9cCew5yvSjrX2DF.png)  |
| `Language Translation` | 生成代码片段的翻译     | 此翻译是基于编程语言的翻译, 比如*C++ -> Python*          | ![picture 3](https://s2.loli.net/2023/05/06/1SIolbdY3fCimPx.png)  |
| `Readable`             | 提高一段代码的可读性   | 不是简单的格式化, 是真正的可读性提升                     | ![picture 4](https://s2.loli.net/2023/05/06/pYxH6isGqr7Sh14.png)  |
| `Add Types`            | 类型推测               | 将自动类型的变量改为明确的类型                           | ![picture 5](https://s2.loli.net/2023/05/06/rDeh9dtjbPHl8yG.png)  |
| `Fix bug`              | 修复 bug               | 修复一些常见的 bug                                       | ![picture 6](https://s2.loli.net/2023/05/06/h8AfL65qSOn9BJ7.png)  |
| `Debug`                | 使代码更容易调试       | 增加打印日志, 或增加临时变量以用于断点                   | ![picture 7](https://s2.loli.net/2023/05/06/adW8QO3yfTZpx5o.png)  |
| `Clean`                | 清理代码               | 清理代码的无用部分, 注释/打印/废弃代码等                 | ![picture 8](https://s2.loli.net/2023/05/06/kGdpSLoOtJuBvmf.png)  |
| `List steps`           | 列出代码的步骤         | 有的代码的执行严格依赖顺序, 需要明确注释其执行顺序       | ![picture 9](https://s2.loli.net/2023/05/06/gXM19C2NBVYpIKO.png)  |
| `Make robust`          | 使代码更健壮           | 考虑边界/多线程/重入等                                   | ![picture 10](https://s2.loli.net/2023/05/06/eMawki5IySGKf4U.png) |
| `Chunk`                | 将代码分块             | 一般希望函数有效行数<=50, 嵌套<=4, 扇出<=7, 圈复杂度<=20 | ![picture 11](https://s2.loli.net/2023/05/06/x7LRskn52iTY8b1.png) |
| `Document`             | 生成代码的文档         | 通过写注释生成代码, 还可以通过代码生成注释和文档         | ![picture 12](https://s2.loli.net/2023/05/06/HPJkC7zp518w3fI.png) |
| `Custom`               | 自定义操作             | 告诉 copilot 如何操作你的代码                            | ![picture 13](https://s2.loli.net/2023/05/06/ro3ziwAekLS7qyt.png) |

## Copilot 是什么

[官网](https://github.com/features/copilot/)的介绍简单明了: **Your AI pair programmer** -- 你的结对程序员

> [结对编程](https://zh.wikipedia.org/wiki/%E7%BB%93%E5%AF%B9%E7%BC%96%E7%A8%8B): 是一种敏捷软件开发的方法，两个程序员在一个计算机上共同工作。一个人输入代码，而另一个人审查他输入的每一行代码。输入代码的人称作驾驶员，审查代码的人称作观察员（或导航员）。两个程序员经常互换角色。在结对编程中，观察员同时考虑工作的战略性方向，提出改进的意见，或将来可能出现的问题以便处理。这样使得驾驶者可以集中全部注意力在完成当前任务的“战术”方面。观察员当作安全网和指南。结对编程对开发程序有很多好处。比如增加纪律性，写出更好的代码等。

Copilot 通过以下方式参与编码工作, 实现扮演结对程序员这一角色.

- [理解](#理解)
- [建议](#建议)
- [调试](#调试)
- [检视](#检视)
- [重构](#重构)
- [文档](#文档)

## 理解

Copilot 是个大语言模型, 它不能理解我们的代码, 我们也不能理解 Copilot 的模型, 这里的理解是一名程序员与一群程序员之间的相互理解. 大家基于一些共识而一起写代码.

![picture 14](https://s2.loli.net/2023/05/06/6kDSKoqdOQuB4EC.png)

Copilot 搜集信息以理解上下文, 信息包括:

- 正在编辑的代码
- 关联文件
- IDE 已打开文件
- 库地址
- 文件路径

Copilot 不仅仅是通过一行注释去理解, 它搜集了足够多的上下文信息来理解下一步将要做什么.

## 建议

| 整段建议                                                          | inline 建议                                                       |
| ----------------------------------------------------------------- | ----------------------------------------------------------------- |
| ![picture 15](https://s2.loli.net/2023/05/06/DK6r2FiIwCA5sWV.png) | ![picture 16](https://s2.loli.net/2023/05/06/m4vyoeIOGscfHla.png) |

最为人所熟知的获取建议方式是**写注释而不是写代码**, 业务逻辑主要在注释中体现, 以此获得整段的建议. 但这可能会造成注释冗余的问题, 注释不是越多越好, 注释可以帮助理解, 但它不是代码主体. 良好的代码没有注释也清晰明了, 依靠的是合适的命名, 合理的设计以及清晰的逻辑. 使用 inline 建议时, 只要给出合适的变量名/函数名/类名, Copilot 总能给出合适的建议.

除了合适的外部输入外, Copilot 也支持支持根据已有的代码片段给出建议, `Copilot Labs`->`Show example code`可以帮助生成指定函数的示例代码, 只需要选中代码, 点击`Show example code`.

`Ctrl`+`Enter`, 总是能给人非常多的启发, 我创建了三个文件, 一个 main.cpp 空文件, 一个 calculator.h 空文件, 在 calculator.cpp 中实现"加"和"减", Copilot 给出了如下建议内容:

1. 添加"乘"和"除"的实现
1. 在 main 中调用"加减乘除"的实现
1. calculator 静态库的创建和使用方法
1. main 函数的运行结果, 并且结果正确
1. calculator.h 头文件的建议内容
1. g++编译命令
1. gtest 用例
1. CMakeLists.txt 的内容, 并包含测试
1. objdump -d main > main.s 查看汇编代码, 并显示了汇编代码
1. ar 查看静态库的内容, 并显示了静态库的内容

默认配置下, 每次敲击`Ctrl`+`Enter`展示的内容差异很大, 无法回看上次生成的内容, 如果需要更稳定的生成内容, 可以设置`temperature`的值[0, 1]. 值越小, 生成的内容越稳定; 值越大, 生成的内容越难以捉摸.  
以上建议内容远超了日常使用的一般建议内容, 可能是由于工程确实过于简单, 一旦把编译文件, 头文件写全, 建议就不会有这么多了, 但它仍然常常具有很好的启发作用.

使用 Copilot 建议的[快捷键](https://docs.github.com/en/copilot/configuring-github-copilot/configuring-github-copilot-in-your-environment?tool=vscode#keyboard-shortcuts-for-github-copilot-2)

| Action                 | Shortcut       | Command name                             |
| :--------------------- | :------------- | :--------------------------------------- |
| 接受 inline 建议       | `Tab`          | editor.action.inlineSuggest.commit       |
| 忽略建议               | `Esc`          | editor.action.inlineSuggest.hide         |
| 显示下一条 inline 建议 | `Alt`+`]`      | editor.action.inlineSuggest.showNext     |
| 显示上一条 inline 建议 | `Alt`+`[`      | editor.action.inlineSuggest.showPrevious |
| 触发 inline 建议       | `Alt`+`\`      | editor.action.inlineSuggest.trigger      |
| 在单独面板显示更多建议 | `Ctrl`+`Enter` | github.copilot.generate                  |

## 调试

一般两种调试方式, 打印和断点.

- Copilot 可以帮助自动生成打印代码, 根据上下文选用格式的打印或日志.
- Copilot 可以帮助修改已有代码结构, 提供方便的断点位置. 一些嵌套风格的代码难以打断点, Copilot 可以直接修改它们.

Copilot Labs 预置了以下功能:

- **Debug**, 生成调试代码, 例如打印, 断点, 以及其他调试代码.

## 检视

检视是相互的, 我们和 copilot 需要经常相互检视, 不要轻信快速生成的代码.

Copilot Labs 预置了以下功能:

- **Fix bug**, 直接修复它发现的 bug, 需要先保存好自己的代码, 仔细检视 Copilot 的修改.
- **Make robust**, 使代码更健壮, Copilot 会发现未处理的情况, 生成改进代码, 我们应该受其启发, 想的更缜密一些.

## 重构

Copilot Labs 预置了以下功能:

- **Readable**, 提高可读性, 真正的提高可读性, 而不是简单的格式化, 但是要务必小心的检视 Copilot 的修改.
- **Clean**, 使代码更简洁, 去除多余的代码.
- **Chunk**, 使代码更易于理解, 将代码分块, 将一个大函数分成多个小函数.

## 文档

Copilot Labs 预置了以下功能:

- **Document**, 生成文档, 例如函数注释, 以及其他文档.

## 使用 Custom 扩展 Copilot 边界

`Custom`不太起眼, 但它让 Copilot 具有无限可能. 我们可以将它理解为一种新的编程语言, 这种编程语言就是英语或者中文.

你可以通过 `Custom` 输入

- `移除注释代码`  
  ![picture 17](https://s2.loli.net/2023/05/06/zi9xnmraVTNCGW3.png)

- `增加乘除的能力`  
  ![picture 18](https://s2.loli.net/2023/05/06/W32hnFydZvkPltc.png)

- `改写为go`  
  ![picture 19](https://s2.loli.net/2023/05/06/9p1yRdjJacEOBDx.png)

- `添加三角函数计算`  
  ![picture 20](https://s2.loli.net/2023/05/06/QX6zJDxjhnvKwmL.png)

- `添加微分计算`, 中文这里不好用了, 使用 `support calculate differential`, 在低温模式时, 没有靠谱答案, 高温模式时, 有几个离谱答案.

在日常工作中, 随时可以向 Copilot 提出自己的需求, 通过 `Custom` 能力, 可以让 Copilot 帮助完成许多想要的操作.

一些例子:

| prompts                            | 说明               |
| ---------------------------------- | ------------------ |
| `generate the cmake file`          | 生成 cmake 文件    |
| `generate 10 test cases for tan()` | 生成 10 个测试用例 |
| `format like google style`         | 格式化代码         |
| `考虑边界情况`                     | 考虑边界情况       |
| `确认释放内存`                     | 确认释放内存       |

`Custom` 用法充满想象力, 但有时也不那么靠谱, 建议使用前保存好代码, 然后好好检视它所作的修改.

## 获得更专业的建议

给 Copilot 的提示越清晰, 它给的建议越准确, 专业的提示可以获得更专业的建议.
许多不合适的代码既不影响代码编译, 也不影响业务运行, 但影响可读性, 可维护性, 扩展性, 复用, 这些特性也非常重要, 如果希望获得更专业的建议, 我们最好了解一些最佳实践的英文名称.

- 首先是使用可被理解的英文, 可以通过看开源项目学习英语.
- [命名约定](https://github.com/kettanaito/naming-cheatsheet), 命名是概念最基础的定义, 好的命名可以避免产生歧义, 避免阅读者陷入业务细节, 从而提高代码的可读性, 也是一种最佳实践.
  - 通常只需要一个合理的变量名, Copilot 就能给出整段的靠谱建议.
- [设计模式列表](https://en.wikipedia.org/wiki/Software_design_pattern), 设计模式是一种解决问题的模板, 针对不同问题合理取舍[SOLID](https://en.wikipedia.org/wiki/SOLID)设计基本原则, 节省方案设计时间, 提高代码的质量.
  - 只需要写出所需要的模式名称, Copilot 就能生成完整代码片段.
- [算法列表](https://en.wikipedia.org/wiki/List_of_algorithms), 好的算法是用来解决一类问题的高度智慧结晶, 开发者需自行将具体问题抽象, 将数据抽象后输入到算法.
  - 算法代码通常是通用的, 只需要写出算法名称, Copilot 就能生成算法代码片段, 并且 Copilot 总是能巧妙的将上下文的数据结构合理运用到算法中.

## 纯文本的建议

| en                                                                                                                                                                                                                                                                                                           | zh                                                                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GitHub Copilot uses the OpenAI Codex to suggest code and entire functions in real-time, right from your editor.                                                                                                                                                                                              | GitHub Copilot 使用 OpenAI Codex 在编辑器中实时提供代码和整个函数的建议。                                                                                                                                     |
| Trained on billions of lines of code, GitHub Copilot turns natural language prompts into coding suggestions across dozens of languages.                                                                                                                                                                      | 通过数十亿行代码的训练，GitHub Copilot 将自然语言提示转换为跨语言的编码建议。                                                                                                                                 |
| Don't fly solo. Developers all over the world use GitHub Copilot to code faster, focus on business logic over boilerplate, and do what matters most: building great software.                                                                                                                                | 不要孤军奋战。世界各地的开发人员都在使用 GitHub Copilot 来更快地编码，专注于业务逻辑而不是样板代码，并且做最重要的事情：构建出色的软件。                                                                      |
| Focus on solving bigger problems. Spend less time creating boilerplate and repetitive code patterns, and more time on what matters: building great software. Write a comment describing the logic you want and GitHub Copilot will immediately suggest code to implement the solution.                       | 专注于解决更大的问题。花更少的时间创建样板和重复的代码模式，更多的时间在重要的事情上：构建出色的软件。编写描述您想要的逻辑的注释，GitHub Copilot 将立即提供代码以实现该解决方案。                             |
| Get AI-based suggestions, just for you. GitHub Copilot shares recommendations based on the project's context and style conventions. Quickly cycle through lines of code, complete function suggestions, and decide which to accept, reject, or edit.                                                         | 获得基于 AI 的建议，只为您。GitHub Copilot 根据项目的上下文和风格约定共享建议。快速循环代码行，完成函数建议，并决定接受，拒绝或编辑哪个。                                                                     |
| Code confidently in unfamiliar territory. Whether you’re working in a new language or framework, or just learning to code, GitHub Copilot can help you find your way. Tackle a bug, or learn how to use a new framework without spending most of your time spelunking through the docs or searching the web. | 在不熟悉的领域自信地编码。无论您是在新的语言或框架中工作，还是刚刚开始学习编码，GitHub Copilot 都可以帮助您找到自己的方式。解决 bug，或者在不花费大部分时间在文档或搜索引擎中寻找的情况下学习如何使用新框架。 |

这些翻译都由 Copilot 生成, 不能确定这些建议是基于模型生成, 还是基于翻译行为产生. 事实上你在表的`en`列中写的任何英语内容, 都可以被 Copilot 翻译(生成)到`zh`列中的内容.

![picture 21](https://s2.loli.net/2023/05/06/qMtGlBIr1ofxp35.gif)

## 设置项

客户端设置项

| 设置项             | 说明                    | 备注                                                                  |
| ------------------ | ----------------------- | --------------------------------------------------------------------- |
| temperature        | 采样温度                | 0.0 - 1.0, 0.0 生成最常见的代码片段, 1.0 生成最不常见更随机的代码片段 |
| length             | 生成代码建议的最大长度  | 默认 500                                                              |
| inlineSuggestCount | 生成行内建议的数量      | 默认 3                                                                |
| listCount          | 生成建议的数量          | 默认 10                                                               |
| top_p              | 优先展示概率前 N 的建议 | 默认展示全部可能的建议                                                |

[个人账户设置](https://github.com/settings/copilot)有两项设置, 一个是版权相关, 一个是隐私相关.

- 是否使用开源代码提供建议, 主要用于规避 Copilot 生成的代码片段中的版权问题, 避免开源协议限制.
- 是否允许使用个人的代码片段改进产品, 避免隐私泄露风险.

## 数据安全

Copilot 的信息收集

- 商用版
  - 功能使用信息, 可能包含个人信息
  - 搜集代码片段, 提供建议后立刻丢弃, **不保留任何代码片段**
  - 数据共享, GitHub, Microsoft, OpenAI
- 个人版
  - 功能使用信息, 可能包含个人信息
  - 搜集代码片段, 提供建议后, 根据个人 telemetry 设置, 保留或丢弃
  - 代码片段包含, 正在编辑的代码, 关联文件, IDE 已打开文件, 库地址, 文件路径
  - 数据共享, GitHub, Microsoft, OpenAI
  - 代码数据保护, 1. 加密. 2. Copilot 团队相关的 Github/OpenAI 的部分员工可看. 3. 访问时需基于角色的访问控制和多因素验证
  - 避免代码片段被使用(保留或训练), 1. [设置](https://github.com/settings/copilot) 2. 联系 [Copilot 团队](https://support.github.com/request)
  - 私有代码是否会被使用? 不会.
  - 是否会输出个人信息(姓名生日等)? 少见, 还在改进.
- [详细隐私声明](https://docs.github.com/en/site-policy/privacy-policies/)

## 常见问题

- Copilot 的训练数据, 来自 Github 的公开库.
- Copilot 写的代码完美吗? 不一定.
- 可以为新平台写代码吗? 暂时能力有限.
- 如何更好的使用 Copilot? 拆分代码为小函数, 用自然语言描述函数的功能, 以及输入输出, 使用有具体意义的变量名和函数名.
- Copilot 生成的代码会有 bug 吗? 当然无法避免.
- Copilot 生成的代码可以直接使用吗? 不一定, 有时候需要修改.
- Copilot 生成的代码可以用于商业项目吗? 可以.
  - Copilot 生成的代码属于 Copilot 的知识产权吗? 不属于.
  - Copilot 是从训练集里拷贝的代码吗? Copilot 不拷贝代码, 极低概率会出现超过 150 行代码能匹配到训练集, 以下两种情况会出现
    - 在上下文信息非常少时
    - 是通用问题的解决方案
  - 如何避免与公开代码重复, 设置[filter](https://docs.github.com/en/copilot/configuring-github-copilot/configuring-github-copilot-settings-on-githubcom)  
    ![picture 22](https://s2.loli.net/2023/05/06/JiK8rH4sbAXFLIQ.png)
- 如何正确的使用 Copilot 生成的代码? 1. 自行测试/检视生成代码; 2. 不要在检视前自动编译或运行生成的代码.
- Copilot 是否在每种自然语言都有相同的表现? 最佳表现是英语.
- Copilot 是否会生成冒犯性内容? 已有过滤, 但是不排除可能出现.
