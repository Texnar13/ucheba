using System;

namespace _6
{
    class Program
    {
        delegate int MetodDel(int x, string str, bool b);

        static void Main(string[] args)
        {
            MetodDel del = Metod;//экз делегата

            Console.WriteLine($"метод1, соответствующий созданному делегату:\t{del(12, "zazaz", true)}");//выводим metod


            Console.WriteLine($"метод, принимающий разработанный делегат(параметр-делегата - метод1):\t{Metod2(del, 7)}");//выводим metod2 передавая ему делегат
            Console.WriteLine($"метод, принимающий разработанный делегат(параметр-делегата - лямда-выражение:\t{Metod2((int x, string str, bool b) => x + str.Length, 7)}");//выводим metod2 передавая ему лямда-выражение


            Func<int, string, bool, int> dFub = Metod;
            Console.WriteLine($"Обобщенный метод, принимающий разработанный делегат(параметр-делегата - метод1 :{Metod3(dFub, 5)}");//выводим metod3 передавая ему об. делегат
            Console.WriteLine($"метод, принимающий разработанный делегат(параметр-делегата - лямда-выражение:\t{Metod3((x, str, b) => x + str.Length, 5)}");//выводим лямда-выражение


            Console.ReadKey();
        }

        static int Metod(int x, string str, bool b)//первый метод
        {
            int n = 0;
            foreach (char o in str)
                if (o == 'z')
                    n++;

            int M = b ? n + x + str.Length : n + x;
            return M;
        }

        static int Metod2(MetodDel f, int x)//второй метод принимающий в качестве параметра делегат
        {
            return x + f(x, "zez", false); ;
        }

        static int Metod3(Func<int, string, bool, int> F, int x)//третий метод принимающий в качестве параметра обобщенный делегат
        {
            return x + F(x, "zez", false);
        }

    }
}
