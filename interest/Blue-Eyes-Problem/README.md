# Blue-Eyes-Problem

https://blog.jntalent.com/蓝眼人问题/  
有感于袁岚峰的介绍, https://zhuanlan.zhihu.com/p/44581956  
It's not a trick, but a interesting problem.  

题目设定是这样的，一个岛上有100个人，其中有5个棕眼睛，95个蓝眼睛。这个岛有三个奇怪的宗教规则。

1. 他们不能照镜子，不能看自己眼睛的颜色。 2. 他们不能告诉别人对方的眼睛是什么颜色。 3. 一旦有人知道了自己的眼睛颜色，他就必须在当天夜里自杀。 某天，有个旅行者到了这个岛上。由于不知道这里的规矩，所以他在和全岛人一起狂欢的时候，不留神就说了一句话：【你们这里有蓝眼睛的人。】 最后的问题是：假设这个岛上的人足够聪明，每个人都可以做出缜密的逻辑推理。请问这个岛上将会发生什么？ <!--more-->  

首先定性的说, 这个问题的解决方法司空见惯, 那就是<strong>递归</strong>, 这恰恰是代码擅长解决的问题.  
附上袁岚峰的讲解, 大家首先需要对问题本身理解了, 才能看看代码是如何实现的.  

<strong>科技袁人：数学真实惠，一道题就够我做一个暑假了</strong>
<iframe src="//player.bilibili.com/player.html?aid=29527174&amp;cid=51319132&amp;page=1" width="800" height="600" frameborder="no" scrolling="no" allowfullscreen="allowfullscreen"> </iframe>

<strong>科技袁人：什么叫强共识？比如：数学特别有趣</strong>
<iframe src="//player.bilibili.com/player.html?aid=30113899&amp;cid=52488916&amp;page=1" width="800" height="600" frameborder="no" scrolling="no" allowfullscreen="allowfullscreen"> </iframe>


# 代码实现

## 关键是"知识"

人做出推理的依据是知识, 因此需要构造一个知识类, **只有知识的改变才会带来行为的改变**.  
知识类很简单, 主要的知识只有**认识的人的属性**. 它在程序里的角色是`数据`.
```csharp
public class Knowledge
    {
        public int Day = 0;

        public List<People> KnownPeoples = new List<People>();

        // total blue
        public int? BlueEyeNum;

        public int? BrownEyeNum;

        ... ...

    }
```

## 知识会影响行为

要明确的是, 在没有游客到来时, 岛上的知识是没有变化的, 人们过着日复一日的重复生活, 这意味着他们的行为不会有变化.  
而当知识发生变化时, 会发生什么呢? 别忘了, 宗教信仰在每个人身上都预设了一个行为, 那就是**当他们知道自己的眼睛颜色时就要自杀**. 这个行为就是`函数`.  
我们开始构造一个岛上居民的类, 约定`public`表示大家都能通过观察知道的属性, `private`表示只有只有当事人自己知道. 代码中的若干注释均来源于袁岚峰视频讲解的启发, 倘若无法理解, 请先暂且记住, 下一小节会进行解释.

```csharp
/// <summary>
    /// The private means what the people itself know,
    /// public means the other people know.
    /// </summary>
    public class People
    {
        public People(int index)
        {
            Index = index;
        }

        public readonly int Index = 0;

        public EyeColorEnum EyeColor = EyeColorEnum.Brown;

        public bool Dead = false;

        private bool _knowSelfEyeColor = false;

        /// <summary>
        /// If the people know its eyes, it will kill itself.
        /// </summary>
        private bool KnowSelfEyeColor
        {
            get { return _knowSelfEyeColor; }
            set
            {
                _knowSelfEyeColor = value;
                if (_knowSelfEyeColor)
                {
                    Console.WriteLine($"NO. {Index} realizes its eye color...");
                    GoDie();
                }
            }
        }

        /// <summary>
        /// Mutual knowledge, 弱共识
        /// What I thought everyone should know.
        /// Maybe wrong.
        /// </summary>
        private Knowledge mutualKnowledge = new Knowledge();

        public void InitialMutualKnowledge(Knowledge knowledge)
        {
            mutualKnowledge = knowledge;
        }

        public void InputNewCommonKnowledge(Knowledge commonKnowledge, bool showMind = false)
        {
            if (commonKnowledge == null)
                return;

            if (showMind)
            {
                Console.WriteLine($"Mutual Knowledge: NO. {Index} thinks blue num should be {mutualKnowledge.BlueEyeNum} ");
            }

            if (KnowledgeConflict(commonKnowledge))
            {
                // someone has conflict knowledge, 
                // he should be clever enough to know what's new,
                // he should die
                UpdateKnowledge(commonKnowledge);
            }
        }

        /// <summary>
        /// Accept the common knowledge.
        /// Knowledge change will make the current situation change.
        /// </summary>
        /// <param name="commonknowledge"></param>
        private void UpdateKnowledge(Knowledge commonknowledge)
        {
            if (commonknowledge.BlueEyeNum > mutualKnowledge.BlueEyeNum)
            {
                Console.WriteLine("#####");
                Console.WriteLine($"Mutual Knowledge: NO. {Index} thought the others knew the blue num should be {mutualKnowledge.BlueEyeNum}");
                Console.WriteLine($"Common knowledge: NO.{Index} now knows that Blue num is {commonknowledge.BlueEyeNum}");
                Console.WriteLine($"The extra blue eye guy must be me NO. {Index}.");

                KnowSelfEyeColor = true;
            }
        }

        /// <summary>
        /// What I know. The simplest thing by observation.
        /// Always true.
        /// </summary>
        //private List<People> KnownPeoples = new List<People>();

        private bool KnowledgeConflict(Knowledge commonknowledgeInput)
        {
            // how did they conflict
            bool conflictBlue = true;

            if (commonknowledgeInput.BlueEyeNum != null)
            {
                conflictBlue = commonknowledgeInput.BlueEyeNum != mutualKnowledge.BlueEyeNum;
            }

            return conflictBlue;
        }

        /// <summary>
        /// If the people know its eyes, it will kill itself.
        /// </summary>
        private void GoDie()
        {
            this.Dead = true;
            Console.WriteLine($"People NO. {Index} died.");
        }

        ......

    }
```

