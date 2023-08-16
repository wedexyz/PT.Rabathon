#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include "RTClib.h"
#include <EEPROM.h>
#include <SPI.h>
#include <DMD2.h>
#include <fonts/Arial_Black_16.h>
#include <fonts/Arial14.h>

SoftDMD dmd(2,1);
DMD_TextBox box(dmd, 5, 1, 64, 16); 


int str;
int second;
int minute;
int hour;
int day;
int month;
int year;
int dayofweek;
int weekday;
long current;


int addr = 0;
int value;

int relay_1 = 52;
int relay_2 = 53;
const int tombol_start = 51;
const int tombol_reset = 49;
const int tombol_set = 50;
int start_b = 0;  
int start_rst = 0;  
int start_st = 0;  


//program rtc
RTC_DS3231 rtc;
char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

//program keypad
#define ROW_NUM     4 // four rows
#define COLUMN_NUM  4 // four columns
char keys[ROW_NUM][COLUMN_NUM] = {
  {'1', '2', '3'},
  {'4', '5', '6'},
  {'7', '8', '9'},
  {'*', '0', '#'}
};
byte pin_rows[ROW_NUM]      = {30,31,32,33};
byte pin_column[COLUMN_NUM] = {34,35,36,37};
//byte pin_rows[ROW_NUM]      = {9,8,7,6};//13, 12, 14, 27}; // GIOP19, GIOP18, GIOP5, GIOP17 connect to the row pins
//byte pin_column[COLUMN_NUM] = {5,4,3,2};//26, 25, 33, 32};   // GIOP16, GIOP4, GIOP0, GIOP2 connect to the column pins
Keypad keypad = Keypad( makeKeymap(keys), pin_rows, pin_column, ROW_NUM, COLUMN_NUM );

int cursorColumn = 0;
long int timer = 0;
String input_value;
int counter = 0; 
int attempts = 0; 
int max_attempts = 3; 
String mymints;
int minutes = 0; 
String mysecs; 
int seconds = 0; 
long int total_seconds = 0; 
int secflag = 0; 
int timer_started_flag = 0; 
// Tracks the time since last event fired
unsigned long previousMillis=0;
unsigned long int previoussecs = 0; 
unsigned long int currentsecs = 0; 
unsigned long currentMillis = 0;
int interval= 1 ; // updated every 1 second
int tsecs = 0; 
 
//program lcd
LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display

void setup(){

  dmd.setBrightness(255); // Set brightness 0 - 255 
  //dmd.drawBox(0,0,31,15);
  //dmd.selectFont(Arial_Black_16);
  dmd.selectFont(Arial14);
  dmd.begin();     // Start DMD 
  
  dmd.drawBox(0,0,63,15);
  box.print("Rabanton"); // Display TEXT SFE
  //delay(2000);
 
  lcd.init();                      // initialize the lcd 
  lcd.init();
  lcd.backlight();
  Serial.begin(9600);
  
  pinMode(relay_1,OUTPUT);
  pinMode(relay_2,OUTPUT);
  pinMode(tombol_start,INPUT);
  pinMode(tombol_set,INPUT);
  pinMode(tombol_reset,INPUT);


  
  if (! rtc.begin()) {
    Serial.println("Couldn't find RTC");
    Serial.flush();
    while (1) delay(10);
  }
  if (rtc.lostPower()) {
    Serial.println("RTC lost power, let's set the time!");
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));

  }

}
void waktu(){
  
  DateTime now = rtc.now();
  //lcd.setCursor(0,0);
  lcd.print(rtc.getTemperature()); 

  lcd.setCursor(7,0);
  lcd.print(now.hour()+5, DEC);
  lcd.setCursor(9,0);
  lcd.print(':');
  lcd.setCursor(10,0);
  lcd.print(now.minute(), DEC);
  lcd.setCursor(12,0);
  lcd.print(':');
  lcd.setCursor(13,0);
  lcd.print(now.second(), DEC);
  //SoftDMD dmd(2,1);
  //dmd.clearScreen();
  //dmd.begin();  
  box.clear();
  dmd.drawBox(0,0,63,15);
  //dmd.selectFont(Arial_Black_16); // Font used
  dmd.selectFont(Arial14);
  char buf1[] = "mm:ss";

  //Serial.println(now.toString(buf1));
  //box.print(now.toString(buf1));
  //box.print("T ");

  box.print(now.hour()+5);
  box.print(":");
  box.print(now.toString(buf1));
  //box.print(now.toString(buf1));
  delay(1000);
  
  lcd.clear();
  
  box.clear();
 
 
}

