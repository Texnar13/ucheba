import java.util.Scanner;

public class Main {

    static Scanner scan = new Scanner(System.in);


    static String inLine;// вводимая строка


    public static void main(String[] args) {

        System.out.println("Enter string:");
        inLine = scan.nextLine().trim();// ввод строки

        while (!inLine.equals("end")) {

            try {// ставим блок отлова ошибок(проставленных мною) разбора строки

                String token = getTokenString(inLine);// получаем строку токенов из исходной строки
                System.out.println("\nToken string: " + token);

                if (isPrototypeInTokensLine(token)) {// анализируем
                    System.out.println("\nprototype correct");
                }
            } catch (Exception e) {
                System.out.println("Error: " + e.getMessage());
                //e.printStackTrace();
            }

            System.out.println("\n\nEnter string:");
            inLine = scan.nextLine().trim();// ввод строки
        }

    }


    static String getTokenString(String in) throws Exception {// метод разбирающий строку на токены

        /*
            P == Префикс
            T == Тип
            I == Идентиф.
            V == void
            ( == (
            , == ,
            ) == )
            ; == ;
        */

        StringBuilder tokenString = new StringBuilder(" ");// инициализируем строку для ответа
        StringBuilder inCopy = new StringBuilder(in);// копируем строку во внутреннюю переменную метода

        boolean checkedFlag;// опознан ли како-нибудь символ за текущую итерацию
        while (inCopy.length() != 0) {// цикл по строке
            checkedFlag = false;


            if (tokenString.charAt(tokenString.length() - 1) != 'I') {// отфильтровываем строки на подобие aaachar

                // ищем префиксы
                String[] search = {"signed", "unsigned"};

                int wordIterator = 0;
                while (wordIterator < search.length && !checkedFlag) {// пробегаемся по массиву

                    int poz = 0;// проверяем эквивалентность цепочек
                    while (search[wordIterator].length() > poz && inCopy.length() > poz) {
                        if (search[wordIterator].charAt(poz) != inCopy.charAt(poz))
                            break;// к сожалению это нельзя поместить в условие выхода, выдаст ошибку выхода за границы
                        poz++;
                    }

                    if (poz == search[wordIterator].length()) {// если цепочка пройдена целиком
                        checkedFlag = true; // символ найден
                        inCopy.delete(0, search[wordIterator].length()); // удаляем найденное из строки
                        tokenString.append('P');// добавляем токен
                    }
                    wordIterator++;// к следующему префиксу
                }

                {// ищем void
                    String s = "void";
                    int poz = 0;// проверяем эквивалентность цепочек
                    while (s.length() > poz && inCopy.length() > poz) {
                        if (s.charAt(poz) != inCopy.charAt(poz))
                            break;// к сожалению это нельзя поместить в условие выхода, выдаст ошибку выхода за границы
                        poz++;
                    }

                    if (poz == s.length()) {// если цепочка пройдена целиком
                        checkedFlag = true; // символ найден
                        inCopy.delete(0, s.length()); // удаляем найденное из строки
                        tokenString.append('V');// добавляем токен
                    }
                }


                // ищем типы переменных
                search = new String[]{
                        "char",
                        "short",
                        "int",
                        "long_long",
                        "long_double",
                        "long",
                        "float",
                        "double"
                };
                wordIterator = 0;
                while (wordIterator < search.length && !checkedFlag) {// пробегаемся по массиву

                    int poz = 0;// проверяем эквивалентность цепочек
                    while (search[wordIterator].length() > poz && inCopy.length() > poz) {
                        if (search[wordIterator].charAt(poz) != inCopy.charAt(poz))
                            break;// к сожалению это нельзя поместить в условие выхода, выдаст ошибку выхода за границы
                        poz++;
                    }

                    if (poz == search[wordIterator].length()) {// если цепочка пройдена целиком
                        checkedFlag = true; // символ найден
                        inCopy.delete(0, search[wordIterator].length()); // удаляем найденное из строки
                        tokenString.append('T');// добавляем токен
                    }
                    wordIterator++;// К следующему типу
                }

            }

            if (!checkedFlag) {// если за текущую итерацию ничего не удалялось
                char currentChar = inCopy.charAt(0);// получаем текущий символ

                if (currentChar == ' ') {
                    tokenString.append(' ');// добавляем пробел в токены
                    //checkedFlag = true; // символ найден

                    // удаляем этот и следующие пробелы если они есть
                    while (inCopy.length() != 0) {
                        if (inCopy.charAt(0) != ' ') break;

                        inCopy.deleteCharAt(0);
                    }
                } else if (// A..Z || a..z ||_||-  символ строки
                        65 <= currentChar && currentChar <= 90 || 97 <= currentChar && currentChar <= 122
                                || currentChar == '_' || currentChar == '-') {
                    if (tokenString.charAt(tokenString.length() - 1) == 'T') { // если до этого был тип без пробела, затирем
                        tokenString.deleteCharAt(tokenString.length() - 1);
                        tokenString.append('I');
                    } else if (tokenString.charAt(tokenString.length() - 1) != 'I') {// если до этого идентификатор сливаем их вместе
                        tokenString.append('I');
                    }
                    //checkedFlag = true; // символ найден
                    inCopy.deleteCharAt(0);// удаляем текущий символ

                } else if (48 <= currentChar && currentChar <= 57) {// 0..9 символ строки

                    if (tokenString.charAt(tokenString.length() - 1) == 'T') { // если до этого был тип без пробела, затирем
                        tokenString.deleteCharAt(tokenString.length() - 1);
                        tokenString.append('I');
                    } else if (tokenString.charAt(tokenString.length() - 1) != 'I') {
                        // если до этого не стоял другой символ, идентификатор
                        throw new Exception("Identifier cannot start from number! \"" + currentChar + "\"");

                    }
                    //checkedFlag = true; // символ найден
                    inCopy.deleteCharAt(0);// удаляем текущий символ

                } else if ('(' == currentChar || ')' == currentChar || ',' == currentChar || ';' == currentChar) {//
                    tokenString.append(currentChar);
                    //checkedFlag = true; // символ найден
                    inCopy.deleteCharAt(0);// удаляем текущий символ

                } else {// если найденный символ не известен
                    throw new Exception("String contains forbidden symbol! \"" + currentChar + "\"");
                }


            }

        }

        return tokenString.deleteCharAt(0).toString();

    }

/*
        P	T	I	V	(	,	);
    1	2	3	E	4	E	E	E
    2	E	3	E	E	E	E	E
    3	E	E	4	E	E	E	E
    4	E	E	E	E	5	E	E
    5	6	7	E	E	E	E	K
    6	E	7	E	E	E	E	E
    7	E	E	8	E	E	E	E
    8	E	E	E	E	E	9	K
    9	6	7	E	E	E	E	E
*/

