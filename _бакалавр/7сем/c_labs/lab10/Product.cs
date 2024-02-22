using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab10
{
    internal class Product : IComparable<Product>
    {
        private string _name;
        private string _count_str;
        private double _count;

        public Product(string name, string count_str)
        {
            _name = name;
            _count_str = count_str;
            try
            {
                _count = MyConvert(count_str);
            }
            catch(ArgumentException f)
            {
                _name = "Error!!!";
                _count = 0;
                Console.WriteLine($"{f}");
            }
            
        }

        public int CompareTo(Product p)
        {
            return (int)( 
                (p.getCount() - this._count) * 1000f
            ) - 1000;

        }

        public string getName() => _name;
        public double getCount() => _count;

        private double MyConvert(string str)
        {
            // проверка длинны  не меньше двух символов вроде "2г"
            if (str.Length < 2)
                throw new ArgumentException("not correct");

            if (str[0] < '1' || '9' < str[0])
                throw new ArgumentException("not correct number");
            double count = 0, e = 1;
            int offset = 1;
            if (!char.IsDigit(str[str.Length - 2]))
            {
                switch ((char)str[str.Length - 2])
                {
                    case 'к':
                        e = 1000;
                        break;
                    case 'м':
                        e = 0.001;
                        break;
                }
                offset = 2;
            }
            str = str.Remove(str.Length - offset, offset);
            count = double.Parse(str);
            return count * e;
        }
    }
}
