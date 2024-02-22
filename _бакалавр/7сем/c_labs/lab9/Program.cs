using System;

namespace lab9
{
    class Program
    {
        static void Main(string[] args)
        {
            // заполняем базу
            Base b = new Base();

            // сохраняем в файл
            b.write();
        }
    }
}

