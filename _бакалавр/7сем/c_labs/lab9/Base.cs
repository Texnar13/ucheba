using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Text.Json;
using System.IO;
using System.Diagnostics;
using System.Xml.Linq;
using System.Xml.Serialization;
using System.Runtime.Serialization;


namespace lab9
{
    internal class Base
    {
        List<Order> orders = new List<Order>();
        List<Product> products = new List<Product>();
        public Base()
        {
            Console.WriteLine("Создание базы товаров: ");

            products.Add(new Product("Банан", 1));
            products.Add(new Product("Арбуз", 5));
            products.Add(new Product("Баклажан", 12));
            products.Add(new Product("Белый хлеб", 11));
            products.Add(new Product("Икра белая", 10));
            products.Add(new Product("Виноград", 6));
            Init();
        }

        public void Init()
        {
            int id = 0;
            Random random = new Random();

            int count = random.Next(2, 4);
            Console.WriteLine("Создание базы клиентов ("+ count+"шт.)");

            for (int i = 0; i < count; i++)
            {

                Client cl = new Client();

                
                var or = new Order(++id, cl);

                for (int j = 0; j < random.Next(1, 3); j++)
                {
                    OrderLine ol = new OrderLine(random.Next(1, 10), products[random.Next(products.Count)]);
                    or.AddOrderLine(ol);
                }

                orders.Add(or);
            }

        }

        // сохранение в файл
        public void write()
        {
            Console.WriteLine();

            // сериализация в джсон 
            Console.WriteLine("Сохраняю в файл lab9\\bin\\Debug\\net6.0\\data_json.txt");
            File.WriteAllText("data_json.txt", JsonSerializer.Serialize(orders));
            Console.WriteLine("Сохранено");

        }
    }
}
