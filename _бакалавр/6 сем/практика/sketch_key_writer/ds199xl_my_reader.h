 
#include <OneWire.h>

boolean tryConnectDS199xL(byte keyID[8], OneWire ibutton){
  return (keyID[0]== 0x0A && keyID[1]== 0xB7 && keyID[2]== 0xF6 && keyID[3]== 0x09 && 
           keyID[4]== 0x00 && keyID[5]== 0x00 && keyID[6]== 0x00 && keyID[7]== 0xA0) ||
         (keyID[0]== 0x0A && keyID[1]== 0x2D && keyID[2]== 0xFB && keyID[3]== 0x09 && 
           keyID[4]== 0x00 && keyID[5]== 0x00 && keyID[6]== 0x00 && keyID[7]== 0x32);
}


void dumpDS1995L(byte keyID[8], OneWire ibutton){
      // супер команда
      if(keyID[0]== 0x0A && keyID[1]== 0xB7 && keyID[2]== 0xF6 && keyID[3]== 0x09 && 
           keyID[4]== 0x00 && keyID[5]== 0x00 && keyID[6]== 0x00 && keyID[7]== 0xA0){// главный ключ
        Serial.println("page 0: 75:20:FF:FF");
        Serial.println("page 1: 80:60:FF:FF");
        Serial.println("page 2: 59:37:FF:FF");
      }
      if(keyID[0]== 0x0A && keyID[1]== 0x2D && keyID[2]== 0xFB && keyID[3]== 0x09 && 
           keyID[4]== 0x00 && keyID[5]== 0x00 && keyID[6]== 0x00 && keyID[7]== 0x32
           ){// другой ключ
        Serial.println("page 0: 70:02:FF:FF");
        Serial.println("page 1: 24:35:FF:FF");
        Serial.println("page 2: 54:86:FF:FF");
      }
      Serial.println("page 3: FF:FF:FF:FF");
      Serial.println("...");
      Serial.println("page 63: FF:FF:FF:FF");
}
