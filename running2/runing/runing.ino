// Insert file Library
#include <SPI.h>
#include <DMD2.h>
#include <fonts/Arial_Black_16.h>
String str;
SoftDMD dmd(1,1);
// Number of P10 panels used X, Y
DMD_TextBox box(dmd, 2, 1, 32, 16); 
// Set Box (dmd, x, y, Height, Width) 
void setup() {
  dmd.setBrightness(255); // Set brightness 0 - 255 
  dmd.selectFont(Arial_Black_16); // Font used
  dmd.begin();     // Start DMD 
   Serial.begin(9600);
  //box.print("SFE"); // Display TEXT SFE
}
void loop() {
 
Serial.println("Enter data:");
while (Serial.available() == 0) {}
str=Serial.readString();
box.print(str);
}
