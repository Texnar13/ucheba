package com.company;

import java.util.Random;
import java.util.Scanner;

/**
 * Написать программу, которая создает случайным образом массив записей.
 * Каждая запись имеет поля: год, месяц, день и описание события.
 * Программа должна сортировать по полю «дата» (программа v25.dpr).
 */
public class Main2 {


    static class Tzap {
        int y;
        byte m, d;
        String e;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Введите год начала:");
        int startYear = scanner.nextInt();
        if (startYear < 0) {System.out.println("Год не может быть отрицательным");return;}
        System.out.print("Введите год конца:");
        int endYear = scanner.nextInt();
        if (endYear < 0) {System.out.println("Год не может быть отрицательным");return;}
        if (startYear > endYear) {System.out.println("Год начала не может быть больше года конца");return;}
        System.out.print("Введите количество записей:");
        int eventsCount = scanner.nextInt();

        Tzap[] eventList = new Tzap[eventsCount];
        Random random = new Random(10);
        int i;
        for (i = 0; i < eventsCount; i++) {
            eventList[i] = generateEvent(startYear, endYear, random);
        }

        for (i = 0; i < eventsCount; i++)
            System.out.printf("%d. %6d%5d%5d    %s\n", i + 1, eventList[i].y, eventList[i].m, eventList[i].d, eventList[i].e);
        System.out.println();


        // todo Считаем время работы программы
        long startTime = System.nanoTime();
        System.out.println(startTime);

        // сортировка слиянием
        mergeSort(eventList, 0, eventList.length - 1);


        // todo Считаем время работы программы
        System.out.println(System.nanoTime() - startTime);

        for (i = 0; i < eventsCount; i++)
            System.out.printf("%d. %6d%5d%5d    %s\n", i + 1, eventList[i].y, eventList[i].m, eventList[i].d, eventList[i].e);
        System.out.println();
    }


    static Tzap generateEvent(int startYear, int endYear, Random random) {
        Tzap answer = new Tzap();

        answer.y = random.nextInt(endYear - startYear + 1) + startYear;
        answer.m = (byte) (random.nextInt(11) + 1);
        answer.d = generateDay(answer.m, random);
        answer.e = generateDescripion((byte) 20, random);

        return answer;
    }


    // 1 Январь - 31 день
    // 2 Февраль - 28 дней (29 в високосном)
    // 3 Март - 31 день
    // 4 Апрель - 30 дней
    // 5 Май - 31 день
    // 6 Июнь - 30 дней
    // 7 Июль - 31 день
    // 8 Август - 31 день
    // 9 Сентябрь - 30 дней
    // 10 Октябрь - 31 день
    // 11 Ноябрь - 30 дней
    // 12 Декабрь - 31 день
    static byte generateDay(byte month, Random r) {
        return switch (month) {
            // февраль..
            case 2 -> (byte) (r.nextInt(28) + 1);
            // 30 дней
            case 4, 6, 9, 11 -> (byte) (r.nextInt(30) + 1);
            // 31 день
            default -> (byte) (r.nextInt(31) + 1);
        };
    }


    static String generateDescripion(byte n, Random r) {
        int i, k;
        String s;

        s = "";
        k = r.nextInt(n) + 1;
        for (i = 1; i <= k; i++)
            s = s + (char) (r.nextInt(25) + 65);
        return s;
    }


    static void mergeSort(Tzap[] source, int left, int right) {
        // Выберем разделитель, т.е. разделим пополам входной массив
        int delimiter = left + ((right - left) / 2) + 1;

        // Выполним рекурсивно данную функцию для двух половинок (если сможем разбить)
        if (delimiter > 0 && right > (left + 1)) {
            mergeSort(source, left, delimiter - 1);
            mergeSort(source, delimiter, right);
        }
        // Создаём временный массив с нужным размером
        Tzap[] buffer = new Tzap[right - left + 1];
        // Начиная от указанной левой границы идём по каждому элементу
        int cursor = left;
        int mid = delimiter;
        for (int i = 0; i < buffer.length; i++) {
            // Мы используем delimeter чтобы указывать на элемент из правой части
            // Если delimeter > right, значит в правой части не осталось недобавленных элементов
            if (cursor < mid && (delimiter > right || compareDate(source[cursor], source[delimiter]) > 0)) {
                buffer[i] = source[cursor];
                cursor++;
            } else {
                buffer[i] = source[delimiter];
                delimiter++;
            }
        }
        System.arraycopy(buffer, 0, source, left, buffer.length);
    }

    static int compareDate(Tzap a, Tzap b) {
        // сравниваем год
        if (a.y > b.y) return 1;
        if (a.y < b.y) return -1;

        // если год одинаковый, сравниваем месяц
        if (a.m > b.m) return 1;
        if (a.m < b.m) return -1;

        // если год и месяц одинаковые, сравниваем дни (в случае одинаковых дат вернет 0)
        return Byte.compare(a.d, b.d);
    }
}
