package com.company;
import java.util.Random;
public class Main {

    static Random random;

    static final int N = 7;

    static class Tzap {
        int y, m, d;
        String e;
    }

    static int diap(int n, int k) {
        return random.nextInt(k - n) + n;
    }

    static String st(byte n) {
        int i, k;
        String s;

        s = "";
        k = random.nextInt(n) + 1;
        for (i = 1; i <= k; i++)
            s = s + (char) (random.nextInt(25) + 65);
        return s;
    }

    public static void main(String[] args) {
        int i, j;
        Tzap z;
        Tzap[] M = new Tzap[N];

        random = new Random();

        for (i = 0; i < N; i++) {
            M[i] = new Tzap();
            M[i].y = diap(2000, 2019);
            M[i].m = diap(1, 12);
            M[i].d = diap(1, 31);
            M[i].e = st((byte) 20);
        }

        for (i = 0; i < N; i++)
            System.out.printf("%d. %6d%5d%5d    %s\n", i + 1, M[i].y, M[i].m, M[i].d, M[i].e);
        System.out.println();


        // todo Считаем время работы программы
        long startTime = System.nanoTime();
        System.out.println(startTime);


        // сортировка пузырьком
        for (i = 0; i < N; i++)
            for (j = 0; j < N - 1; j++)
                if (M[j].y < M[j + 1].y) {
                    z = M[j];
                    M[j] = M[j + 1];
                    M[j + 1] = z;
                }

        // todo Считаем время работы программы
        System.out.println(System.nanoTime() - startTime);

        for (i = 0; i < N; i++)
            System.out.printf("%d. %6d%5d%5d    %s\n", i + 1, M[i].y, M[i].m, M[i].d, M[i].e);
        System.out.println();
    }
}
