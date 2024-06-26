---
layout: blog
categories: 设计
tags: [设计, 设计模式]
published: true
draft: false
title: 集合X统一建模X设计模式
linkTitle: 集合X统一建模X设计模式
date: 2024-06-28 17:23:37 +0800
toc: true
toc_hide: false
math: false
comments: false
giscus_comments: true
hide_summary: false
hide_feedback: false
description: 
weight: 100
---

- [ ] 集合X统一建模X设计模式

一家之言, 欢迎讨论交流.

## 回顾集合

### 集合定义

一个集合，就是将数个对象归类而分成为一个或数个形态各异的大小整体. 一般来讲，集合是具有某种特性的事物的整体，或是一些确认对象的汇集. 构成集合的事物或对象称作“元素”或“成员”. 如果 A 包含 B, 则称 B 是 A 的子集.

- 无序性：一个集合中，每个元素的地位都是相同的，元素之间是无序的. 集合上可以定义序关系，定义了序关系后，元素之间就可以按照序关系排序. 但就集合本身的特性而言，元素之间没有必然的序.
- 互异性：一个集合中，任何两个元素都认为是不相同的，即每个元素只能出现一次. 有时需要对同一元素出现多次的情形进行刻画，可以使用多重集，其中的元素允许出现多次.
- 确定性：给定一个集合，任给一个元素，该元素或者属于或者不属于该集合，二者必居其一，不允许有模棱两可的情况出现.

### 集合的运算

#### 并

两个集合可以相"加". $A$和$B$ 的并集是将$A$和$B$的元素放到一起构成的新集合.  
给定集合$A$和$B$, 定义运算$\cup$如下: $A \cup B = \{e|e \in A \lor e \in B \}$

