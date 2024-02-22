

using System.Globalization;



class Program
{
    
    static void Main(string[] args)
    {
        char[,] state_mashine = new char[,] 
            {/*+   *   (   )   s*/
        /*n*/{'<','<','<','?','s'},
        /*+*/{'>','<','<','>','>'},
        /*/*/{'>','>','<','>','>'},
        /*(*/{'<','<','<','=','?'},
        /*)*/{'>','>','?','>','>'},
            };
        Dictionary<char, int> index = new Dictionary<char, int>()
        { {'n', 0 }, {'+', 1 }, {'-', 1}, {'*', 2 }, {'/', 2}, {'(', 3 }, {')', 4 }  };
        HashSet<char> op = new HashSet<char>() { '+', '-', '*', '/', '(', ')' };
        Stack<int> numbers = new Stack<int>();
        string exemple = "1+2+(3-2)";
        string new_line = "";
        string block = "";
        int value = 0;
        while (exemple.Length != 0)
        {
            if (exemple[0] >= '0' && exemple[0] <= '9')
            {
                value = value * 10 + (int)(exemple[0] - '0');
            }
            else if (op.Contains(exemple[0]))
            {
                if (value != 0)
                {
                    numbers.Push(value);
                }
                new_line += $"{exemple[0]}";
                value = 0;
                char c = state_mashine[index[new_line[new_line.Length - 1]], index[exemple[0]]];
                if (c == '>')
                {
                    c = c;
                }
                else
                    block += c;
                if (block[block.Length - 1] == 'e')
                {
                    Console.WriteLine($"Error symbol {exemple[0]}!!!");
                    Console.ReadLine();
                    return;
                }
            }
            else
            {
                Console.WriteLine($"Error symbol {exemple[0]}!!!");
                Console.ReadLine();
                return;
            }

            exemple = exemple.Substring(1, exemple.Length - 1);
        }
        if (value != 0)
            numbers.Push(value);
        Console.WriteLine(new_line);


        
        Console.ReadLine();
    }
}