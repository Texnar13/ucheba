


namespace lab10
{
    class LAB10
    {
        static void Main(string[] args)
        {
            //  список продуктов
            List<Product> pr = new List<Product>();

            var lines = File.ReadLines("data.txt");
            foreach (String line in lines)
            {
                var buf = line.Split(" ");

                // отсекаем строки где не 2 слова
                if (buf.Length != 2)
                    continue;

                // добавляем продукт в список
                string count = buf[0];
                string name = buf[1];
                pr.Add(new Product(name, count));
            }

            foreach (var p in pr)
            {
                Console.WriteLine($"{p.getName()} {p.getCount()}");
            }
            Console.WriteLine();

            pr.Sort();
            foreach (var p in pr)
            {
                Console.WriteLine($"{p.getName()} {p.getCount()}");
            }
        }
    }

}

