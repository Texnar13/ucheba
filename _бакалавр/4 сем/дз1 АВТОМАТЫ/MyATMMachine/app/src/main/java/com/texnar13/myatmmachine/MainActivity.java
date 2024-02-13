package com.texnar13.myatmmachine;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends AppCompatActivity {


    // ключи расшифровки ответов банкомата
    Map<Integer, String> backTranscript = new HashMap<>();

    // данные автомата
    final static int[][][] digitalMachine = {
            /*Q1*/{{1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {2, 10}, {1, 0}, {1, 0}},
            /*Q2*/{{2, 0}, {3, 101000}, {4, 101001}, {5, 101010}, {6, 101011}, {7, 101100}, {2, 0}, {2, 0}, {2, 0}, {2, 0}, {1, 1}, {2, 0}, {2, 0}},
            /*Q3*/{{2, 101000}, {2, 101000}, {2, 101000}, {2, 101000}, {2, 101000}, {2, 101000}, {2, 101000}, {2, 101000}, {2, 101000}, {2, 101000}, {3, 0}, {2, 101000}, {2, 101000}},
            /*Q4*/{{4, 101001}, {4, 101001}, {4, 101001}, {4, 101001}, {4, 101001}, {4, 101001}, {4, 101001}, {4, 101001}, {4, 101001}, {4, 101001}, {4, 0}, {2, 101111}, {2, 100000}},
            /*Q5*/{{5, 101010}, {5, 101010}, {5, 101010}, {5, 101010}, {5, 101010}, {5, 101010}, {5, 101010}, {5, 101010}, {5, 101010}, {5, 101010}, {5, 0}, {2, 101111}, {2, 100000}},
            /*Q6*/{{6, 101011}, {6, 101011}, {6, 101011}, {6, 101011}, {6, 101011}, {6, 101011}, {6, 101011}, {6, 101011}, {6, 101011}, {6, 101011}, {6, 0}, {2, 101111}, {2, 100000}},
            /*Q7*/{{7, 101100}, {7, 101100}, {7, 101100}, {7, 101100}, {7, 101100}, {7, 101100}, {7, 101100}, {7, 101100}, {7, 101100}, {7, 101100}, {7, 0}, {2, 101111}, {2, 100000}},
    };
    static int currentState = 1;
    static int currentOutput = 0;

    // сосотояние счета
    static int balance = 1000;
    // буфер для ввода пользователя
    static int enteredNumber = 0;


    // экран банкомата
    TextView screen;
    ImageView cardView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        // ключи расшифровки ответов банкомата
        backTranscript.put(10, "Клиент вошел в аккаунт");
        backTranscript.put(1, "Клиент вышел");
        backTranscript.put(0, "Нет доступа к такой операции");
        backTranscript.put(101000, "Клиент запросил баланс");
        backTranscript.put(101001, "Клиент хочет снять наличные");
        backTranscript.put(101010, "Клиент хочет пополнить карту");
        backTranscript.put(101011, "Клиент хочет перевести деньги");
        backTranscript.put(101100, "Клиент хочет оплатить телефон");
        backTranscript.put(100000, "Отмена операции");
        backTranscript.put(101111, "Подтверждение операции");


        // выход автомата
        TextView output = findViewById(R.id.main_otput);
        ScrollView outputScroll = findViewById(R.id.main_otput_scroll);


        // кнопки банкомата в разметке
        View[] buttons = new View[13];
        buttons[0] = findViewById(R.id.main_backplate_button_0);
        buttons[1] = findViewById(R.id.main_backplate_button_1);
        buttons[2] = findViewById(R.id.main_backplate_button_2);
        buttons[3] = findViewById(R.id.main_backplate_button_3);
        buttons[4] = findViewById(R.id.main_backplate_button_4);
        buttons[5] = findViewById(R.id.main_backplate_button_5);
        buttons[6] = findViewById(R.id.main_backplate_button_6);
        buttons[7] = findViewById(R.id.main_backplate_button_7);
        buttons[8] = findViewById(R.id.main_backplate_button_8);
        buttons[9] = findViewById(R.id.main_backplate_button_9);

        buttons[10] = findViewById(R.id.main_card_image);// c
        buttons[11] = findViewById(R.id.main_backplate_button_ok);// k
        buttons[12] = findViewById(R.id.main_backplate_button_back);// b


        // экран банкомата
        screen = findViewById(R.id.main_screen);
        cardView = (ImageView) buttons[10];
        screenOut(currentState);


        // обработка нажатий
        for (int buttonI = 0; buttonI < buttons.length; buttonI++) {
            int finalButtonI = buttonI;
            buttons[buttonI].setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // при нажатии на кнопку меняем состояние автомата
                    int lastState = currentState;
                    currentOutput = digitalMachine[currentState - 1][finalButtonI][1];//  2-1 / 1
                    currentState = digitalMachine[currentState - 1][finalButtonI][0];
                    // выход автомата
                    output.append("[" + lastState + "->" + currentState + "][" + currentOutput + "]:"
                            + backTranscript.get(currentOutput) + '\n');
                    outputScroll.fullScroll(ScrollView.FOCUS_DOWN);


                    // ввод цифр в буфер
                    if (finalButtonI < 10 && lastState >= 4 && lastState <= 7 && currentState == lastState) {
                        enteredNumber = enteredNumber * 10 + finalButtonI;
                        switch (currentState) {
                            case 4:// Снять наличные;
                                if (balance < enteredNumber) enteredNumber = balance;
                                break;
                            case 5:// Пополнить карту;
                                if (balance + enteredNumber > 50000)
                                    enteredNumber = 50000 - balance;
                                break;
                            case 6:// Перевести деньги на другую карту;
                                if (enteredNumber > 99999)
                                    enteredNumber = enteredNumber % 100000;
                                break;
                            case 7:// Оплатить телефон.
                                if (enteredNumber > 999999999)
                                    enteredNumber = enteredNumber % 1000000000;
                                break;
                        }
                    }
                    // чистка числа
                    if (currentOutput == 100000) {// отмена
                        enteredNumber = 0;
                    } else if (currentOutput == 101111) {// подтверждение

                        switch (lastState) {
                            case 4:// Снять наличные;
                                balance = balance - enteredNumber;
                                break;
                            case 5:// Пополнить карту;
                                balance = balance + enteredNumber;
                                break;
                            case 6:// Перевести деньги на другую карту;
                            case 7:// Оплатить телефон.
                                balance = balance - 100;
                                if (balance < 0) balance = 0;
                                break;
                        }
                        enteredNumber = 0;
                    }

                    // --------- графика ---------

                    // вывод картинки карты
                    if (lastState == 1 && currentState == 2) {// вставили карту
                        cardView.setImageResource(R.drawable.card_full);
                    } else if (lastState == 2 && currentState == 1) {// вытащили карту
                        cardView.setImageResource(R.drawable.card_empty);
                    } else if (currentState > 2) {// в остальных случаях
                        cardView.setImageResource(R.drawable.card_gray);
                    } else if (lastState > 2) {
                        cardView.setImageResource(R.drawable.card_full);
                    }


                    // вывод информации на экран
                    screenOut(lastState);
                }
            });
        }
    }

    void screenOut(int lastState) {
        switch (currentState) {
            case 1:// введите карту
                screen.setText("Вставьте пожалуйста карту");
                break;
            case 2:// Главный экран;
                screen.setText("Добро пожаловать! Что вы хотите сделать?\n 1 - Узнать баланс\n 2 - Снять наличные\n 3 - Пополнить карту\n 4 - Перевести деньги на другую карту\n 5 - Оплатить телефон\n");
                break;
            case 3:// Баланс;
                screen.setText("Ваш баланс:" + balance + " единиц");
                break;
            case 4:// Снять наличные;
                screen.setText("Введите сумму которую хотите снять(тек. баланс:" + balance + "):\n" + enteredNumber);
                break;
            case 5:// Пополнить карту;
                screen.setText("Введите сумму которую хотите положить:\n" + enteredNumber);
                break;
            case 6:// Перевести деньги на другую карту;
                screen.setText(String.format("Введите номер карты для перевода 100 единиц:\n%05d", enteredNumber));
                break;
            case 7:// Оплатить телефон.
                screen.setText(String.format("Введите номер телефона для перевода 100 единиц:\n%09d", enteredNumber));
                break;
        }
    }

    @Override
    protected void onDestroy() {
        currentState = 1;
        super.onDestroy();
    }
}