package org.example

import java.lang.Exception
import javax.swing.*
import javax.swing.text.AttributeSet
import javax.swing.text.PlainDocument

fun main() {
    // Вариант 9
    /*

    Пусть а = 23, b = 19, с = МахVal + 1 = 256, t0 = 235. Вычислить
    контрольные суммы для нескольких сообщений методом контрольных сумм (KSumm)
    и методом хеширования с применением гаммирования (SummKodBukvOtkr):
    а) Р = '0000123456', KSumm = ?, SummKodBukvOtkr – ?;
    б) Р = '6543210000', KSumm = ?, SummKodBukvOtkr – ?;
    в) Р = '10000001', KSumm = ?, SummKodBukvOtkr – ?;
    г) Р = '11000000', KSumm = ?, SummKodBukvOtkr – ?


    */


    // создание окна
    val frame = JFrame("Вычисление контрольных сумм")
    frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE)
    frame.setSize(800, 400)
    frame.setLocationRelativeTo(null)


    val italicBox = frame.add(JCheckBox("Гаммирование").apply {
        setBounds(450, 25, 250, 20)
        //check(false)
    }) as JCheckBox

    // ================== Ввод констант ==================

    frame.add(JLabel("Строка = ").apply {
        setBounds(25, 25, 250, 20)
    })
    val strInput = frame.add(JTextField().apply {
        setBounds(90, 25, 200, 20)
        text = "0000123456"
    }) as JTextField


    frame.add(JLabel("a = ").apply {
        setBounds(25, 50, 250, 20)
    })
    val aInput = frame.add(JTextField().apply {
        document = JTextFiledNumbersOnly(4)
        setBounds(90, 50, 100, 20)
        text = "23"
    }) as JTextField

    frame.add(JLabel("b = ").apply {
        setBounds(25, 75, 250, 20)
    })
    val bInput = frame.add(JTextField().apply {
        document = JTextFiledNumbersOnly(4)
        setBounds(90, 75, 100, 20)
        text = "19"
    }) as JTextField

    frame.add(JLabel("maxVal = ").apply {
        setBounds(25, 100, 250, 20)
    })
    val maxValInput = frame.add(JTextField().apply {
        document = JTextFiledNumbersOnly(4)
        setBounds(90, 100, 100, 20)
        text = "255"
    }) as JTextField

    frame.add(JLabel("t0 = ").apply {
        setBounds(25, 125, 250, 20)
    })
    val t0Input = frame.add(JTextField().apply {
        document = JTextFiledNumbersOnly(4)
        setBounds(90, 125, 100, 20)
        text = "235"
    }) as JTextField

    val output = frame.add(JLabel("Нажмите сгенерировать!").apply {
        setBounds(25, 175, 250, 20)
    }) as JLabel


    frame.add(JButton("Сгенерировать хеш!").apply {
        setBounds(25, 325, 740, 20)
        addActionListener {

            try {

                output.text = "Хэш = " + kSumm(
                    input = strInput.text.toString(),
                    a = aInput.text.toString().toInt(),
                    b = bInput.text.toString().toInt(),
                    maxVal = maxValInput.text.toString().toInt(),
                    t0 = t0Input.text.toString().toInt(),
                    useGammir = italicBox.isSelected
                ).toString()
            } catch (e: Exception) {
                output.text = "Ошибка ввода"
            }
        }
    })


    frame.layout = null
    // переотрисовка
    frame.isVisible = true
}

private fun kSumm(input: String, a: Int, b: Int, maxVal: Int, t0: Int, useGammir: Boolean): Int {

    // коды символов T1, T2...
    print("T = [")
    var prevTi = 0
    val tCodes = Array(input.length) { pos ->
        val value =
            if (pos == 0)
                t0
            else
                (a * prevTi + b) % (maxVal + 1) // ti

        // текущее значение  как предыдущее
        prevTi = value

        print("$value, ")
        value
    }
    println("]")

    // сумма
    var summ = 0

    input.indices.forEach {

        if (useGammir) {
            // расчет суммы
            val number = (input[it].code xor tCodes[it])
            summ += number
            print("[${input[it].code} xor ${tCodes[it]} > $number] + ")
        } else {
            // расчет суммы
            summ += input[it].code
            print("${input[it].code} + ")
        }
    }
    println(" = $summ")

    // получаем контрольную сумму
    val kSumm = summ % (maxVal + 1)
    println("kSumm = $kSumm")

    return kSumm
}


class JTextFiledNumbersOnly(
    private val limit: Int
) : PlainDocument() {

    override fun insertString(offs: Int, str: String?, a: AttributeSet?) {
        if (str == null)
            return
        // проверка на символы
        val newInput = StringBuilder()
        str.forEach {
            if (it.code in 48..58) newInput.append(it)
        }
        // если не достигли максимальной длины строки
        if (length + newInput.length <= limit)
            super.insertString(offs, newInput.toString(), a)
    }
}