void keypadfunction(){
  //dmd.begin(); 
  start_b   = digitalRead(tombol_start);
  start_st  = digitalRead(tombol_set);
  start_rst = digitalRead(tombol_reset);
  //Serial.print(start_st);
  //Serial.println(start_rst);
  char key = keypad.getKey();
  if (key){Serial.println(key);counter = counter + 1;lcd.setCursor(counter, 1);lcd.print(key); }
  if (key == '1'){mymints = mymints + 1;}
  if (key == '2'){mymints = mymints + 2;}
  if (key == '3'){mymints = mymints + 3;}
  if (key == '4'){mymints = mymints + 4;}
  if (key == '5'){mymints = mymints + 5;}
  if (key == '6'){mymints = mymints + 6;}
  if (key == '7'){mymints = mymints + 7;}
  if (key == '8'){mymints = mymints + 8;}
  if (key == '9'){mymints = mymints + 9;}   
  if (key == '0'){mymints = mymints + 0;}
  
 
  if (start_rst == HIGH){counter = 0;mymints = "";minutes = 0;  mysecs = "";seconds = 0;secflag = 0;  lcd.clear();
  
  } 
  if (start_b == HIGH){ 
                        lcd.clear();minutes = mymints.toInt();Serial.println(minutes);
                        lcd.clear();lcd.print("klik ulang ");//box.print("klik ulang ");
                        dmd.clearScreen();
                        mymints = ""; counter = 0;secflag = 1;
                        while(secflag == 1){forSeconds();}

                        } 
  if (start_st == HIGH){
                        dmd.clearScreen();
                        lcd.clear();
                        minutes = mymints.toInt();

                        lcd.clear();
                        lcd.print("Minutes: ");
                        lcd.setCursor(0,1);
                        lcd.print(minutes);

                        box.print(String ((String)""+"IMin."+minutes+""));
                        //delay(1000);
                  
                        mymints = ""; // empty the string
                        delay(2000);
                        box.clear();dmd.clearScreen();
                        lcd.clear();

                        lcd.setCursor(0,0);
                        lcd.print("Enter Seconds:");
                        box.print("Isec");
                        counter = 0;
                        secflag = 1;
                        while(secflag == 1){
                        forSeconds();
                        }    
  }  
  
  }
 

