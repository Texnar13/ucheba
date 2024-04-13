#include "src/U8glib2.h"
#include "extended2.h"

//#include "pitches.h"

#define iButtonPin A3      // Линия data ibutton
#define ACpin 6            // Вход аналогового компаратора 3В для Cyfral/Metacom

#define btnPin 10           // Кнопка переключения режима чтение/запись
#define buttonNextPin 4           // Кнопка вперед
#define buttonPrevPin 5           // Кнопка 
#define buttonMorePin 8           // Кнопка 
#define buttonLessPin 7           // Кнопка 

//#define speakerPin 9       // Спикер, он же buzzer, он же beeper


// ----------------------------- переменные для работы с ключом -----------------------------

byte addr[8];                             // временный буфер
byte keyID[8] = {255,255,255,255,255,255,255,255};// ID ключа для записи
bool readflag = true;                    // флаг сигнализируе, что данные с ключа успечно прочианы в ардуино
bool writeflag = false;                   // режим запись/чтение
enum EmRWType {TM01, RW1990_1, RW1990_2, TM2004};                            // тип болванки
enum EmkeyType {keyUnknown, keyDallas, keyTM2004, keyCyfral, keyMetacom};    // тип оригинального ключа  
EmkeyType keyType;


// выбранный номер регистра подсвечиваемый на диплее
uint8_t selectedRegisterIndex = 0;




// -----------------------------------------------------------------------------------
// ----------------------------- УСТАНОВКА И ГЛАВНЫЙ ЦИКЛ ----------------------------
// -----------------------------------------------------------------------------------

void setup() {
  pinMode(btnPin, INPUT_PULLUP); // включаем чтение и подягиваем пин кнопки режима к +5В
  pinMode(buttonNextPin, INPUT_PULLUP);
  pinMode(buttonPrevPin, INPUT_PULLUP);
  pinMode(buttonMorePin, INPUT_PULLUP);
  pinMode(buttonLessPin, INPUT_PULLUP);
  
  //pinMode(speakerPin, OUTPUT);
  pinMode(ACpin, INPUT); // Вход аналогового компаратора 3В для Cyfral  
                  
  

  prepeareDisplay();
  // выводим надпись режим чтения (todo и возможно что кода еще нет)
  out_titleString("READ");
  out_redraw();
  
}

// переменные кнопок
bool btnBuffer;

bool btnClick;
bool preBtnPinSt = true;

bool buttonNextPressState = false;
uint16_t buttonNextPreviousState  = false;

bool buttonPrevPressState = false;
uint16_t buttonPrevPreviousState  = false;

bool buttonMorePressState = false;
uint16_t buttonMorePressTime = 0;
uint16_t buttonMorePreviousState  = false;

bool buttonLessPressState = false;
uint16_t buttonLessPressTime = 0;
uint16_t buttonLessPreviousState  = false;



void loop() {
  // основная кнопка
  btnBuffer = digitalRead(btnPin);
  btnClick =((btnBuffer == LOW) && (preBtnPinSt == HIGH)); 
  preBtnPinSt = btnBuffer;
  
  // кнопка вперёд
  // считываем состояние
  btnBuffer = !digitalRead(buttonNextPin);
  buttonNextPressState = ((btnBuffer == HIGH) && (buttonNextPreviousState == LOW)); 
  buttonNextPreviousState = btnBuffer;
  // если нажата
  if(buttonNextPressState ){
    selectedRegisterIndex =
      (selectedRegisterIndex == 7)? (0):(selectedRegisterIndex + 1);
    out_redraw();
  }
  
  
  // если кнопка нажата
  if ((Serial.read() == 't') || btnClick) {  // переключаель режима чтение/запись

    // если чуть раньше код был успешно прочтен
    if (readflag == true) {
      writeflag = !writeflag; 

      
      // выводим на экран и в порт, текущий режим
      if (writeflag) out_titleString("WRITE");
        else out_titleString("READ");
      out_redraw();
    } else {
      // если предыдущий код не был прочтен и была нажата кнопка возвращаем прибор в режим 
      //  без кода, готовый к чтению (точнее просто выводим об этом информацию)
      out_titleString("NO CODE"); out_redraw();
      out_titleString("READ"); out_redraw();
    }
  }

  
  // если найден ключ dallas
  boolean isss = IB_search(addr);
  if(isss){
    Serial.print("IB_search=");
    Serial.println(isss);
  }
  if (isss) {  // запускаем поиск dallas
    // если режим записи
    if (writeflag){ 
      if (readflag == true) 
        write2iBtn();
      else {          // сюда испонение не должно попасть
          out_titleString("ERROR");out_redraw();
          out_titleString("READ");out_redraw();
          writeflag = false;
      }
    }else{
      // режим чтения
      out_titleString("PROCESSING...");out_redraw();
      readflag = readiBtn();       // чиаем ключ dallas
      if (readflag) {
        out_titleString("SUCESS!");out_redraw();
      }else{
        Serial.println("CRC is not valid!");
        out_titleString("ERROR");out_redraw();
      }

      out_titleString("READ");out_redraw();
    }
  }else{
    IB_reset_search();
  }
}





