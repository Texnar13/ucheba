using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab11
{
    internal class DistComp : IComparer<Point>
    {
        public int Compare(Point p1, Point p2)
        {
            return (int)((
                p1.x * p1.x + p1.y * p1.y - 
                (p2.x* p2.x + p2.y * p2.y)) * 10000);
        }
    }

    internal class DistCompX : IComparer<Point>
    {
        public int Compare(Point p1, Point p2)
        {
            return (int)((p1.x - p2.x) * 10000);
        }
    }

    internal class DistCompY : IComparer<Point>
    {
        public int Compare(Point p1, Point p2)
        {
            return (int)((p1.y - p2.y) * 10000);
        }
    }

    internal class DistCompXY : IComparer<Point>
    {
        public int Compare(Point p1, Point p2)
        {
            return (int)((p1.y - p1.x - (p2.y - p2.x)) * 10000);
        }
    }
}
