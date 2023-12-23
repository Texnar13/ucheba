package org.example;

public class DBContract {

    // константы с названиями полей и коллекций
    public static final String DB_NAME = "Сommunication3K";

    public static final String COLLECTION_PREFS = "Preferences";
    /*
     * P _Id : Integer
     *   version : String
     * */
    public static final String FIELD_PREFS_VERSION = "version";
    // Текущая версия БД
    public static final int VERSION = 2;


    public static final String COLLECTION_CALLER = "Caller";
    /*
     * P _id : ID
     *   name : String
     *   address : String
     *   passport : String
     *   conn : Connection
     * */
    public static final String FIELD_CALLER_NAME = "name";
    public static final String FIELD_CALLER_ADDRESS = "address";
    public static final String FIELD_CALLER_PASSPORT = "passport";
    public static final String FIELD_CALLER_CONNECTION = "conn";

    public static final String COLLECTION_CONNECTION = "Connection";
    /*
     * P _id : ID
     * F operator : ID
     * F tariffPLan : ID
     *   startDate : Date
     *   phoneNumber : String
     *   arrears : Integer
     * */
    public static final String FIELD_CONNECTION_OPERATOR = "operator";
    public static final String FIELD_CONNECTION_TARIFF_PLAN = "tariffPLan";
    public static final String FIELD_CONNECTION_START_DATE = "startDate";
    public static final String FIELD_CONNECTION_PHONE_NUMBER = "phoneNumber";
    public static final String FIELD_CONNECTION_ARREARS = "arrears";


    public static final String COLLECTION_OPERATOR = "Operator";
    /*
     * P _Id : ID
     *   name : String
     *   code : String
     *   numbersCount : Integer
     *   tariffs : TariffPlan[]
     * */
    public static final String FIELD_OPERATOR_NAME = "name";
    public static final String FIELD_OPERATOR_CODE = "code";
    public static final String FIELD_OPERATOR_NUMBERS_COUNT = "numbersCount";
    public static final String FIELD_OPERATOR_TARIFFS = "tariffs";


    public static final String COLLECTION_TARIFF = "TariffPlan";
    /*
     * P _id : ID
     *   name : String
     *   description : String
     *   costPerMonth : Integer
     * */
    public static final String FIELD_TARIFF_NAME = "name";
    public static final String FIELD_TARIFF_DESCRIPTION = "description";
    public static final String FIELD_TARIFF_COST = "costPerMonth";

}