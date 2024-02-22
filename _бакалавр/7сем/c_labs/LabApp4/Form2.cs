using LabApp4;
using System;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace LabApp4
{
    public partial class Form2 : Form
    {
       public static Client[] clients = new Client[0];
       public static int clients_length = 0;
    
       public Form2()
       {
           InitializeComponent();
            label7.Text = " ";
        }
    
       public void button1_Click(object sender, EventArgs e)
       {
           Array.Resize<Client>(ref clients, clients.Length + 1);
    
           string name = textBox1.Text;
           string surname = textBox2.Text;
           string patronymic = textBox3.Text;
           int age = 0;
           string work = textBox5.Text;
           bool first = true;

            if (int.TryParse(textBox4.Text, out age))
            {
                clients[clients.Length - 1] =
                         new Client(name, surname, patronymic, age, work, new int[] { 0 }, first);
                label7.Text = "Успешно";
            }
            else
            {
                label7.Text = "Некорректный возраст";
            }
       }
    
       private void button2_Click(object sender, EventArgs e)
       {
           this.Close();
       }

    }
}
