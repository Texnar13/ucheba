using LabApp4;
using System;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace LabApp4
{
    public partial class Form6 : Form
    {
       public Form6()
       {
           InitializeComponent();

           label2.Text = "";
           label6.Text = "";

           label1.Text = "На счету: " + Convert.ToString(Form4.chet[Form5.numer_work_chet].balance);
           label3.Text = "Состояние счета: "+ Form4.chet[Form5.numer_work_chet].condition;
       }

        private void button2_Click(object sender, EventArgs e)
        {
            // закрыть счет
            Form4.chet[Form5.numer_work_chet].condition = "закрыт";
            Form4.chet[Form5.numer_work_chet].work = false;
            label3.Text = "Состояние счета: счет закрыт";
        }

        private void button5_Click(object sender, EventArgs e)
        {
            // история операций
            label6.Text = string.Join(", ", Form4.chet[Form5.numer_work_chet].history);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Открыть счет
            Form4.chet[Form5.numer_work_chet].condition = "открыт";
            Form4.chet[Form5.numer_work_chet].work = true;
            label1.Text = "На счету: " + Convert.ToString(Form4.chet[Form5.numer_work_chet].balance);
            label3.Text = "Состояние счета: " + Form4.chet[Form5.numer_work_chet].condition;

        }

        private void button3_Click(object sender, EventArgs e)
        {
            // пополнение
            int money = 0;
            if (int.TryParse(textBox1.Text, out money) && money >= 0) 
            {
                if (Form4.chet[Form5.numer_work_chet].work == true)
                {
                    Form4.chet[Form5.numer_work_chet].balance += money;
                    Array.Resize<string>(ref Form4.chet[Form5.numer_work_chet].history_coming, Form4.chet[Form5.numer_work_chet].history_coming.Length + 1);
                    Form4.chet[Form5.numer_work_chet].history_coming[Form4.chet[Form5.numer_work_chet].history_coming.Length - 1] = "Внесено: " + money;
                    Array.Resize<string>(ref Form4.chet[Form5.numer_work_chet].history, Form4.chet[Form5.numer_work_chet].history.Length + 1);
                    Form4.chet[Form5.numer_work_chet].history[Form4.chet[Form5.numer_work_chet].history.Length - 1] = "Внесено: " + money;
                    label1.Text = "На счету: " + Convert.ToString(Form4.chet[Form5.numer_work_chet].balance);
                    label2.Text = "Успешно";
                }
                else
                {
                    label2.Text = "Неудачно: счет закрыт";
                }
            }
            else
            {
                label2.Text = "Неудачно: некорректное число!";
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            // снятие
            int money = 0;
            if (int.TryParse(textBox1.Text, out money) && money >= 0)
            {

                if (Form4.chet[Form5.numer_work_chet].work == true)
                {
                    if (money <= Form4.chet[Form5.numer_work_chet].balance)
                    {
                        Form4.chet[Form5.numer_work_chet].balance -= money;
                        Array.Resize<string>(ref Form4.chet[Form5.numer_work_chet].history_expenses, Form4.chet[Form5.numer_work_chet].history_expenses.Length + 1);
                        Array.Resize<string>(ref Form4.chet[Form5.numer_work_chet].history, Form4.chet[Form5.numer_work_chet].history.Length + 1);
                        Form4.chet[Form5.numer_work_chet].history_expenses[Form4.chet[Form5.numer_work_chet].history_expenses.Length - 1] = "Снято: " + money;
                        Form4.chet[Form5.numer_work_chet].history[Form4.chet[Form5.numer_work_chet].history.Length - 1] = "Снято: " + money;
                        label1.Text = "На счету: " + Convert.ToString(Form4.chet[Form5.numer_work_chet].balance);
                        label2.Text = "Успешно";
                    }
                    else
                    {
                        label2.Text = "На счету недостаточно средств";
                    }
                }
                else
                {
                    label2.Text = "Состояние счета: счет закрыт";
                }
            }
            else
            {
                label2.Text = "Неудачно: некорректное число!";
            }
        }

        private void button6_Click(object sender, EventArgs e)
        {
            // выход
            this.Close();
        }
    }
}