// -----------------------------------------------------------------------------------
// ----------------------------- ДИСПЛЕЙ                 -----------------------------
// -----------------------------------------------------------------------------------

// переменная дисплея
U8GLIB_SSD1306_128X64 u8g(U8G_I2C_OPT_NONE|U8G_I2C_OPT_DEV_0);  // I2C / TWI 
  // flip screen, if required
  //u8g.setRot180();


char lastTitle[20] = "";
char lastCodeString[40] = "";



  
void prepeareDisplay(){
  u8g.setFont(u8g_font_6x10);
  u8g.setFontRefHeightExtendedText();
  u8g.setDefaultForegroundColor();
  u8g.setFontPosTop();
}

void out_titleString(const char* str){// вывод надписи в заголовок. максимум 11 символов
  strncpy(lastTitle, str, strlen(str));
  *(lastTitle + strlen(str)) = '\0';
  
  //out_redraw();
}


  uint8_t resultStartPos = 0;
  uint8_t resultEndPos = 1; 
  uint8_t abc = 0;
void out_redraw(){
  
  // экран состоит из нескольких страниц, на каждой из которых надо выполнять одни и те же команды
  // большой символ помещается на 4х страницах, маленький на 2х
  u8g.firstPage(); 

  // вывод текущего заголовка
  u8g.setScale2x2();
  u8g.firstPage(); 
  for(uint8_t page = 0; page < 2; page++){
    u8g.drawStr(0, 0, lastTitle);
    u8g.nextPage();
  }
  u8g.undoScale(); 


  // если есть корректный код
  if(readflag){
      // создание строки кода
      *(lastCodeString) = '\0';
      for(uint8_t keyPart = 0; keyPart < 8; keyPart++){
        itoa(*(keyID + keyPart), lastCodeString + strlen(lastCodeString), DEC);
        if(keyPart != 7)
          strcat(lastCodeString, ":"); 
      }
    
      
      // вывод кода
      char firstHalf[40] = "";
      char secondHalf[40] = "";
      char buff[10] = "";
      uint8_t firstLen = 0;
      *(firstHalf) = '\0';
      for(uint8_t keyPart = 0; keyPart < 8; keyPart++){
        
        itoa(*(keyID + keyPart), buff, DEC);
        if(keyPart >= 4){
          strcat(secondHalf, buff);
          if(keyPart != 7)
            strcat(secondHalf, ":");  
        }else{
          firstLen += strlen(buff)+1;    
          strcat(firstHalf, buff);
          strcat(firstHalf, ":"); 
        }  
      }
    
      
      u8g.nextPage();
      u8g.drawStr(0, 24, firstHalf);
      
    
    
      boolean outOfBounds = false;
      int8_t a;
      
      // вичисление позиции подчеркивания
      char temp[sizeof(lastCodeString)] = "";
      strcpy(temp, lastCodeString);
      *(temp+sizeof(lastCodeString)) = '\0';
    
      resultStartPos = 0;
      resultEndPos = 1; 
      for(uint8_t numberPoz = 0; numberPoz < selectedRegisterIndex && !outOfBounds; numberPoz++){
        a = whatApos(temp);
        if(a == -1){
          outOfBounds = true;  
        }
        resultStartPos += a +1; 
        strncpy(temp, (lastCodeString + resultStartPos), strlen(lastCodeString)); 
        *(temp + strlen(lastCodeString) - resultStartPos) = '\0'; 
      }
      
      u8g.nextPage();
      if(!outOfBounds){
        a = whatApos(temp);
        if(a == -1){
          resultEndPos = resultStartPos+1;
        }else{
          resultEndPos = a + resultStartPos; 
        } 
    
        if(resultStartPos < firstLen){
          // выводим его
          abc = 0;
          while(abc < resultStartPos){
            temp[abc] = ' ';
            abc++;
          }
          while(abc < resultEndPos){
            temp[abc] = '_';
            abc++;
          }
          *(temp+abc) = '\0';
          u8g.drawStr(0, 26, temp);
        }
      }
    
      u8g.drawStr(0, 36, secondHalf);
      u8g.nextPage();
      u8g.drawStr(0, 36, secondHalf);
    
      if(!outOfBounds && resultStartPos >= firstLen){
          resultStartPos -= firstLen;
          resultEndPos -= firstLen;
    
          // выводим его
          abc = 0;
          while(abc < resultStartPos){
            temp[abc] = ' ';
            abc++;
          }
          while(abc < resultEndPos){
            temp[abc] = '_';
            abc++;
          }
          *(temp+abc) = '\0';
          
          u8g.drawStr(0, 38, temp);
      }
  }else{
    
      u8g.nextPage();
      u8g.drawStr(0, 24, "No Code");
  }

  

  // очищаем содержимое остальных страниц
  while(u8g.nextPage()){}
}

