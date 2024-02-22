using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab9
{
    internal class OrderLine
    {
        public int count { get; set; }
        public Product product { get; set; }

        public OrderLine(int count, Product product)
        {

            Console.WriteLine("      Пункт заказа: кол-во= " + count + " Товар=" + product.name + ": ");
            this.count = count;
            this.product = product;
        }
    }
}
