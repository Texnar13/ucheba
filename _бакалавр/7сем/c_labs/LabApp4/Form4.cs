using LabApp4;
using System;
using System.Windows.Forms;

namespace LabApp4
{
    public partial class Form4 : Form
    {
       public static Chet[] chet = new Chet[0];
       int number_of_chet = 0;
       public Form4()
       {
           InitializeComponent();
            label1.Text = "";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (Form2.clients[Form3.number_of_mas_clint].first == false)
            {
                Array.Resize<int>(ref Form2.clients[Form3.number_of_mas_clint].number_account, Form2.clients[Form3.number_of_mas_clint].number_account.Length + 1);
            }
            else
            {
                Form2.clients[Form3.number_of_mas_clint].first = false;
            }
            int number = Form2.clients[Form3.number_of_mas_clint].number_account.Length - 1;
     
            //Console.WriteLine(number);
     
            Form2.clients[Form3.number_of_mas_clint].number_account[number] = number_of_chet;
     
            string[] history_coming = { };
            string[] history_expenses = { };
            string condition = "открыт";
            bool work = true;
            int coming = 0;
            int expenses = 0;
            int balance = 0;
            string[] history = { };
     
            Array.Resize<Chet>(ref chet, chet.Length + 1);
            chet[number] = new Chet(number, history_coming, history_expenses, condition, work, coming, expenses, balance, history);
            number_of_chet++;

            label1.Text = "Счет создан!";
     
            //Console.WriteLine(chet[number]);
        }
     
        private void button2_Click(object sender, EventArgs e)
        {
            Form5 f5 = new Form5();
            f5.Show();
        }
     
        private void button3_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
