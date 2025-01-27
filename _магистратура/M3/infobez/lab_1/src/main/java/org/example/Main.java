package org.example;

import java.util.Random;
import java.util.Scanner;

// Press Shift twice to open the Search Everywhere dialog and type `show whitespaces`,
// then press Enter. You can now see whitespace characters in your code.
public class Main {
    static Scanner scanner = new Scanner(System.in);
    static Random randomizer = new Random(System.currentTimeMillis());

    public static void main(String[] args) {
        /*
         * M = 12
         *
         * b1, ..., b(1 + Q) — случайные малые буквы русского алфавита, где Q = (N^3)mod5;
         * b(1+Q+1), ..., b(1+Q+1+P) — случайные заглавные буквы русского алфавита,
         *   где P = (N^2)mod6.
         * Оставшиеся символы пароля — случайные цифры
         * */


        System.out.println("Генератор паролей. Марчук Иван ИУ6-31М ЛР1");
        System.out.print("Введите имя пользователя:");
        String input = scanner.nextLine();

        System.out.println("----- Вычисляем -----");
        int mParam = 12;
        int nParam = input.length();
        int qParam = (nParam * nParam * nParam) % 5;
        int pParam = (nParam * nParam) % 6;
        System.out.println("M=" + mParam);
        System.out.println("N=" + nParam);
        System.out.println("Q=" + qParam);
        System.out.println("P=" + pParam);

        // генерация строки пароля
        int charPosition = 1;
        char[] password = new char[mParam];

        System.out.println("Генерация b1, ..., b(1 + Q=" + qParam + ")");
        for (; charPosition <= qParam + 1; charPosition++) {
            password[charPosition-1] = (char) (1072 + randomizer.nextInt(31));
        }
        System.out.println(password);

        System.out.println("Генерация b(1+Q=" + qParam + "+1), ..., b(1+Q=" + qParam + "+1+P=" + pParam + ")");
        for (; charPosition <= 1 + qParam + 1 + pParam; charPosition++) {
            password[charPosition-1] = (char) (1040 + randomizer.nextInt(31));
        }
        System.out.println(password);

        System.out.println("Генерация цифр ");
        for (; charPosition <= mParam; charPosition++) {
            password[charPosition-1] = (char) (48 + randomizer.nextInt(10));
        }


        System.out.print("-------------------------\nСгенерированный пароль: ");
        System.out.println(password);

    }
}