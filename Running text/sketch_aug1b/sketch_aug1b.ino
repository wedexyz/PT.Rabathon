#include <SPI.h>
#include <DMD.h>
#include <TimerOne.h>
#include "SystemFont5x7.h"
#include "Arial_black_16.h"
#define DISPLAYS_ACROSS 1
#define DISPLAYS_DOWN 1
int menit,detik,i,x;
const int StartButton = A0;
const int ResetButton = A1; 		  //Here, another button A1 [Reset] is introduced.
int StartButtonPress = 0;
int StartButtonState = 0;
char b[100];
String str;
DMD dmd(DISPLAYS_ACROSS, DISPLAYS_DOWN);

void ScanDMD(){
dmd.scanDisplayBySPI();
}

void CheckStartButton()
{
int slen = 0;// length of string
detik = 0;// clearing the seconds to start fresh
dmd.clearScreen( true );
dmd.selectFont(SystemFont5x7);
str="Press";
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 0, 0, b, slen, GRAPHICS_NORMAL );
str="Start";
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 0, 8, b, slen, GRAPHICS_NORMAL );
while(1)
{
StartButtonPress = digitalRead(StartButton);
delay(5);
if(StartButtonPress == HIGH)
{	 
dmd.clearScreen( true );
Serial.println("Start Button Pressed");
StartButtonState = 1;
dmd.selectFont(SystemFont5x7);
str="Start";
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 0, 0, b, slen, GRAPHICS_NORMAL );
str="in:";
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 0, 8, b, slen, GRAPHICS_NORMAL );
int i = 0;
Serial.println("Starts in: ");    
for( i=3; i>0; i--)
{
str=String(i);
str.toCharArray(b,2);
dmd.selectFont(SystemFont5x7);
dmd.drawString( 15,8, b,2, GRAPHICS_NORMAL );
Serial.println(i);
delay(1000);
}
Serial.println("-------");
str = "3:00";
Serial.println(str);
slen = str.length()+1;
dmd.selectFont(Arial_Black_16);
dmd.drawString( 0, 0, "3:00", slen, GRAPHICS_NORMAL );
delay(1000);
return;
}
}
}

void setup()
{
Serial.begin(9600);
pinMode(StartButton, INPUT);
pinMode(ResetButton, INPUT);
Timer1.initialize(5000);
Timer1.attachInterrupt(ScanDMD);
dmd.clearScreen(true);
Serial.println("Press Start Button");
}

void loop()
{
Serial.println("Enter data:");
while (Serial.available() == 0) {}     //wait for data available
int slen = 0;
dmd.clearScreen( true );
dmd.selectFont(SystemFont5x7);
str=Serial.readString();
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 1, 5, b, slen, GRAPHICS_NORMAL );
//str="Up";
//slen = str.length()+1;
//str.toCharArray(b,slen);
//dmd.drawString( 8, 8, b, slen, GRAPHICS_NORMAL );


/*
//CheckStartButton();//does not move forward untill Start button is pressed
int ResetButtonPress = 0; //for reading value from StartButton
int ResetButtonState = 0; //initializing the button state
x=1;
str="";
menit=3;//minutes
while(x)
{
int slen = 0;
ResetButtonPress = digitalRead(ResetButton);  //read the button value to Stop

//min and sec reduction process
if(detik>0)
{detik--;}
else if(detik==0)
{
detik=59;
if(menit>0)
{menit--;}
else if(menit==0)
{
detik=0;//seconds
x=0;
}
}

// For stoping action
if(ResetButtonState == 1)
{
Serial.println("Stopped Timer");
Serial.println("Press Start button to Start Again");
dmd.clearScreen( true );
dmd.selectFont(SystemFont5x7);
str="Reset";
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 0, 0, b, slen, GRAPHICS_NORMAL );
str="Time";
str.toCharArray(b,6);
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 0, 8, b, slen, GRAPHICS_NORMAL );
delay(2000);
x=0;
ResetButtonState = 0;
break;// get out of while loop
}

//display countdown
dmd.clearScreen( true );
if(detik<10){str=String(menit)+":0"+String(detik);}
else{str=String(menit)+":"+String(detik);}
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.selectFont(Arial_Black_16);
dmd.drawString( 0, 0, b, slen, GRAPHICS_NORMAL );
Serial.println(str);

//Time up case
if(menit == 0 && detik == 0)
{
Serial.print("Normal Time End");
Serial.println("Time Up");
dmd.clearScreen( true );
dmd.selectFont(SystemFont5x7);
str="Time";
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 4, 0, b, slen, GRAPHICS_NORMAL );
str="Up";
slen = str.length()+1;
str.toCharArray(b,slen);
dmd.drawString( 8, 8, b, slen, GRAPHICS_NORMAL );
delay(2000);
x=0; //TimeUp get out of while  
}





if(ResetButtonPress == 1)
{
Serial.println("Reset Button Pressed");
ResetButtonState = 1;
}
//one second delay
delay(1000);
}
*/
}