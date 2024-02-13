import java.util.Random;
import java.util.Scanner;

public class Main {

    static final Scanner scanner = new Scanner(System.in);
    static final Random random = new Random(System.currentTimeMillis());

    /**
     * Написать программу, которая создает случайным
     * образом двумерный массив целых чисел,
     * а затем обнуляет элементы ниже главной диагонали.
     */
    public static void main(String[] args) {
        // инициализируем переменные и выделяем память под них

        // Вводим значения
        System.out.print("Введите размер матрицы: ");
        int elementsCount = scanner.nextInt();
        System.out.print("Введите нижнюю границу чисел: ");
        int minElement = scanner.nextInt();
        System.out.print("Введите верхнюю границу чисел: ");
        int elementsRange = scanner.nextInt() - minElement + 1;
        // проверки
        if (elementsCount < 1) elementsCount = 1;
        if (elementsCount > 127) elementsCount = 127;
        if (minElement < -127) minElement = -127;
        if (minElement > 127) minElement = 127;
        if (elementsRange < 1) elementsRange = 1;
        if (elementsRange + minElement > 251) elementsRange = 251 - minElement;

        // todo Считаем время работы программы
        long startTime = System.nanoTime();
        System.out.println(startTime);

        byte rowI;
        byte columnI;

        // создаем массив элеменнтов
        System.out.println("Генерирую массив: ");
        byte[][] array = new byte[elementsCount][elementsCount];
        for (rowI = 0; rowI < elementsCount; rowI++) {
            for (columnI = 0; columnI < elementsCount; columnI++) {
                array[rowI][columnI] = (byte) (random.nextInt(elementsRange) + minElement);
                System.out.print(array[rowI][columnI] + " ");
            }
            System.out.println();
        }

        /*
         * место для промежуточных расчетов с матрицей
         */

        // чистим диагональ
        System.out.println("Итоговый массив: ");
        for (rowI = 0; rowI < elementsCount; rowI++) {
            for (columnI = 0; columnI < elementsCount; columnI++) {
                if (rowI - 1 >= columnI) array[rowI][columnI] = 0;
                System.out.print(array[rowI][columnI] + " ");
            }
            System.out.println();
        }

        // todo Считаем время работы программы
        System.out.println(System.nanoTime() - startTime);
    }
}
