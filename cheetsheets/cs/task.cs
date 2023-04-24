using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                List<Task> tasks = new List<Task>();

                tasks.Add(Task.Run(Noraml_Action));
                tasks.Add(Task.Run(Noraml_Task));
                tasks.Add(Task.Run(Noraml_Func));
                tasks.Add(Task.Run(Noraml_Task_Return));
                tasks.Add(Task.Run(Async_Void_Action_No_Await));
                tasks.Add(Task.Run(Async_Void_Action_With_Await_Exception));
                tasks.Add(Task.Run(Async_Task_With_Await_Exception));

                Task.WaitAll(tasks.ToArray());
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            finally
            {
                Console.WriteLine("All done!");
            }

            Console.ReadLine();
        }

        static void Noraml_Action()
        {
            int i = 10;
            while (i-- > 0)
            {
                Console.WriteLine($"[{MethodBase.GetCurrentMethod().Name}]:{i}");
                Thread.Sleep(TimeSpan.FromSeconds(1));
            }
        }

        static Task Noraml_Task()
        {
            int i = 10;
            while (i-- > 0)
            {
                Console.WriteLine($"[{MethodBase.GetCurrentMethod().Name}]:{i}");
                Thread.Sleep(TimeSpan.FromSeconds(1));
            }

            return Task.CompletedTask;
        }

        static int Noraml_Func()
        {
            int i = 10;
            while (i-- > 0)
            {
                Console.WriteLine($"[{MethodBase.GetCurrentMethod().Name}]:{i}");
                Thread.Sleep(TimeSpan.FromSeconds(1));
            }

            return i;
        }

        static Task<int> Noraml_Task_Return()
        {
            int i = 10;
            while (i-- > 0)
            {
                Console.WriteLine($"[{MethodBase.GetCurrentMethod().Name}]:{i}");
                Thread.Sleep(TimeSpan.FromSeconds(1));
            }

            return Task.FromResult(i);
        }


        // async func内不用await, 会产生warning
        static async void Async_Void_Action_No_Await()
        {
            int i = 10;
            while (i-- > 0)
            {
                Console.WriteLine($"[{MethodBase.GetCurrentMethod().Name}]:{i}");
                Thread.Sleep(TimeSpan.FromSeconds(1));
            }
        }

        /// <summary>
        /// 该异常会导致未处理的异常, 程序退出, finnally不会执行!
        /// </summary>
        /// <exception cref="Exception"></exception>
        static async void Async_Void_Action_With_Await_Exception()
        {
            int i = 5;
            while (i-- > 0)
            {
                Console.WriteLine($"[{MethodBase.GetCurrentMethod().Name}]:{i}");
                await Task.Delay(TimeSpan.FromSeconds(1));
            }
            //throw new Exception($"Exception from [{MethodBase.GetCurrentMethod().Name}]");
        }

        /// <summary>
        /// 异常会被捕捉到, 不影响其它task的执行
        /// </summary>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        static async Task Async_Task_With_Await_Exception()
        {
            int i = 5;
            while (i-- > 0)
            {
                Console.WriteLine($"[{MethodBase.GetCurrentMethod().Name}]:{i}");
                await Task.Delay(TimeSpan.FromSeconds(1));
            }
            // 异常会被捕捉到
            throw new Exception($"Exception from [{MethodBase.GetCurrentMethod().Name}]");
        }
    }
}