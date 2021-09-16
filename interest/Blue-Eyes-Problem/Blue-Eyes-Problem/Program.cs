using System;
using System.Collections.Generic;
using System.Linq;

namespace BlueSEyesProblem
{
    public enum EyeColorEnum { Blue, Brown, Undefined }

    public class Knowledge
    {
        public int Day = 0;

        public List<People> KnownPeoples = new List<People>();

        public int? BlueEyeNum;

        public int? BrownEyeNum;

        public override bool Equals(object obj)
        {
            bool equals = false;
            Knowledge knowledge = obj as Knowledge;
            equals = KnownPeoples.SequenceEqual(knowledge.KnownPeoples)
                     && BlueEyeNum == knowledge.BlueEyeNum
                     && BrownEyeNum == knowledge.BrownEyeNum;

            return equals;
        }

        public override int GetHashCode()
        {
            return this.KnownPeoples.GetHashCode();
        }
    }

    /// <summary>
    /// The private means what the people know,
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
                //Console.Write($"Day\t{commonKnowledge.Day}\t:\t");
                //Console.WriteLine($"Common Knowledge: Blue num should be {commonKnowledge.BlueEyeNum} ");
                Console.WriteLine($"Mutual Knowledge: NO. {Index} thinks blue num should be {mutualKnowledge.BlueEyeNum} ");
                Console.WriteLine();
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
            Console.WriteLine();
        }

        public override bool Equals(object obj)
        {
            bool equal = true;

            if (!(obj is People people))
            {
                return false;
            }
            if (people.Index != 0)
            {
                equal = this.Index == people.Index && this.EyeColor == people.EyeColor;
            }
            return equal;
        }

        public override int GetHashCode()
        {
            return this.Index.GetHashCode();
        }
    }

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

            Console.WriteLine();
            Console.WriteLine("Total population:");
            int totalNum = int.Parse(Console.ReadLine());

            Console.WriteLine("Total blue  population:");
            int blueEyeNum = int.Parse(Console.ReadLine());

            Random random = new Random();
            TotalPeoples = new List<People>();
            for (int index = 1; index <= totalNum; index++)
            {
                TotalPeoples.Add(new People(index));
            }

            List<int> blueIndex = new List<int>();
            for (int num = 0; num < blueEyeNum; num++)
            {
                int index = 0;
                while (blueIndex.Contains(index))
                {
                    index = random.Next(1, totalNum);
                }
                blueIndex.Add(index);
                TotalPeoples[index].EyeColor = EyeColorEnum.Blue;
            }

            // Initial people's mutual knowledge
            foreach (People people in TotalPeoples)
            {
                Knowledge knowledge = new Knowledge()
                {
                    BlueEyeNum = 0,
                    BrownEyeNum = 0,
                    KnownPeoples = TotalPeoples.FindAll(x => x.Index != people.Index)
                };
                TotalPeoples.ForEach(x =>
                {
                    if (x.Index != people.Index)
                    {
                        if (x.EyeColor == EyeColorEnum.Blue)
                            knowledge.BlueEyeNum++;
                        else
                            knowledge.BrownEyeNum++;
                    }
                });
                people.InitialMutualKnowledge(knowledge);
            }

            // new information input: blue eye exits
            CommonKnowledge = new Knowledge()
            {
                BlueEyeNum = 1
            };

            InputCommonKnowledge(CommonKnowledge);

            Console.Read();
        }

        private static void InputCommonKnowledge(Knowledge commonKnowledge)
        {
            commonKnowledge.Day++;
            Console.WriteLine($"\r\n#####\t\tDay {commonKnowledge.Day}\t\t#####");

            //Console.Write($"Day\t{commonKnowledge.Day}\t:\t");
            Console.WriteLine($"Common Knowledge: The Blue num should be {commonKnowledge.BlueEyeNum}\r\n");

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
}
