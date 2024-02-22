using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dz3
{
    class Calc
    {
        //public Calc() { }

        public double getResult(string line)
        {
            bool is_correct = false;
            return vur(ref line, out is_correct);
        }

        public void test()
        {
            string[] inputs = { "1+2", "(234-11)*34", "6*6/6" }; // Пример
            string[] outputs = { "3", "7582", "6" }; // Пример
            for (int i = 0; i < inputs.Length; i++)
            {
                bool is_correct = false;
                Console.WriteLine(inputs[i] + "=" + outputs[i]);
                string line = inputs[i];
                double inp = vur(ref line, out is_correct);
                if (string.Format($"{inp}") == outputs[i])
                {
                    Console.WriteLine("OK");
                }
                else
                {
                    Console.WriteLine($"Faild , {inp}");
                }
            }
        }

        /*
            <Выражение>  ::= <Терм>|<Терм> + <Выражение>|<Терм> - <Выражение>
            */
        static double vur(ref string line, out bool is_correct)
        {
            is_correct = true;
            double value;
            value = term(ref line, out is_correct);
            if (!is_correct)
                return 0;
            if (line.Length == 0)
                return value;
            if (line[0] == '+')
            {
                line = line.Substring(1, line.Length - 1);
                value += vur(ref line, out is_correct);
                if (!is_correct)
                    return 0;
                return value;
            }
            else if (line[0] == '-')
            {
                line = line.Substring(1, line.Length - 1);
                value -= vur(ref line, out is_correct);
                if (!is_correct)
                    return 0;
                return value;
            }
            return value;
        }

        //<Терм>  ::= <Множитель> | <Множитель> * <Терм> | <Множитель> / <Терм> 

        static double term(ref string line, out bool is_correct)
        {
            is_correct = true;
            double value;
            value = mnosh(ref line, out is_correct);
            if (!is_correct)
                return 0;
            if (line.Length == 0)
                return value;
            if (line[0] == '*')
            {
                line = line.Substring(1, line.Length - 1);
                value *= term(ref line, out is_correct);
                if (!is_correct)
                    return 0;
                return value;
            }
            else if (line[0] == '/')
            {
                line = line.Substring(1, line.Length - 1);
                value /= term(ref line, out is_correct);
                if (!is_correct)
                    return 0;
                return value;
            }
            return value;
        }
        //<Множитель> ::= <число> | (<Выражение>)
        static double mnosh(ref string line, out bool is_correct)
        {
            double value = 0;

            if (line[0] == '(')
            {
                line = line.Substring(1, line.Length - 1);
                value = vur(ref line, out is_correct);
                if (!is_correct)
                {
                    return 0;
                }
                else
                {
                    line = line.Substring(1, line.Length - 1);
                    return value;
                }
            }
            else if (line[0] >= '0' && line[0] <= '9')
            {
                while (line[0] >= '0' && line[0] <= '9')
                {
                    value = value * 10 + (int)(line[0] - '0');
                    line = line.Substring(1, line.Length - 1);
                    if (line.Length == 0)
                        break;
                }
            }
            else
            {
                is_correct = false;
                return 0;
            }
            is_correct = true;
            return value;
        }
    }
}