![集合并](https://s2.loli.net/2024/05/10/CVOa9kBucmPFAjM.png)

#### 交

一个新的集合也可以通过两个集合均有的元素来构造. A 和 B 的交集，写作$A \cap B$，是既属于 A 的、又属于 B 的所有元素组成的集合.

给定集合$A$和$B$, 定义运算$\cap$如下, $A \cap B = \{e|e \in A \land e \in B \}$

![集合交](https://s2.loli.net/2024/05/10/QmwvjBegDU6RiJu.png)

#### 补

两个集合也可以相"减". A 在 B 中的相对补集，$B - A$ . 表示属于 B 的、但不属于 A 的所有元素组成的集合.

给定集合 A B，定义运算-如下：$A - B = \{e| e \in A \land e \notin B\}$.$A-B$称为 B 对于 A 的差集，相对补集或相对余集.

![集合补](https://s2.loli.net/2024/05/10/bOUBTrSPXIuvE4q.png)

#### 运算性质

- 分配律:

  $$
  A \cup (B \cap C) = (A \cup B) \cap (A \cup C)
  $$

  $$
  A \cap (B \cup C) = (A \cap B) \cup (A \cap C)
  $$

- 对偶率:
  $$
  {\overline {A\cup B}}={\overline {A}}\cap {\overline {B}}
  $$
  $$
  {\overline {A\cap B}}={\overline {A}}\cup {\overline {B}}
  $$

## 统一建模语言 UML

### 关系

#### 泛化(Generalization)与实现(Realization)

**泛化(Generalization)**具有方向性, 许多文章这样解释泛化, "父类和子类具有泛化关系", 这种解释过于笼统.  
想要明确泛化的方向特性, 这里同时引入其反义词**特化**/**具体化**, **specialization**/**individualization**  
两相对比可以更清晰的看出,

- 当存在基类`BaseClass`, 继承基类**增加子类**`SubClass`时, 是**特化**行为.
- 当存在具体类`SpecClass`, **增加父类**`GeneralClass`, 使`SpecClass`继承`GeneralClass`, 这种行为才是**泛化**.

实际开发中先写子类再写父类的情况多不多?  
先具体再抽象, 或者先抽象再具体, 都可以交叉存在, 按个人的开发习惯, 怎样方便怎样来, 这点每个人都会有自己的体验.

**实现(Realization)** 是接口和类的关系, 方向性明显, 新增类以实现接口. 那么同样是被实现, 接口和基类有什么区别?

基类如果不是虚基类, 那么有时本身就会实现一些方法, 而接口一定不会含有实现. 存在基类声明了虚函数, 但并不会实现, 这种时候怎么区分它们的用途呢?

在使用上, 接口和基类的区别不便简单总结, 原本想说接口不能用于创建对象, 但在一些函数式编程风格的代码中, 接口和函数都可以成为对象, 有的代码中的基类和接口可以无缝相互切换. 接口总是抽象的, 类通常是具体的, 但类也可以是抽象的. 类通常包含方法的实现, 但也可以不包含. 有的语言通过增加关键字来明确区分这两种类型, 说明它们之间的界限过于模糊以至于需要增加关键字来明确使用场景. 它们之间的区别需要自己多读多写来体会, 下边这些信息或许能给你一些参考.

在 C#和 Java 中, 类仅能继承一个基类, 同时继承/实现多个接口, 作为对比 C++中允许继承多个基类, 其中有什么区别? 为什么较新的语言都不支持多继承?

关于多继承类的缺点, 用复杂来描述其实是给了面子, 我不喜欢这种描述, 毕竟有很多人最爱的就是挑战"复杂", 应该直接的说多继承类就是不合理的设计, 它的继承链极其容易导致冲突. 你可以想象 `A` 继承 `B` 和 `C`, 中间加入了两条关系线, 但实际上除了继承关系, 这其中隐式的加入了一个限制, 那就是 `B` 和 `C` 不得冲突. 小组 `B` 和小组 `C` 原本可以各自独立工作, 而不必相互交换任何信息, 现在因为 A 的继承, `B` 和 `C` 产生了联系, 这种隐含的限制关系增多不会是件好事.

为什么又可以多继承接口? 一般来说, 接口都被希望写的小而精.

> "凡事都应该尽可能的简单, 而不是较为简单".

在许多优秀的开源代码的阅读中, 我们能可以学习到简单的接口的确令人赏心悦目. 一些超大工程的命令行也可以在一版屏幕上全部显示, 这是通过增加命令的层级来实现, 也就是给命令分类, 而不是一股脑全塞入到根命令里. 其实现范式是 `A`实现接口`IX`/`IY`/`IZ`, `B`继承`A`后再另外实现接口`IM`/`IN`. 这样的设计使得代码更容易维护, 也更容易扩展.

如何避免接口漫天飞?

需要理解接口即承诺, 时刻提醒自己接口写完后不可轻易改动, 并且接口必须实现. 继承和实现的类比, 想象继承是树状结构, 寻本溯源时, 仅会有一条路径. 而接口的实现是网状结构, 这种结构更复杂, 你很有可能碰到一个恼人的问题, 在调试时因为实现者对接口类型的转换, 导致迷失在接口的丛林里. 比如`猎豹`实现了`呼吸`/`陆地`继承了`哺乳动物`, `鲸鱼`实现了`呼吸`/`海洋`继承了`哺乳动物`, 开发中的业务仅关注`呼吸`能力, 调试到这段业务中时有可能会忘记原本的对象是什么, 或者本来想调试`鲸鱼`的`呼吸`, 但断点打到这儿发现`猎豹`1 秒呼吸一次, `鲸鱼`1 小时才呼吸一次, 大量的命中都是`猎豹`的, 这时你会发现接口有多么令人讨厌. 有一个解决办法是, 面向数据调试, 给属性添加`getter`/`setter`, 通过属性和调用栈来调试, 这样可能更方便在调试时追踪特定对象.

接口的表现形式有哪些?

接口的内容包括属性和方法, 通常将属性放在独立的类或结构体, 将方法分类放到不同的接口里. 如果方法间关联紧密则放在同一接口, 如果方法间关联不紧密则放在不同接口. 方法之间存在确定性的区别, 就是可以预期某个方法仅是权宜之计, 那么确定的和不确定的方法应该分开放置.

继承与实现在博客系统中的类比, 继承基类视为分类(category), 实现接口视为标签(tag). 一篇博文可以有多个标签, 但只能有一个分类. 分类是强关联, 标签是弱关联. 分类是强耦合, 标签是弱耦合.

#### 依赖(Dependency)与关联(Association)

依赖(Dependency): 依赖关系是一种强联系，特定事物的改变有可能会影响到使用该事物的其他事物. 谨慎的考虑使用依赖, 这是一种约束较强的紧密关系, 有时最初设定"依赖"的目的是为了方便, 但开发中又会常常发现"依赖"会导致一些不便. 比如数据表间的依赖, 字段的依赖, 很多时候其实没有必要创建依赖. 在写入时验证合法性, 还是在使用时验证合法性, 可能大家风格各不相同, 但我们要相信人总是懒惰的, 大家都倾向于滑向简单实现的稳态. 95%的数据校验代码从未触发过错误, 这些代码的真实用途是什么? 在我看它们主要是用来甩锅的.

尽管每个人都会告诉你, 数据校验是必须的, 但当我们以独立开发者创业者或者紧密的小团队的心态去设计代码, 选择相信接口的承诺可以少写很多代码, 提高各种效率. 当然, 涉及打工的工作中的协作时, 选择不信任才是明智的, 这样可以在调试时迅速定位上下游的问题, 也可以在代码变更时快速定位问题.

关联(Association)是一种弱联系, 相较于依赖的紧密关系来说关联是一种弱耦合, 将依赖转换为关联或许可以带来一些好处.

如果没有必要, 就不要创建依赖关系. 怎么判断依赖的必要性? 我们可以根据时间和空间两个纬度去判断,

1. 流程 A 既可以发生流程 B 之前, 也可以发生在 B 之后, 那么流程 A 与 B 之间没有时序依赖.
2. 如果对象 A 消亡时, B 不必然跟随消亡, 那么 A 与 B 没有空间依赖.

关于第二点是很值得讨论的, 判断一个关联到底是强还是弱, 常常很容易从事实变为观点之争. 汽车是否依赖发动机? 被拆掉发动机的汽车是否还是汽车? 即残缺的汽车是汽车吗? 汽车 running 依赖发动机, 不在 running 状态则不依赖发动机, 说明是状态产生依赖. 按照第二点的论断, 发动机的拆除不会导致汽车的消亡, 只会导致 running 状态的消亡, 这才是应该找到的依赖.

#### 聚合(Aggregation)和组合(Composition)

聚合(Aggregation): 聚合用来表示整体与部分之间的关联关系。表示一种弱的‘拥有’关系，成员对象可以脱离整体对象独立存在，两个对象具有各自的生命周期.
组合是一种强的‘拥有’关系，体现了严格的部分和整体的关系，部分和整体的生命周期一样.

这两者的主要区别在于对象生命周期是否一致, 并不太复杂. 如果两个对象生命周期不一致, 那么它们之间是弱耦合.

## 设计模式

### 设计原则

#### 单一职责

一个函数只做一件事, 避免在`get`中`set`, 避免在`set_A`时隐含`set_b`

为了实现这个目标, 需要使动词含义准确, 因此, 动+名的组合会更清晰. 如果不能符合上述要求, 那么一个动+名, 理应可以分解为多个动+名.

单个名词不能满足表达时, 以`动词+大范围+小范围+名词`的方式来表达, 以此来表达更多的信息.

为实现单一原则, 需要满足名词概念的范围尽量没有交集.

#### 开闭原则

对扩展开放, 对修改关闭.

#### 里氏替换

子类可以替换父类

#### 依赖倒置

高层模块不应该依赖底层模块, 二者都应该依赖抽象.

参考[基于接口编程](https://baike.baidu.com/item/%E5%9F%BA%E4%BA%8E%E6%8E%A5%E5%8F%A3%E7%BC%96%E7%A8%8B/621528#:~:text=%E8%80%8C%E2%80%9C%20%E9%9D%A2%E5%90%91%E6%8E%A5%E5%8F%A3%E7%BC%96%E7%A8%8B,%E2%80%9D%E4%B8%AD%E7%9A%84%E2%80%9C%E6%8E%A5%E5%8F%A3%E2%80%9D%E5%8F%AF%E4%BB%A5%E8%AF%B4%E6%98%AF%E4%B8%80%E7%A7%8D%E4%BB%8E%E8%BD%AF%E4%BB%B6%E6%9E%B6%E6%9E%84%E7%9A%84%E8%A7%92%E5%BA%A6%E3%80%81%E4%BB%8E%E4%B8%80%E4%B8%AA%E6%9B%B4%E6%8A%BD%E8%B1%A1%E7%9A%84%E5%B1%82%E9%9D%A2%E4%B8%8A%E6%8C%87%E9%82%A3%E7%A7%8D%E7%94%A8%E4%BA%8E%E9%9A%90%E8%97%8F%E5%85%B7%E4%BD%93%E5%BA%95%E5%B1%82%E7%B1%BB%E5%92%8C%E5%AE%9E%E7%8E%B0%E5%A4%9A%E6%80%81%E6%80%A7%E7%9A%84%E7%BB%93%E6%9E%84%E9%83%A8%E4%BB%B6%E3%80%82%20%E9%9D%A2%E5%90%91%E6%8E%A5%E5%8F%A3%E7%BC%96%E7%A8%8B%20%E2%80%9D%E4%B8%AD%E7%9A%84%E6%8E%A5%E5%8F%A3%E6%98%AF%E4%B8%80%E7%A7%8D%E6%80%9D%E6%83%B3%E5%B1%82%E9%9D%A2%E7%9A%84%E7%94%A8%E4%BA%8E%E5%AE%9E%E7%8E%B0%E5%A4%9A%E6%80%81%E6%80%A7%E3%80%81%E6%8F%90%E9%AB%98%E8%BD%AF%E4%BB%B6%E7%81%B5%E6%B4%BB%E6%80%A7%E5%92%8C%E5%8F%AF%E7%BB%B4%E6%8A%A4%E6%80%A7%E7%9A%84%E6%9E%B6%E6%9E%84%E9%83%A8%E4%BB%B6%EF%BC%8C%E8%80%8C%E5%85%B7%E4%BD%93%E8%AF%AD%E8%A8%80%E4%B8%AD%E7%9A%84%E2%80%9C%E6%8E%A5%E5%8F%A3%E2%80%9D%E6%98%AF%E5%B0%86%E8%BF%99%E7%A7%8D%E6%80%9D%E6%83%B3%E4%B8%AD%E7%9A%84%E9%83%A8%E4%BB%B6%E5%85%B7%E4%BD%93%E5%AE%9E%E6%96%BD%E5%88%B0%E4%BB%A3%E7%A0%81%E9%87%8C%E7%9A%84%E6%89%8B%E6%AE%B5%E3%80%82)

#### 接口隔离

按照功能细分接口

#### 迪米特法则

一个对象应该对其他对象有最少的了解

#### 合成复用

尽量使用合成/聚合, 少用继承

## 总结

根据对集合, 建模和设计模式的理解, 这里推出几个实践经验:

1. 尽量避免复合的强关系, 避免实体间的交集, 如集合运算中的`And`包括取交集和取补集运算.
1. 尽量使用弱关系
   - 优先使用接口而非继承, 接口是一种弱关系, 会使代码更容易扩展.
   - 优先使用关联而非依赖, 依赖关系是一种强关系, 会导致代码的耦合度增加.
   - 优先使用聚合而非组合, 聚合是一种弱关系, 会使代码更容易维护.
1. 避免超大类, 超长函数

## 参考

- [集合(数学)](<https://zh.wikipedia.org/wiki/%E9%9B%86%E5%90%88_(%E6%95%B0%E5%AD%A6)>)
- [统一建模语言](https://zh.wikipedia.org/wiki/%E7%BB%9F%E4%B8%80%E5%BB%BA%E6%A8%A1%E8%AF%AD%E8%A8%80)
