#include <AltSoftSerial.h>

AltSoftSerial altSerial;

byte b;
byte len;
byte i;
byte ch;

void setup() {
  Serial.begin(115200);
  while (!Serial) ; // wait for Arduino Serial Monitor to open
  Serial.println("Serial Snif Begin Display <- TRX");
  altSerial.begin(62000);
  tone(10, 1000, 100);
}

void loop() {
  Serial.println ("");
  Serial.println("*************************************");
  b = readdata();
  Serial.print ("Hex ");
  Serial.print (b, HEX);
  Serial.print (" Dec ");
  Serial.print (b);


  if (b == 6) { //hex 6
    Serial.println (" ACK to Display");
  } else if (b == 144) { //hex 90
    Serial.println (" Idle");
  } else  if (b == 165) { //hex A5
    Serial.println (" Ready to TX");

    len = readdata();
    Serial.print(len);
    Serial.println (" commands");

    b = readdata();

    if (b == 64) { // hex 40
      Serial.print ("Menu Control ");
      b = readdata();
      Serial.println(b);
      if (b == 0) {
        Serial.println ("Clears the display");
        Serial.println(readdata());
        checksum();
      } else if (b == 6) {
        Serial.println ("Writes MENU MODE No");
        Serial.println(readdata());
        checksum();
      } else if (b == 7) {
        Serial.println ("Menu Number");
        Serial.println(readdata()+1);
        checksum();
      } else if (b == 8) { //8
        Serial.println ("Unknown 8");
        Serial.println(readdata());
        checksum();
      } else if (b == 10) { //0A
        Serial.println ("Setting: OFF/ON");
        Serial.println(readdata());
        checksum();
      } else if (b == 45) { //0A
        Serial.println ("Setting: 1KHz/2.5KHz/5KHz");
        Serial.println(readdata());
        checksum();
      } else if (b == 55) { //37
        Serial.println ("Unknown 55 ");
        Serial.println(readdata());
        checksum();
      } else if (b == 60) { //3C
        Serial.println ("Unknown 60");
        Serial.println(readdata());
        checksum();
      } else if (b == 78) {
        Serial.println ("Display S symbol");
        Serial.println(readdata());
        checksum();
      } else if (b == 80) {
        Serial.println ("Setting: TONE Freq");
        Serial.println(readdata());
        checksum();
      }
    } else if (b == 65) {  //hex 41
      Serial.println ("Display");
      Serial.print ("Line ");
      Serial.println(readdata());
      Serial.print ("Position ");
      Serial.println(readdata());
      for (i = 0; i < len - 4; i++) {
        ch = readdata();
        Serial.print(ch);
        Serial.print (" ");
        Serial.write(ch);
        Serial.println ("");
      }
      checksum();

    } else  if (b == 67) {
      Serial.println ("Meter");
      Serial.println(readdata());
      checksum();

    } else  if (b == 76) {
      Serial.println ("Ext Meter");
      Serial.println(readdata());
      checksum();

    } else  if (b == 75) {
      Serial.println ("LED Control");
      Serial.println(readdata());
      checksum();

    }


  }


}


byte readdata() {
  while (!altSerial.available()) {
  }
  return altSerial.read();
}

void checksum() {
  Serial.print ("checksum ");
  Serial.println(readdata());
}
