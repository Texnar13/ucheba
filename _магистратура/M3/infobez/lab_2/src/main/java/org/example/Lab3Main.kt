package org.example

import java.util.*
import javax.swing.*
import javax.swing.text.AttributeSet
import javax.swing.text.PlainDocument


fun main() {
    // Вариант 9
    // P = 10^-4
    // V = 3 Пароля/Мин
    // T = 15 Дней

    // создание окна
    val frame = JFrame("Генератор паролей пользователей")
    frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE)
    frame.setSize(800, 400)
    frame.setLocationRelativeTo(null)


    // ================== Выбор алфавита ==================
//    var isLatinCharacters = false
//    var isCyrillicCharacters = false
//    var isCapitalLatinCharacters = false
//    var isCapitalCyrillicCharacters = false
    val charactersFlags = arrayOf(false, false, false, false)

    frame.add(JCheckBox("Латиница").apply {
        setBounds(450, 25, 250, 20)
        check(true)
        addActionListener { charactersFlags[0] = isSelected }
    })
    frame.add(JCheckBox("Кириллица").apply {
        setBounds(450, 50, 250, 20)
        check(true)
        addActionListener { charactersFlags[1] = isSelected }
    })
    frame.add(JCheckBox("Заглавная латиница").apply {
        setBounds(450, 75, 250, 20)
        check(true)
        addActionListener { charactersFlags[2] = isSelected }
    })
    frame.add(JCheckBox("Заглавная кириллица").apply {
        setBounds(450, 100, 250, 20)
        check(true)
        addActionListener { charactersFlags[3] = isSelected }
    })


    // ================== Ввод констант ==================

    frame.add(JLabel("P(Вероятность)").apply {
        setBounds(25, 25, 250, 20)
    })
    val pInput = frame.add(JTextField().apply {
        document = JTextFiledNumbersAndDots(20)
        setBounds(250, 25, 100, 20)
        text = "0.0001"
    }) as JTextField

    frame.add(JLabel("V(Скорость перебора)(Пароля/Мин)").apply {
        setBounds(25, 50, 250, 20)
    })
    val vInput = frame.add(JTextField().apply {
        document = JTextFiledNumbersAndDots(20)
        setBounds(250, 50, 100, 20)
        text = "3"
    }) as JTextField

    frame.add(JLabel("T(Срок действия пароля) (Дней)").apply {
        setBounds(25, 75, 250, 20)
    })
    val tInput = frame.add(JTextField().apply {
        document = JTextFiledNumbersAndDots(20)
        setBounds(250, 75, 100, 20)
        text = "15"
    }) as JTextField


    // ================== Расчетные поля ==================

    val output = frame.add(JLabel().apply {
        setBounds(25, 100, 350, 80)
        text = "Введите параметры и нажмите сгенерировать"
    }) as JLabel


    // ================== Кнопка расчетов ==================
    val random = Random()
//    var latinCharacters = false
//    var cyrillicCharacters = false
//    var capitalLatinCharacters = false
//    var capitalCyrillicCharacters = false

//    for (i in 1..2000) {
//        println("char = ${Char(i)} code=$i")
//        // symbol 33-43(11) 58-64(7)
//        // number 48-57(10)
//        // ABC    65-90(26)
//        // abc    97-122(26)
//        // АБВ    1040-1071(32)
//        // абв    1072-1103(32)
//    }
//    println("char = ${'А'.code} code=")

    frame.add(JButton("Сгенерировать пароль!").apply {
        setBounds(25, 325, 740, 20)
        addActionListener {
            if (!charactersFlags[0] && !charactersFlags[1] && !charactersFlags[2] && !charactersFlags[3]) {
                output.text = "Слишком маленький алфавит"
            } else {

                val p = floatFromStringOrNull(pInput.text.toString())
                val v = floatFromStringOrNull(vInput.text.toString())
                val t = floatFromStringOrNull(tInput.text.toString())

                if (p == null) {
                    output.text = "Неправильный формат параметра P"
                } else if (v == null) {
                    output.text = "Неправильный формат параметра V"
                } else if (t == null) {
                    output.text = "Неправильный формат параметра T"
                } else {

                    // Мощность алфавита
                    val a = 0 +
                            (if (charactersFlags[0]) 26 else 0) +// Латиница
                            (if (charactersFlags[1]) 32 else 0) +// Кириллица
                            (if (charactersFlags[2]) 26 else 0) +// Заглавная латиница
                            (if (charactersFlags[3]) 32 else 0)  // Заглавная кириллица


                    // println(log(8.toDouble(), 2.toDouble())) = 3


                    // A^L >= S = VT/P
                    val s = (v * t / p).toDouble()
                    val lPrev = kotlin.math.log(s, a.toDouble())
                    // длинна пароля
                    val l = kotlin.math.ceil(lPrev).toInt()

                    // генерируем пароль
                    val password = java.lang.StringBuilder()
                    for(i in 1..l){
                        var code = random.nextInt(a)
                        if(charactersFlags[0]){
                            if(code < 26){
                                password.append(Char(97 + code))
                                continue
                            }else{
                                code -= 26
                            }
                        }
                        if(charactersFlags[1]){
                            if(code < 32){
                                password.append(Char(1072 + code))
                                continue
                            }else{
                                code -= 32
                            }
                        }
                        if(charactersFlags[2]){
                            if(code < 26){
                                password.append(Char(65 + code))
                                continue
                            }else{
                                code -= 26
                            }
                        }
                        if(charactersFlags[3]){
                            if(code < 32){
                                password.append(Char(1040 + code))
                                continue
                            }else{
                                code -= 32
                            }
                        }
                    }

                    output.text = "<html>S*=VT/P Нижняя граница: $s<br>" +
                            "A  Мощность алфавита: $a<br>" +
                            "L  Длинна пароля: ${l}<br>" +
                            "<br>Сгенерированный пароль: $password"
                            "</html>"
                }
            }
        }
    })


    /*

    charactersFlags[0]
    pInput.text.toString()
    vInput.text.toString()
    tInput.text.toString()
    output.text =


    */

    frame.layout = null
    // переотрисовка
    frame.isVisible = true
}


// ====================== вспомогательные методы ======================


fun floatFromStringOrNull(input: String): Float? {
    try {
        return input.toFloat()
    } catch (e: Exception) {
        // ignore
    }
    return null
}

class JTextFiledNumbersAndDots(
    private val limit: Int
) : PlainDocument() {

    override fun insertString(offs: Int, str: String?, a: AttributeSet?) {
        if (str == null)
            return
        // проверка на символы
        val newInput = StringBuilder()
        str.forEach {
            if (it.code in 48..58 || it == '.') newInput.append(it)
        }
        // если не достигли максимальной длины строки
        if (length + newInput.length <= limit)
            super.insertString(offs, newInput.toString(), a)
    }
}