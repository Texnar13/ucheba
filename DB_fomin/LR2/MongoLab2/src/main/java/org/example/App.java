package org.example;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import java.util.function.Consumer;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;

public class App {

    private final MongoDatabase db;
    private final Scanner scanner;

    // инициализация интерфейса
    public App(MongoDatabase db) {
        this.db = db;
        scanner = new Scanner(System.in);
    }

    // запуск работы интерфейса
    void startManMenu() {

        // главный интерфейсный цикл
        boolean isExit = false;
        while (!isExit) {

            System.out.println("""
                    ::::::::::::::::::: Главное меню :::::::::::::::::::
                    Доступные операции:
                      0: Выход из программы;
                      1: Регистрация абонента;
                      2: Просмотр тарифных планов различных операторов;
                      3: Покупка тарифа""");

            // ввод пользователя
            int userInput = -1;
            try {
                userInput = Integer.parseInt(scanner.nextLine());
            } catch (NumberFormatException ignored) {
            }

            // обработка ввода
            switch (userInput) {
                case 0 -> {
                    isExit = true;
                    System.out.println("Завершение работы.");
                }
                case 1 -> registerCaller();
                case 2 -> viewPlans();
                case 3 -> bySomePlan();
                default -> System.out.println("Некорректное число");
            }
            scanner.nextLine();
        }
    }

    // Регистрация абонента
    private void registerCaller() {
        System.out.println("::::::::::::::: Регистрация абонента :::::::::::::::");

        System.out.println("Введите пожалуйста данные абонента:");
        System.out.print("  ФИО:");
        String name = scanner.nextLine();
        System.out.print("  Адрес:");
        String address = scanner.nextLine();
        System.out.print("  Номер паспорта:");
        String passport = scanner.nextLine();

        System.out.print("  Если данные введены верно введите Y:");
        String confirm = scanner.nextLine();
        if (confirm.charAt(0) == 'Y' || confirm.charAt(0) == 'y' ||
                confirm.charAt(0) == 'Н' || confirm.charAt(0) == 'н') {

            // добавление пользователя в бд
            MongoCollection<Document> collection = db.getCollection(DBContract.COLLECTION_CALLER);
            Document document = new Document()
                    .append(DBContract.FIELD_CALLER_NAME, name)
                    .append(DBContract.FIELD_CALLER_ADDRESS, address)
                    .append(DBContract.FIELD_CALLER_PASSPORT, passport)
                    .append(DBContract.FIELD_CALLER_CONNECTION, null);
            collection.insertOne(document);
            ObjectId id = document.getObjectId("_id");

            System.out.println("ID пользователя:" + id);
            System.out.println("::::::::: Абонент успешно зарегистрирован! :::::::::");
        } else {

            System.out.println(":::::::::::::::::: Отмена операции ::::::::::::::::::");
        }
    }

    // Просмотр тарифных планов различных операторов
    private void viewPlans() {
        System.out.println("::::::::::::::: Просмотр тарифных планов :::::::::::::::");
        System.out.println("Список операторов доступных на данный момент:");

        // вывод доступных операторов
        MongoCollection<Document> operators = db.getCollection(DBContract.COLLECTION_OPERATOR);
        operators.find().forEach((Consumer<Document>) document -> {
            System.out.printf(" - %s Код оператора: %s Количество номеров: %d Количество тарифов: %d \n",
                    document.getString(DBContract.FIELD_OPERATOR_NAME),
                    document.getString(DBContract.FIELD_OPERATOR_CODE),
                    document.getInteger(DBContract.FIELD_OPERATOR_NUMBERS_COUNT),
                    document.getList(DBContract.FIELD_OPERATOR_TARIFFS, Document.class).size());
        });

        // выбор оператора
        System.out.println("Выберите нужного оператора введя его код (пустая строка - выход):");
        String input = scanner.nextLine();
        Document selectedOperator = operators.find(eq(DBContract.FIELD_OPERATOR_CODE, input)).first();
        if (selectedOperator != null) {

            // получение списка тарифов
            Iterator<Document> tariffs = selectedOperator
                    .getList(DBContract.FIELD_OPERATOR_TARIFFS, Document.class)
                    .iterator();

            // вывод тарифов
            System.out.println("Тарифы данного оператора (Для покупки тарифа используется его название):");
            while (tariffs.hasNext()) {
                Document tariff = tariffs.next();

                System.out.printf(" - Название тарифа:%s  Стоимость:%d  Описание:%s\n",
                        tariff.getString(DBContract.FIELD_TARIFF_NAME),
                        tariff.getInteger(DBContract.FIELD_TARIFF_COST),
                        tariff.getString(DBContract.FIELD_TARIFF_DESCRIPTION)
                );
            }
        }
    }

