using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;

namespace _4
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            Width = 300;//задаем нач размер
            Height = 300;
        }

        readonly List<string> list = new List<string>();//создаем лист
        private void button1_Click(object sender, EventArgs e)//кнопка открытия файла
        {
            #region настройка OpenFileDialog
            OpenFileDialog opendial = new OpenFileDialog();//экз. класса
            opendial.InitialDirectory = "";//указываем начальную дерикторию
            opendial.Filter = "Файлы txt *.txt|*.txt";//ставим фильтир только на txt
            opendial.ReadOnlyChecked = true;// режим только для чтения
            #endregion

            

            Stopwatch stopWatch = new Stopwatch();//экз. класса
            
            if (opendial.ShowDialog() == DialogResult.OK)//если диал. окно открыто
            {
                stopWatch.Start();//запускаем отсчет времени

                string str = File.ReadAllText(opendial.FileName);//записываем в переменную стринг текст из файла
                
                string[] s_mas = str.Split();//записываем в массив стринг слова из str

                foreach(string o in s_mas)
                    if (!list.Contains(o) && o != "")//если в листе нет такой строки и она не путая
                        list.Add(o.ToLower());//заносим в лист делая все слова маленькими


                stopWatch.Stop();//останавливаем счетчик времени
                textBox1.Text = stopWatch.Elapsed.ToString();//вводим в текстбокс сколько по времени это считалось

                #region появление кнопок
                textBox2.Visible = textBox3.Visible = true;
                listBox1.Visible = true;
                label2.Visible = true;
                button2.Visible = true;
                Width = 850;
                Height = 400;
                #endregion
            }
        }

        private void button2_Click(object sender, EventArgs e)//кнопка поиска
        {
            Stopwatch stopWatch = new Stopwatch();//экз. класса
            stopWatch.Start();//запускаем отсчет времени
            string s = textBox3.Text.ToLower();//добавляем содер текстбокса маленькими буквами
            if (list.Contains(s))//если слово есть в списке
            {
                foreach (string o in list)//ищем его
                    if (o == s)
                    {
                        listBox1.BeginUpdate();//
                        listBox1.Items.Add(o);// добавляем слово
                        listBox1.EndUpdate();//
                        stopWatch.Stop();//останавливаем подсчет времени
                        textBox2.Text = stopWatch.Elapsed.ToString();//выводим время
                        break;
                    }       
            }
            else
            {
                listBox1.Items.Add("Слова нет в списке");//если слова нет в списке
                stopWatch.Stop();//останавливаем подсчет времени
                textBox2.Text = stopWatch.Elapsed.ToString();//выводим время
            }
        }
    }
}