int8_t whatApos(char* str){
  int8_t i = 0;
  while (str[i] && str[i] != ':') ++i;
  return ':' == str[i] ? i : -1;
}










// -----------------------------------------------------------------------------------
// ----------------------------- МЕТОДЫ РАБОТЫ С КЛЮЧАМИ -----------------------------
// -----------------------------------------------------------------------------------



//*************** dallas **************
EmRWType getRWtype(){    
   byte answer;
  // TM01 это неизвестный тип болванки, делается попытка записи TM-01 без финализации для dallas или c финализацией под cyfral или metacom
  // RW1990_1 - dallas-совместимые RW-1990, RW-1990.1, ТМ-08, ТМ-08v2 
  // RW1990_2 - dallas-совместимая RW-1990.2
  // TM2004 - dallas-совместимая TM2004 в доп. памятью 1кб
  // пробуем определить RW-1990.1
  IB_reset(); IB_write(0xD1); // проуем снять флаг записи для RW-1990.1
  IB_write_bit(1);                 // записываем значение флага записи = 1 - отключаем запись
  delay(10); pinMode(iButtonPin, INPUT);
  IB_reset(); IB_write(0xB5); // send 0xB5 - запрос на чтение флага записи
  answer = IB_read();
  //Serial.print("\n Answer RW-1990.1: "); Serial.println(answer, HEX);
  if (answer == 0xFE){
    Serial.println(" Type: dallas RW-1990.1 ");
    return RW1990_1;            // это RW-1990.1
  }
  // пробуем определить RW-1990.2
  IB_reset(); IB_write(0x1D);  // проуем установить флаг записи для RW-1990.2 
  IB_write_bit(1);                  // записываем значение флага записи = 1 - включаем запись
  delay(10); pinMode(iButtonPin, INPUT);
  IB_reset(); IB_write(0x1E);  // send 0x1E - запрос на чтение флага записи
  answer = IB_read();
  //Serial.print("\n Answer RW-1990.2: "); Serial.println(answer, HEX);
  if (answer == 0xFE){
    IB_reset(); IB_write(0x1D); // возвращаем оратно запрет записи для RW-1990.2
    IB_write_bit(0);                 // записываем значение флага записи = 0 - выключаем запись
    delay(10); pinMode(iButtonPin, INPUT);
    Serial.println(" Type: dallas RW-1990.2 ");
    return RW1990_2; // это RW-1990.2
  }
  //}
  // пробуем определить TM-2004
  IB_reset(); IB_write(0x33);                     // посылаем команду чтения ROM для перевода в расширенный 3-х байтовый режим
  for ( byte i=0; i<8; i++) IB_read();                 //читаем данные ключа
  IB_write(0xAA);                                      // пробуем прочитать регистр статуса для TM-2004    
  IB_write(0x00); IB_write(0x00);                 // передаем адрес для считывания
  answer = IB_read();                                  // читаем CRC комманды и адреса
  //Serial.print("TM2004 CRC: "); Serial.println(answer, HEX);
  byte m1[3] = {0xAA, 0,0};                                 // вычисляем CRC комманды
  if (IB_crc8(m1, 3) == answer) {
    answer = IB_read();                                  // читаем регистр статуса
    //Serial.print(" status: "); Serial.println(answer, HEX);
    Serial.println(" Type: dallas TM2004");
    IB_reset();
    return TM2004; // это Type: TM2004
  }
  IB_reset();
  Serial.println(" Type: dallas unknown, trying TM-01! ");
  return TM01;                              // это неизвестный тип DS1990, нужно перебирать алгоритмы записи (TM-01)
}

