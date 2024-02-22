using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsLab12
{
    public partial class Form1 : Form
    {

        // подгруженные картинки
        Image round = Image.FromFile("C:/Users/Ivan/Desktop/c_labs/WindowsFormsLab12/round.png");
        Image cross = Image.FromFile("C:/Users/Ivan/Desktop/c_labs/WindowsFormsLab12/cross.png");



        // состояние полей
        int[][] fieldState;

        // все картинки крестиков и ноликов в массиве
        PictureBox[][] pictures;


        // понятно что
        bool isGameOver = false;
        // сейчас крестики
        bool isNowCrossInput;


        public Form1()
        {
            InitializeComponent();
            pictures = new PictureBox[][]{
                new PictureBox[3]{ pictureBox2,  pictureBox5, pictureBox3 },
                new PictureBox[3]{ pictureBox7,  pictureBox4, pictureBox6 },
                new PictureBox[3]{ pictureBox10, pictureBox9, pictureBox8 }
            };

            resetGame();
        }


        void resetGame() { 
            for (int rowI = 0; rowI < pictures.Length; rowI++) {
                for (int columnI = 0; columnI < pictures[rowI].Length; columnI++)
                {
                    pictures[rowI][columnI].Image = null;
                }
            }

            // понятно что
            isGameOver = false;
            // сейчас крестики
            isNowCrossInput = true;

            // состояние поля для поиска победы или ничьей
            fieldState = new int[][]{
                new int[3]{ -1, -1, -1 },
                new int[3]{ -1, -1, -1 },
                new int[3]{ -1, -1, -1 }
            };

            label1.Text = "Ходят крестики";
        }


        private void button1_Click(object sender, EventArgs e)
        {
            resetGame();
        }


        void press(int row, int column){
            if (!isGameOver && fieldState[row][column] == -1)
            {
                if (isNowCrossInput)
                {
                    fieldState[row][column] = 1;
                    pictures[row][column].Image = cross;
                    label1.Text = "Ходят нолики";
                }
                else
                {
                    fieldState[row][column] = 0;
                    pictures[row][column].Image = round;
                    label1.Text = "Ходят крестики";
                }

                // следующий игрок
                isNowCrossInput = !isNowCrossInput;

                // проверка конца игры
                endGameCheck();
            }
        }

        // проверка конца игры
        void endGameCheck() {

            // проверка строк
            for (int rowI = 0; rowI < 3; rowI++)
            {
                if (fieldState[rowI][0] == 1 || fieldState[rowI][0] == 0)
                {
                    if (fieldState[rowI][0] == fieldState[rowI][1] &&
                    fieldState[rowI][1] == fieldState[rowI][2])
                    {
                        isGameOver = true;

                        label1.Text =
                            (fieldState[rowI][0] == 1) ? ("Выйграли крестики") : ("Выйграли нолики");
                    }
                }
            }

            // проверка столбцов
            for (int columnI = 0; columnI < 3; columnI++)
            {
                if (fieldState[0][columnI] == 1 || fieldState[0][columnI] == 0)
                {
                    if (fieldState[0][columnI] == fieldState[1][columnI] &&
                    fieldState[1][columnI] == fieldState[2][columnI])
                    {
                        isGameOver = true;

                        label1.Text =
                            (fieldState[0][columnI] == 1) ? ("Выйграли крестики") : ("Выйграли нолики");
                    }
                }
            }

            // проверка пустых клеток
            bool containsEmpty = false;
            if (!isGameOver) 
            {
                for (int rowI = 0; rowI < 3; rowI++)
                {
                    for (int columnI = 0; columnI < 3; columnI++)
                    {
                        if (fieldState[rowI][columnI] == -1) {
                            containsEmpty = true;
                        }
                    }
                }

                if (!containsEmpty)
                {
                    isGameOver = true;
                    label1.Text = "Ничья";

                }
            }

            // проверка диагоналей
            if ((fieldState[0][0] == 1 || fieldState[0][0] == 0) &&
                fieldState[0][0] == fieldState[1][1] &&
                    fieldState[1][1] == fieldState[2][2]
                ) 
            {
                isGameOver = true;

                label1.Text =
                    (fieldState[0][0] == 1) ? ("Выйграли крестики") : ("Выйграли нолики");

            }
        }


        private void pictureBox2_Click(object sender, EventArgs e)
        {
            press(0,0);
        }

        private void pictureBox5_Click(object sender, EventArgs e)
        {
            press(0, 1);
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            press(0, 2);
        }

        private void pictureBox7_Click(object sender, EventArgs e)
        {
            press(1, 0);
        }

        private void pictureBox4_Click(object sender, EventArgs e)
        {
            press(1, 1);
        }

        private void pictureBox6_Click(object sender, EventArgs e)
        {
            press(1, 2);
        }

        private void pictureBox10_Click(object sender, EventArgs e)
        {
            press(2, 0);
        }

        private void pictureBox9_Click(object sender, EventArgs e)
        {
            press(2, 1);
        }

        private void pictureBox8_Click(object sender, EventArgs e)
        {
            press(2, 2);
        }

    }
}
