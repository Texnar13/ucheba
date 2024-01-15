package org.example;


import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;

public class Main {

    public static void main(String[] args) {

        // подключаемся к СУБД
        System.out.println("Инициализация базы.");
        try (MongoClient myMongoClient = MongoClients.create(
                "mongodb://localhost:27017"//"mongodb://user:passwd@localhost:27017/?authSource=test"
        )) {
            // ждем когда MONGODB подключится
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            MongoDatabase db = myMongoClient.getDatabase(DBContract.DB_NAME);

            {// проверка бд на инициализированность

                // коллекция настроек
                MongoCollection<Document> collection =
                        db.getCollection(DBContract.COLLECTION_PREFS);
                // находим первый документ c id = 1
                Document settingsDocument = collection
                        .find(eq("_id", 1))
                        .first();
                // если он еще не был создан, значит БД пустая
                if (settingsDocument == null) {
                    // инициализация документа с номером версии бд
                    settingsDocument = new Document()
                            .append("_id", 1)
                            .append(DBContract.FIELD_PREFS_VERSION, 0);
                    collection.insertOne(settingsDocument);
                }

                {// механизм обновления БД
                    // проверяем самая ли последняя в бд версия
                    int currentVersion = settingsDocument.getInteger(DBContract.FIELD_PREFS_VERSION);
                    if (currentVersion != DBContract.VERSION) {

                        // обновление/инициализирование БД
                        updateDatabase(currentVersion, DBContract.VERSION, db);

                        // обновляем документ настроек в программе (на всякий)
                        settingsDocument.append(DBContract.FIELD_PREFS_VERSION, DBContract.VERSION);
                        // обновляем документ настроек в БД
                        collection.updateOne(eq("_id", 1),
                                set(DBContract.FIELD_PREFS_VERSION, DBContract.VERSION)
                        );
                    }
                }
            }

            System.out.println("Hello and welcome!");

            // инициализация интерфейса пользователя
            App app = new App(db);

            // запуск главного меню
            app.startManMenu();


        }
    }

    private static void updateDatabase(int oldVersion, int newVersion, MongoDatabase db) {
        System.out.println("Update database from:" + oldVersion + "v  to:" + newVersion + "v");

        // пустая БД
        if (oldVersion == 0) {
            // заполняем коллекции операторов и тарифов

            MongoCollection<Document> operators =
                    db.getCollection(DBContract.COLLECTION_OPERATOR);
            // чистка всего
            operators.drop();

            // создание списка операторов
            List<Document> operatorsDocs = new ArrayList<>();
            {
                // список тарифов конкретного оператора
                List<Document> tariffDocsATNT = new ArrayList<>();
                tariffDocsATNT.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "smallTariff")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Минимум функций, только необходимое.")
                        .append(DBContract.FIELD_TARIFF_COST, 100));
                tariffDocsATNT.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "mediumTariff")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Как хлебушек, но с маслом.")
                        .append(DBContract.FIELD_TARIFF_COST, 200));
                tariffDocsATNT.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "SuperTariff")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Любой каприз за ваши деньги.")
                        .append(DBContract.FIELD_TARIFF_COST, 500));
                // создание оператора
                operatorsDocs.add(new Document()
                        .append(DBContract.FIELD_OPERATOR_NAME, "AT&T")
                        .append(DBContract.FIELD_OPERATOR_CODE, "AT&T20CODE")
                        .append(DBContract.FIELD_OPERATOR_NUMBERS_COUNT, 20)
                        .append(DBContract.FIELD_OPERATOR_TARIFFS, tariffDocsATNT)
                );
            }
            {
                // список тарифов конкретного оператора
                List<Document> tariffDocsMTS = new ArrayList<>();
                tariffDocsMTS.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "base")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Только звонки.")
                        .append(DBContract.FIELD_TARIFF_COST, 100));
                tariffDocsMTS.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "turbo")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Звонки + мобильный интернет с раздачей.")
                        .append(DBContract.FIELD_TARIFF_COST, 500));
                // создание оператора
                operatorsDocs.add(new Document()
                        .append(DBContract.FIELD_OPERATOR_NAME, "MTS")
                        .append(DBContract.FIELD_OPERATOR_CODE, "MTS05CODE")
                        .append(DBContract.FIELD_OPERATOR_NUMBERS_COUNT, 5)
                        .append(DBContract.FIELD_OPERATOR_TARIFFS, tariffDocsMTS)
                );
            }
            {
                // список тарифов конкретного оператора
                List<Document> tariffDocsOnLine = new ArrayList<>();
                tariffDocsOnLine.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "asket")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Минимум функций, только необходимое.")
                        .append(DBContract.FIELD_TARIFF_COST, 250));
                tariffDocsOnLine.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "middle man")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Средний такой тариф")
                        .append(DBContract.FIELD_TARIFF_COST, 300));
                tariffDocsOnLine.add(new Document()
                        .append("_id", new ObjectId())
                        .append(DBContract.FIELD_TARIFF_NAME, "gigachad")
                        .append(DBContract.FIELD_TARIFF_DESCRIPTION, "Вы не найдете тарифа лучше!")
                        .append(DBContract.FIELD_TARIFF_COST, 400));
                // создание оператора
                operatorsDocs.add(new Document()
                        .append(DBContract.FIELD_OPERATOR_NAME, "OnLINE")
                        .append(DBContract.FIELD_OPERATOR_CODE, "OnLINE555CODE")
                        .append(DBContract.FIELD_OPERATOR_NUMBERS_COUNT, 555)
                        .append(DBContract.FIELD_OPERATOR_TARIFFS, tariffDocsOnLine)
                );
            }
            operators.insertMany(operatorsDocs);


        }
    }
}