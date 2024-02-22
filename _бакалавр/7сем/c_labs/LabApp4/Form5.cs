using LabApp4;
using System;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace LabApp4
{
    public partial class Form5 : Form
    {
        public static int numer_work_chet = -1;
        public Form5()
        {
            InitializeComponent();
            label2.Text = string.Join(", ", Form2.clients[Form3.number_of_mas_clint].number_account);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(textBox1.Text, out numer_work_chet) || numer_work_chet < 0)
            {
                label3.Text = "Введено некорректное число!";
            }
            else if (!Form2.clients[Form3.number_of_mas_clint].number_account.Contains(numer_work_chet))
            {
                label3.Text = "Такого счета нет!";
            }
            else    
            {
                label3.Text = "Счет найден";
                Form6 f6 = new Form6();
                f6.Show();
            }
       }
    }
}