## 岛上有新知识的输入吗

毫无疑问, 是有的! 而人们必将根据新知识来调整自己的行为.  

### 新知识是什么

倘若岛上只有一个蓝眼人, 他会吃惊, 他竟然才知道岛上有蓝眼人, 以前他并不知道这个知识, 尽管其他人都知道. 新知识会促使唯一的蓝眼人在第一天夜里自杀.  

倘若有两个蓝眼人呢? 第二个蓝眼人B会在第二天吃惊于第一个蓝眼人A竟然还活着, 这意味着蓝眼人不止一个. B以前以为蓝眼人只有一个是A, 而现在他知道并不是, 推理得到的知识绝不会错, 这与他以为大家都知道的东西不一致, 他也将在第二天夜里作出自己的决定.  

AB的知识和其它所有人的知识不一样, 而游客的到来统一了岛上所有居民的知识, 这个最终统一的知识我们称它为"**强共识**".

## 强共识和弱共识

我们下定义, 

  * Mutual knowledge, 弱共识, What I thought everyone should know. 我**以为**大家都知道的知识.
  * Common knowledge, 强共识, What everyone really knows. 所有人**真正**都知道的知识.

游客的输入即是一个强共识, 它改变了一些居民的弱共识, 最终导致蓝眼睛们会推断出自己的眼睛颜色.

# 新知识的输入

为突出重要信息, 本文隐藏了大部分的不重要代码, 有兴趣的可以在本文末查看完整源码.

```csharp
class Program
    {
        /// <summary>
        /// Common knowledge, 强共识
        /// What everyone really knows.
        /// At first, no one knows what anyone else really knows,
        /// that means, there is no common knowledge from the beginning.
        /// It is always true.
        /// </summary>
        public static Knowledge CommonKnowledge;


        /// <summary>
        /// Reality.
        /// </summary>
        public static List<People> TotalPeoples;

        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Console.WriteLine("Mutual Knowledge : What I thought everyone should know.");
            Console.WriteLine("Common Knowledge : What everyone really knows.");
            Console.WriteLine("At first, no one knows what anyone else really knows,");
            Console.WriteLine("that means, there is no common knowledge from the beginning.");
            Console.WriteLine("We assume Common Knowledge is always true, because everyone will behavior base on Common Knowledge.");

            Console.WriteLine("Total population:");
            int totalNum = int.Parse(Console.ReadLine());

            Console.WriteLine("Total blue  population:");
            int blueEyeNum = int.Parse(Console.ReadLine());

            ... ...

            // new information input: blue eye exits
            CommonKnowledge = new Knowledge()
            {
                BlueEyeNum = 1
            };

            InputCommonKnowledge(CommonKnowledge);

            Console.Read();
        }

        // Input common knowledge
        private static void InputCommonKnowledge(Knowledge commonKnowledge)
        {
            commonKnowledge.Day++;
           
            foreach (var people in TotalPeoples)
            {
                people.InputNewCommonKnowledge(CommonKnowledge, true);
            }

            // if nobody dies, the blue num is more than expected
            if (!TotalPeoples.Any(x => x.Dead))
            {
                commonKnowledge.BlueEyeNum++;

                // New common knowledge generated
                InputCommonKnowledge(commonKnowledge);
            }
        }
    }
```

# Github

项目链接
[https://github.com/Jqk-Nono/Blue-Eyes-Problem](https://github.com/Jqk-Nono/Blue-Eyes-Problem)


[可执行文件](https://github.com/Jqk-Nono/Blue-Eyes-Problem/blob/master/Blue-Eyes-Problem.exe)


[关键代码](https://github.com/Jqk-Nono/Blue-Eyes-Problem/blob/master/Blue-Eyes-Problem/Program.cs)
