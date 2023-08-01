#include <EEPROM.h>

int addr = 0;
int value;

void setup() {
  Serial.begin(9600);
}

void loop() {
  //Serial.println("Enter data:");
  while (Serial.available() == 0) {}     //wait for data available
  String teststr = Serial.readString();  //read until timeout
  teststr.trim();                        // remove any \r \n whitespace at the end of the String
  if (teststr == "a") {
    Serial.println("a1");
    EEPROM.write(addr, 0);
    
  }
  if (teststr == "b") {
    Serial.println("b1");
  EEPROM.write(addr, 1);
    
  } 
  if (teststr == "c") {
    Serial.println("c1");
    EEPROM.write(addr, 2);
    
  }
  if (teststr == "d") {
    //Serial.println("read");
    value = EEPROM.read(addr);
    Serial.println(value);

  }
  
}