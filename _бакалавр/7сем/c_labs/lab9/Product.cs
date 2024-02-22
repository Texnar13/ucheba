using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab9
{
    internal class Product
    {
        public string name { get; }
        public decimal price { get; }

        public Product(string name, decimal price)
        {
            Console.WriteLine("  Создание товара: " + name + " \tПо цене:" + price);

            this.name = name;
            this.price = price;
        }
    }
}
