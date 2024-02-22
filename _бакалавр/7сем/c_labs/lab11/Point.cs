using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab11
{
    internal class Point
    {
        public double x;
        public double y;

        public Point(double x = 0, double y = 0)
        {
            this.x = x;
            this.y = y;
        }

        public string ToString()
        {
            return $"x : {x}   \t| y : {y}";
        }
    }
}
