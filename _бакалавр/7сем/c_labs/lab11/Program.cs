
using System;
using System.Drawing;


namespace lab11
{
    class Prog
    {
        static void Main(string[] args)
        {
            Random rand = new Random();
            List<Point> points = new List<Point>();

            for (int i = 0; i < rand.Next(5, 9); i++)
            {
                points.Add(new Point(rand.NextDouble(), rand.NextDouble()));
            }

            foreach (var point in points)
            {
                Console.WriteLine(point.ToString());
            }
            Console.WriteLine();
            Console.WriteLine("center");

            points.Sort(new DistComp());

            foreach (var point in points)
            {
                Console.WriteLine(point.ToString());
            }
            Console.WriteLine();
            Console.WriteLine("x");

            points.Sort(new DistCompX());

            foreach (var point in points)
            {
                Console.WriteLine(point.ToString());
            }
            Console.WriteLine();
            Console.WriteLine("y");

            points.Sort(new DistCompY());

            foreach (var point in points)
            {
                Console.WriteLine(point.ToString());
            }

            Console.WriteLine();
            Console.WriteLine("xy");

            points.Sort(new DistCompXY());

            foreach (var point in points)
            {
                Console.WriteLine(point.ToString());
            }
        }
    }
}

