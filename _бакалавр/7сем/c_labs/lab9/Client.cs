using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab9
{
    internal class Client
    {

        public string name { get; set; }
        public string address { get; set; }
        public int discount { get; set; }

        public Client()
        {
            Console.WriteLine("  Создание нового клиента: ");
            Console.WriteLine("    Введите имя: ");
            this.name = Console.ReadLine();

            Console.WriteLine("    Введите Адрес: ");
            this.address = Console.ReadLine();


            Console.Write("    Введите Скидку (0-99):");
            int balance = 0;
            while (!int.TryParse(Console.ReadLine(), out balance) || balance < 0|| balance > 99)
            {
                Console.WriteLine("Введено не корректное число!");
            }
            this.discount = balance;

            Console.WriteLine("  Новый клиент создан: " + name
                + " Адрес: " + address + " Скидка: " + balance);
        }
    }
}
