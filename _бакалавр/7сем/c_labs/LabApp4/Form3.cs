using LabApp4;
using System;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace LabApp4
{
    public partial class Form3 : Form
    {
        public static int number_of_mas_clint = 0;
        public Form3()
        {
            InitializeComponent();

            label1.Text = "";
        }
     
        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }
     
        private void button1_Click(object sender, EventArgs e)
        {

            string name = textBox1.Text;
            string surname = textBox2.Text;
            string patronymic = textBox3.Text;

            int clientPos = -1;
            int same_counter = 0;


            for (int i = 0; i < Form2.clients.Length; i++)
                if (Form2.clients[i].name.Trim().Equals(name))
                {
                    clientPos = i;
                    same_counter++;
                }

            if (same_counter > 1 && surname != "")
            {

                clientPos = -1;
                same_counter = 0;
                for (int i = 0; i < Form2.clients.Length; i++)
                    if (Form2.clients[i].name == name & Form2.clients[i].surname == surname)
                    {
                        clientPos = i;
                        same_counter++;
                    }

                if (same_counter > 1 && patronymic != "")
                {

                    for (int i = 0; i < Form2.clients.Length; i++)
                        if (Form2.clients[i].name == name & Form2.clients[i].surname == surname & Form2.clients[i].patronymic == patronymic)
                        {
                            clientPos = i;
                            same_counter++;
                        }
                    if (same_counter > 1)
                    {
                        label1.Text = "Найдено несколько пользователей с таким именем и фамилией. Показан последний добавленный!";
                    }

                }
            }

            // если нашли
            if (same_counter == 1)
            {
                label1.Text = "Пользователь найден";
                number_of_mas_clint = clientPos;

                Form4 f4 = new Form4();
                f4.Show();
            }
            else if (same_counter > 1)
            {
                label1.Text = "Найдено несколько пользователей с таким именем и фамилией.";
            }
            else if(same_counter == 0)
            { 
                label1.Text = "Пользователь не найден";
            }
        }
    }
}