void forSeconds(){
  
  start_b   = digitalRead(tombol_start);
  start_st  = digitalRead(tombol_set);
  start_rst = digitalRead(tombol_reset);

  
  

  char key = keypad.getKey();
  
  if (key){Serial.println(key);counter = counter + 1;lcd.setCursor(counter, 1);lcd.print(key);}
  if (key == '1'){mysecs = mysecs + 1;}
  if (key == '2'){mysecs = mysecs + 2;}
  if (key == '3'){mysecs = mysecs + 3;}
  if (key == '4'){mysecs = mysecs + 4; }
  if (key == '5'){mysecs = mysecs + 5;}
  if (key == '6'){mysecs = mysecs + 6;}
  if (key == '7'){mysecs = mysecs + 7;}
  if (key == '8'){mysecs = mysecs + 8;}
  if (key == '9'){mysecs = mysecs + 9;}
  if (key == '0'){mysecs = mysecs + 0;}
 
  if (start_rst == HIGH){counter = 0;mymints = "";minutes = 0;  mysecs = "";seconds = 0;secflag = 0;  lcd.clear();}
   
  if (start_b == HIGH){lcd.clear(); seconds = mysecs.toInt();Serial.println(seconds);lcd.clear();
                  
                  value = EEPROM.read(addr);
                  lcd.setCursor(0,0);lcd.print("Seconds: "); 
                  lcd.setCursor(0,1);lcd.print(value);

                  box.clear();dmd.clearScreen();//dmd.drawBox(0,0,63,15);
                  dmd.selectFont(Arial_Black_16);
                  box.print("ON");
                  box.print(value);
                  delay(2000);
                  box.clear();dmd.clearScreen();


                  mysecs = "";
                  
                  delay(2000);lcd.clear();
                  lcd.print("Mins Secs"); 
                  lcd.setCursor(1,1);lcd.print(minutes);
                  lcd.setCursor(10,1);lcd.print(value);
              
                  total_seconds = (minutes * 60) + value ;counter = 0;secflag = 0;timer_started_flag = 1; 
                  lcd.clear();lcd.print("Load:");
                  lcd.setCursor(11,0);lcd.print( total_seconds );
                 

                  while( timer_started_flag == 1){char key = keypad.getKey();
                                                   start_rst = digitalRead(tombol_reset); 

                                                   if (key){Serial.println(key);counter = counter + 1;lcd.setCursor(counter, 1);}
                                                   
                                                   if (start_rst == HIGH){counter = 0;mymints = "";minutes = 0;  mysecs = "";seconds = 0;secflag = 0; total_seconds = 0;timer_started_flag = 0;lcd.clear();
                                                   dmd.clearScreen();
                                                   
                                                   }
                                                   
                                                   lcd.setCursor(0,0);lcd.print("Load:");lcd.setCursor(11,0);lcd.print( total_seconds );lcd.setCursor(0,1); 
                                                
                                                    box.print(String ((String)""+"HM."+total_seconds+""));
                                                    delay(1000);box.clear();dmd.clearScreen();
                                                  
                                                   if( total_seconds > 0){digitalWrite(relay_1, HIGH);digitalWrite(relay_2, HIGH);lcd.print("load ON ");}
                                                   if( total_seconds <= 0){
                                                     total_seconds = 0;
                                                     digitalWrite(relay_1, LOW);digitalWrite(relay_2, LOW);lcd.print("load OFF");
                                                     
                                                     box.print("OFF");
                                                     delay(2000);
                                                    
                                                       counter = 0;mymints = "";minutes = 0;  mysecs = "";seconds = 0;secflag = 0; total_seconds = 0;timer_started_flag = 0;lcd.clear(); 
                                                     //
                                                      }
                                                   
                                                   currentMillis = millis();
                                                   currentsecs = currentMillis / 1000;
                                                   if ((unsigned long)(currentsecs - previoussecs) >= interval) {total_seconds = total_seconds - 1;lcd.clear(); previoussecs = currentsecs; }
                                                   
                                                 
                                                  }

                                              
                  }
  
    if (start_st == HIGH){     
                       box.clear();dmd.clearScreen();
                       lcd.clear(); seconds = mysecs.toInt();Serial.println(seconds);lcd.clear();lcd.setCursor(0,0);
                       delay(100);
                
                       lcd.print("Seconds: "); lcd.setCursor(0,1);lcd.print(seconds);
                      
                       
                       
                       
                       mysecs = "";
                       delay(2000);
                       lcd.clear();


                       lcd.print("Mins Secs");lcd.setCursor(1,1);lcd.print(minutes);lcd.setCursor(10,1);lcd.print(seconds);
                       
                       
                       total_seconds = (minutes * 60) + seconds ;counter = 0;secflag = 0;timer_started_flag = 1; 
                       EEPROM.write(addr, total_seconds );
                       
                       dmd.selectFont(Arial_Black_16);
                       box.print("ON");
                       box.print(total_seconds);
                       delay(2000);
                       box.clear();dmd.clearScreen();
                      
                       
                       lcd.clear();  
                       lcd.print("T Seconds:");
                       lcd.setCursor(11,0);lcd.print( total_seconds );

                       //dmd.drawBox(0,0,63,15);
                     

                       
                       

                       delay(2000);
                       while( timer_started_flag == 1){char key = keypad.getKey();
                                                   start_rst = digitalRead(tombol_reset); 
                                                   if (key){Serial.println(key);counter = counter + 1;lcd.setCursor(counter, 1); }
                                                   if (start_rst == HIGH){counter = 0;mymints = "";minutes = 0;  mysecs = "";seconds = 0;secflag = 0; total_seconds = 0;timer_started_flag = 0;lcd.clear();
                                                    dmd.clearScreen(); }

                                                   lcd.setCursor(0,0);lcd.print("T Seconds:");lcd.setCursor(11,0);lcd.print( total_seconds );lcd.setCursor(0,1);
                                                    box.print(String ((String)""+"HM."+total_seconds+""));
                                                    delay(1000);box.clear();dmd.clearScreen();
                                                   if( total_seconds > 0){digitalWrite(relay_1, HIGH);digitalWrite(relay_2, HIGH);lcd.print("load ON ");}
                                                   if( total_seconds <= 0){total_seconds = 0;
                                                   digitalWrite(relay_1, LOW);digitalWrite(relay_2, LOW);lcd.print("load OFF"); 
                                                   
                                                   box.print("OFF");
                                                   delay(2000);
                                                   counter = 0;mymints = "";minutes = 0;  mysecs = "";seconds = 0;secflag = 0; total_seconds = 0;timer_started_flag = 0;lcd.clear(); 
                                                      
                                                   //reset
                                                    //counter = 0;mymints = "";minutes = 0;  mysecs = "";seconds = 0;secflag = 0;  lcd.clear();
                                                   }
                                                   currentMillis = millis();currentsecs = currentMillis / 1000;
                                                   if ((unsigned long)(currentsecs - previoussecs) >= interval) {total_seconds = total_seconds - 1;lcd.clear();previoussecs = currentsecs;}
                                                  }
                                                  
                      }
  

 
}



void loop()
{
  

  keypadfunction();
  
  waktu();
 

}
