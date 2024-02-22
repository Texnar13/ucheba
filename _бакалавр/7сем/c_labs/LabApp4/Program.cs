
using System;
using System.Windows.Forms;

namespace LabApp4
{
    public static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }

    public class Client
    {
        public string name;
        public string surname;
        public string patronymic;
        public int age;
        public string work;
        public int[] number_account;
        public bool first;

        public Client(string name_, string surname_, string patronymic_, int age_, string work_, int[] number_account_, bool first_)
        {
            name = name_;
            surname = surname_;
            patronymic = patronymic_;
            age = age_;
            work = work_;
            number_account = number_account_;
            first = first_;
        }
    }

    public class Chet
    {
        public int number;
        public string[] history_coming;
        public string[] history_expenses;
        public string condition;
        public bool work;
        public int coming;
        public int expenses;
        public int balance;
        public string[] history;

        public Chet(int number_, string[] history_coming_, string[] history_expenses_, string condition_, bool work_, int coming_, int expenses_, int balance_, string[] history_)
        {
            number = number_;
            history_coming = history_coming_;
            history_expenses = history_expenses_;
            condition = condition_;
            work = work_;
            coming = coming_;
            expenses = expenses_;
            balance = balance_;
            history = history_;
        }
    }
}
