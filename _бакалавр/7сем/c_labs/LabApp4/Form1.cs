using System;
using System.Windows.Forms;
using static System.Windows.Forms.DataFormats;

namespace LabApp4
{
   public partial class Form1 : Form
   {
       public Form1()
       {
           InitializeComponent();
       }

        private void button2_Click(object sender, EventArgs e)
        {
            (new Form3()).Show(); 
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            (new Form2()).Show();

        }
    }
}