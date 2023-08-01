#include <Keypad.h>

int relay_pin = A0;

long int timer = 0;

const int ROW_NUM = 4; //four rows
const int COLUMN_NUM = 3; //three columns

char keys[ROW_NUM][COLUMN_NUM] = {
  {'1', '2', '3'},
  {'4', '5', '6'},
  {'7', '8', '9'},
  {'*', '0', '#'}
};

byte pin_rows[ROW_NUM] = {9, 8, 7, 6}; //connect to the row pinouts of the keypad
byte pin_column[COLUMN_NUM] = {5, 4, 3}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), pin_rows, pin_column, ROW_NUM, COLUMN_NUM );


String input_value;

void setup() {

  pinMode(relay_pin, OUTPUT);


  Serial.begin(9600);
  input_value.reserve(32); // maximum input characters is 33, change if needed
}

void loop() {
  char key = keypad.getKey();

  if (key) {
    Serial.println(key);

    if (key == '*') {
      input_value = ""; // clear input value
    } else if (key == '#') {

      timer = input_value.toInt();


     timer = timer * 1000; //time in seconds
      //timer = timer * 1000 * 60; //time in minuts
     // timer = timer * 1000 * 60 * 60; //time in hours

      digitalWrite(relay_pin, HIGH);
      Serial.println("relay on");

      delay(timer);
      digitalWrite(relay_pin, LOW);
      Serial.println("relay off");

      timer = 0;



      input_value = ""; // clear input value
    } else {
      input_value += key; // append new character to input value string
    }
  }
}
