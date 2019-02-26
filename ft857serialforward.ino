#include <AltSoftSerial.h>

AltSoftSerial altSerial;

void setup() {
  Serial.begin(115200);
  while (!Serial) ; // wait for Arduino Serial Monitor to open

  altSerial.begin(62000);

}

void loop() {

  Serial.write (readdata());

}


byte readdata() {
  while (!altSerial.available()) {
  }
  return altSerial.read();
}