bool write2iBtnTM2004(){                // функция записи на TM2004
  byte answer; bool result = true;
  IB_reset();
  IB_write(0x3C);                                      // команда записи ROM для TM-2004    
  IB_write(0x00); IB_write(0x00);                 // передаем адрес с которого начинается запись

  boolean isLableShowed = true;
  for (byte i = 0; i<8; i++){
    
    // мигание экраном
    if(isLableShowed){
      out_titleString("DONT REMOVE");out_redraw();
    }else{
      out_titleString("");out_redraw();
    }
    isLableShowed = !isLableShowed;

    IB_write(keyID[i]);
    answer = IB_read();
    //if (IB_crc8(m1, 3) != answer){result = false; break;}     // crc не верный
    delayMicroseconds(600); IB_write_bit(1); delay(50);         // испульс записи
    pinMode(iButtonPin, INPUT);
    Serial.print('*');
    if (keyID[i] != IB_read()) { result = false; break;}    //читаем записанный байт и сравниваем, с тем что должно записаться
  } 
  if (!result){
    IB_reset();
    Serial.println(" The key copy faild");
    out_titleString("ERROR");out_redraw();
    out_titleString("WRITE");out_redraw();
    return false;    
  }
  IB_reset();
  Serial.println(" The key has copied successesfully");
  out_titleString("SUCESS!");out_redraw();
  delay(500);
  out_titleString("WRITE");out_redraw();
  return true;
}

