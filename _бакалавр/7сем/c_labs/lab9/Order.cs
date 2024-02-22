using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab9
{
    internal class Order
    {
        public int id { get; set; }
        public Client client { get; set; }
        public decimal discond => client.discount;
        public decimal price => getPrice();
        public List<OrderLine> lines { get; }

        private decimal getPrice()
        {
            decimal price = 0;
            foreach (OrderLine line in lines)
            {
                price += line.product.price * line.count;
            }
            return (price * (100 - discond)) / 100;
        }
        public Order(int id, Client client)
        {

            Console.WriteLine("    Создание заказа id= "+ id+": ");

            this.id = id;
            this.client = client;
            lines = new List<OrderLine>();
        }

        public void AddOrderLine(OrderLine ol)
        {
            lines.Add(ol);
        }
    }
}