    static int[][] stateCodes = {
            //    P  T  I  V  (  ,  );
            /*1*/{2, 3, 0, 3, 0, 0, 0},
            /*2*/{0, 3, 0, 0, 0, 0, 0},
            /*3*/{0, 0, 4, 0, 0, 0, 0},
            /*4*/{0, 0, 0, 0, 5, 0, 0},
            /*5*/{6, 7, 0, 0, 0, 0, 10},
            /*6*/{0, 7, 0, 0, 0, 0, 0},
            /*7*/{0, 0, 8, 0, 0, 0, 0},
            /*8*/{0, 0, 0, 0, 0, 9, 10},
            /*9*/{6, 7, 0, 0, 0, 0, 0}
    };

    static boolean isPrototypeInTokensLine(String tokens) throws Exception {
        int qState = 1;// состояние автомата

        StringBuilder tokensCopy = new StringBuilder(tokens);

        while (qState != 10 && qState != 0 && tokensCopy.length() != 0) {


            switch (tokensCopy.charAt(0)) {
                case 'P':
                    if (stateCodes[qState - 1][0] == 0) {// ошибка
                        throw new Exception("Parse error! Code:[symbol->'P', state->" + qState + "]");

                    } else {
                        qState = stateCodes[qState - 1][0];// меняем состояние на следующее
                    }
                    break;
                case 'T':
                    if (stateCodes[qState - 1][1] == 0) {// ошибка
                        throw new Exception("Parse error! Code:[symbol->'T', state->" + qState + "]");
                    } else {
                        qState = stateCodes[qState - 1][1];// меняем состояние на следующее
                    }
                    break;
                case 'I':
                    if (stateCodes[qState - 1][2] == 0) {// ошибка
                        throw new Exception("Parse error! Code:[symbol->'I', state->" + qState + "]");
                    } else {
                        qState = stateCodes[qState - 1][2];// меняем состояние на следующее
                    }
                    break;
                case 'V':
                    if (stateCodes[qState - 1][3] == 0) {// ошибка
                        throw new Exception("Parse error! Code:[symbol->'V', state->" + qState + "]");
                    } else {
                        qState = stateCodes[qState - 1][3];// меняем состояние на следующее
                    }
                    break;
                case '(':
                    if (stateCodes[qState - 1][4] == 0) {// ошибка
                        throw new Exception("Parse error! Code:[symbol->'(', state->" + qState + "]");
                    } else {
                        qState = stateCodes[qState - 1][4];// меняем состояние на следующее
                    }
                    break;
                case ',':
                    if (stateCodes[qState - 1][5] == 0) {// ошибка
                        throw new Exception("Parse error! Code:[symbol->',', state->" + qState + "]");
                    } else {
                        qState = stateCodes[qState - 1][5];// меняем состояние на следующее
                    }
                    break;
                case ')':
                    if (tokensCopy.length() > 1) {
                        if (tokensCopy.charAt(1) == ';') {
                            if (stateCodes[qState - 1][6] == 0) {// ошибка
                                throw new Exception("Parse error! Code:[symbol->')', state->" + qState + "]");
                            } else {
                                qState = stateCodes[qState - 1][6];// меняем состояние на следующее
                            }

                        } else {
                            throw new Exception("Parse error! Code:[symbol->')', state->" + qState + "] - \";\" error2");
                        }
                    } else {
                        throw new Exception("Parse error! Code:[symbol->')', state->" + qState + "] - \";\" error1");
                    }
                    break;
                default:
                    // тк строка уже разбита на токены, пробелы можно игнорировать
            }

            // удаляем обработанный символ
            tokensCopy.deleteCharAt(0);
        }

        if (tokensCopy.length() == 0 && qState != 10) {// не найден символ завершения
            throw new Exception("Parse error! no \");\" ");
        }

        return true;
    }

}