bool write2iBtnRW1990_1_2_TM01(EmRWType rwType){              // функция записи на RW1990.1, RW1990.2, TM-01C(F)
  byte rwCmd, rwFlag = 1;
  switch (rwType){
    case TM01: rwCmd = 0xC1; break;                   //TM-01C(F)
    case RW1990_1: rwCmd = 0xD1; rwFlag = 0; break;  // RW1990.1  флаг записи инвертирован
    case RW1990_2: rwCmd = 0x1D; break;              // RW1990.2
  }
  IB_reset(); IB_write(rwCmd);       // send 0xD1 - флаг записи
  IB_write_bit(rwFlag);                   // записываем значение флага записи = 1 - разрешить запись
  delay(10); pinMode(iButtonPin, INPUT);
  IB_reset(); IB_write(0xD5);        // команда на запись
  
  boolean isLableShowed = true;
  for (byte i = 0; i<8; i++){
    
    // мигание экраном
    if(isLableShowed){
      out_titleString("DONT REMOVE");
    }else{
      out_titleString("");
    }
    out_redraw();
    isLableShowed = !isLableShowed;
    
    if (rwType == RW1990_1) BurnByte(~keyID[i]);      // запись происходит инверсно для RW1990.1
      else BurnByte(keyID[i]);
    Serial.print('*');
  } 
  IB_write(rwCmd);                     // send 0xD1 - флаг записи
  IB_write_bit(!rwFlag);               // записываем значение флага записи = 1 - отключаем запись
  delay(10); pinMode(iButtonPin, INPUT);

     
  if (!dataIsBurningOK()){          // проверяем корректность записи
    Serial.println(" The key copy faild");
    out_titleString("ERROR");out_redraw();
    out_titleString("WRITE");out_redraw();
    return false;
  }
  Serial.println(" The key has copied successesfully");
  if ((keyType == keyMetacom)||(keyType == keyCyfral)){      //переводим ключ из формата dallas
    IB_reset();
    if (keyType == keyCyfral) IB_write(0xCA);       // send 0xCA - флаг финализации Cyfral
      else IB_write(0xCB);                       // send 0xCA - флаг финализации metacom
    IB_write_bit(1);                             // записываем значение флага финализации = 1 - перевезти формат
    delay(10); pinMode(iButtonPin, INPUT);
  }
  out_titleString("SUCESS!");out_redraw();
  delay(500);
  out_titleString("WRITE");out_redraw();
  return true;
}

void BurnByte(byte data){
  for(byte n_bit=0; n_bit<8; n_bit++){ 
    IB_write_bit(data & 1);  
    delay(5);                        // даем время на прошивку каждого бита до 10 мс
    data = data >> 1;                // переходим к следующему bit
  }
  pinMode(iButtonPin, INPUT);
}

bool dataIsBurningOK(){
  byte buff[8];
  if (!IB_reset()) return false;
  IB_write(0x33);
  IB_read_bytes(buff, 8);
  byte Check = 0;
  for (byte i = 0; i < 8; i++) 
    if (keyID[i] == buff[i]) Check++;      // сравниваем код для записи с тем, что уже записано в ключе.
  if (Check != 8) return false;             // если коды совпадают, ключ успешно скопирован
  return true;
}

bool write2iBtn(){
  int Check = 0, CheckSumNewKey = 0;
  Serial.print("The new key code is: ");
  for (byte i = 0; i < 8; i++) {
    Serial.print(addr[i], HEX); Serial.print(":");
    CheckSumNewKey += keyID[i];  
    if (keyID[i] == addr[i]) Check++;    // сравниваем код для записи с тем, что уже записано в ключе.
  }
  if (Check == 8) {                     // если коды совпадают, ничего писать не нужно
    Serial.println(" it is the same key. Writing in not needed.");
    out_titleString("ALREADY WRT");out_redraw();
    delay(500);
    out_titleString("WRITE");out_redraw();
    return false;
  }
  byte rwType = getRWtype(); // определяем тип RW-1990.1 или 1990.2 или TM-01
  Serial.print("\n Burning iButton ID: ");
  if (rwType == TM2004) return write2iBtnTM2004();  //шьем TM2004
    else return write2iBtnRW1990_1_2_TM01(rwType); //пробуем прошить другие форматы
}

bool readiBtn(){
  
  for (byte i = 0; i < 8; i++) {
    Serial.print(addr[i], HEX); Serial.print(":");
    keyID[i] = addr[i];                               // копируем прочтенный код в ReadID
  }
  
  if (addr[0] == 0x01) {                         // это ключ формата dallas
    keyType = keyDallas;
    if (getRWtype() == TM2004) {
      //Serial.println(" Type: dallas TM2004");
      keyType = keyTM2004;
    } //else Serial.println(" Type: dallas RW1990.x");
    if (IB_crc8(addr, 7) != addr[7]) {
      return false;
    }
    return true;
  }
  if ((addr[0]>>4) == 0x0E) Serial.println(" Type: unknown family dallas. May be cyfral in dallas key.");
    else Serial.println(" Type: unknown family dallas");
  keyType = keyUnknown;
  return true;
}
