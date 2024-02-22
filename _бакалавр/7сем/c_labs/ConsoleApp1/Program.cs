using System;

namespace ConsoleApp1{
    internal class Program{

        static int a = 0;
        static float b = 0;
        static string rezS;
        static void Main(string[] args) {

            Console.WriteLine("=======================================================");
            Console.WriteLine("================= Приложение калькулятор ==============");
            Console.WriteLine("=======================================================");

            bool isExit = false;
            do {
                string c;
                Console.Write("Введите первое число: ");
                c = Console.ReadLine();
                int.TryParse(c, out a);
                Console.Write("Введите второе число: ");
                c = Console.ReadLine();
                float.TryParse(c, out b);
                Console.Write("Введите выполняемую операцию (+-*/): ");
                c = Console.ReadLine();
                Console.Write("Результат: ");

                switch (c) {
                    case "+":
                        rezS = a + "+" + b + "=" + (a + b);
                        break;
                    case "-":
                        rezS = a + "-" + b + "=" + (a - b);
                        break;
                    case "*":
                        rezS = a + "*" + b + "=" + (a * b);
                        break;
                    case "/":
                        if (b == 0) {
                            rezS = "Деление на ноль!";
                        } else {
                            rezS = a + "/" + b + "=" + (a / b);
                        }
                        break;
                }
                Console.WriteLine(rezS);

                Console.WriteLine("Для выхода введите 'exit', для продолжения нажмите Enter");
                isExit =  (0 == String.Compare("exit", Console.ReadLine()));
            } while (!isExit);
            

        }
    }
}