    // Покупка абонентом тарифа
    private void bySomePlan() {
        System.out.println("::::::::::::::: Покупка тарифного плана :::::::::::::::");


        MongoCollection<Document> callers = db.getCollection(DBContract.COLLECTION_CALLER);
        // Здесь можно вывести список пользователей... потом

        System.out.println("Введите паспортные данные абонента:");
        Document selectedCaller = callers.find(eq(DBContract.FIELD_CALLER_PASSPORT, scanner.nextLine())).first();
        if (selectedCaller != null) {
            System.out.println("Абонент найден:");
            System.out.println(" - Имя:" + selectedCaller.getString(DBContract.FIELD_CALLER_NAME));
            System.out.println(" - Адрес:" + selectedCaller.getString(DBContract.FIELD_CALLER_ADDRESS));
            System.out.println(" - Паспорт:" + selectedCaller.getString(DBContract.FIELD_CALLER_PASSPORT));

            // текущее соединение
            Document connection = (Document) selectedCaller.get(DBContract.FIELD_CALLER_CONNECTION);
            if (connection == null) {
                System.out.println(" - Тарифного плана пока нет!");
            } else {

                System.out.println(" - Подключен тарифный план:");

                // загружаем данные об операторе и тарифе
                MongoCollection<Document> operators = db.getCollection(DBContract.COLLECTION_OPERATOR);
                Document operator =
                        operators.find(eq("_id", connection.getObjectId(DBContract.FIELD_CONNECTION_OPERATOR))).first();

                if(operator != null) {
                    String tariffName = null;
                    Iterator<Document> tariffsIterator =
                            operator.getList(DBContract.FIELD_OPERATOR_TARIFFS, Document.class).iterator();
                    while (tariffsIterator.hasNext() && tariffName == null) {
                        Document document = tariffsIterator.next();
                        if (document.getObjectId("_id").equals(connection.getObjectId(DBContract.FIELD_CONNECTION_TARIFF_PLAN))) {
                            tariffName = document.getString(DBContract.FIELD_TARIFF_NAME);
                        }
                    }
                    System.out.println("   + Оператор:" +
                            ((operator != null) ?
                                    (operator.getString(DBContract.FIELD_OPERATOR_NAME)) :
                                    ("Отсутствует")));
                    System.out.println("   + Тарифный план:" + tariffName);
                }else{
                    System.out.println("   + Оператор:Отсутствует \n   + Тарифный план:Отсутствует");
                }
                System.out.println("   + Дата подключения:" + connection.getString(DBContract.FIELD_CONNECTION_START_DATE));
                System.out.println("   + Телефон:" + connection.getString(DBContract.FIELD_CONNECTION_PHONE_NUMBER));
                System.out.println("   + Задолженность:" + connection.getInteger(DBContract.FIELD_CONNECTION_ARREARS));
            }

            System.out.println("Покупка/смена тарифного плана: ");

            // вывод доступных операторов
            MongoCollection<Document> operators = db.getCollection(DBContract.COLLECTION_OPERATOR);
            operators.find().forEach((Consumer<Document>) document ->
                    System.out.printf(" - %s Код оператора: %s \n",
                            document.getString(DBContract.FIELD_OPERATOR_NAME),
                            document.getString(DBContract.FIELD_OPERATOR_CODE)));

            // выбор оператора
            System.out.println("Введите код оператора: ");
            Document selectedOperator = operators.find(eq(DBContract.FIELD_OPERATOR_CODE, scanner.nextLine())).first();
            if (selectedOperator == null) {
                System.out.println("Оператор не найден.");
            } else {
                // Правда код с List не будет работать на большом количестве данных
                // (он загружает сразу всю коллекцию в отличие от курсора(FindIterable))
                // по этому тарифов у оператора не может быть больше например 100

                // получение списка тарифов
                List<Document> tariffs = selectedOperator
                        .getList(DBContract.FIELD_OPERATOR_TARIFFS, Document.class);

                {// вывод тарифов
                    Iterator<Document> tariffsI = tariffs.iterator();
                    System.out.println("Список тарифов оператора:");
                    while (tariffsI.hasNext()) {
                        Document tariff = tariffsI.next();
                        System.out.println(" - " + tariff.getString(DBContract.FIELD_TARIFF_NAME));
                    }
                }

                System.out.println("Введите название тарифа: ");
                {// выбор тарифа
                    String input = scanner.nextLine();

                    ObjectId finDtariff = null;

                    // проходимся по коллекции тарифов
                    Iterator<Document> tariffsI = tariffs.iterator();
                    while (tariffsI.hasNext() && finDtariff == null) {
                        // если у этого тарифа нужное имя
                        Document tariffUnit = tariffsI.next();
                        if (input.equals(tariffUnit.getString(DBContract.FIELD_TARIFF_NAME))) {
                            finDtariff = tariffUnit.getObjectId("_id");
                        }
                    }
                    // Если такой тариф есть, добавляем CONNECTION
                    if (finDtariff != null) {

                        // создаем соединение
                        Document document = new Document()
                                .append(DBContract.FIELD_CONNECTION_OPERATOR, selectedOperator.getObjectId("_id"))
                                .append(DBContract.FIELD_CONNECTION_TARIFF_PLAN, finDtariff)
                                .append(DBContract.FIELD_CONNECTION_START_DATE,
                                        new SimpleDateFormat("yyyy.MM.dd").format(new Date()))
                                .append(DBContract.FIELD_CONNECTION_PHONE_NUMBER, "88000000")
                                .append(DBContract.FIELD_CONNECTION_ARREARS, 0);

                        // добавляем CONNECTION в Caller
                        callers.updateOne(
                                eq("_id", selectedCaller.getObjectId("_id")),
                                set(DBContract.FIELD_CALLER_CONNECTION, document));

                        System.out.println("Подключение выполнено успешно");
                    }
                }
            }
        }
    }
}
