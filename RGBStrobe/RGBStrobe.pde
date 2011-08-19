#include <RGBStrober.h>

int REDPin = 9;
int GREENPin = 10;
int BLUEPin = 11;
RGBStrober rgbStrober(REDPin, BLUEPin, GREENPin, 10);

void setup()
{
  
  pinMode(REDPin, OUTPUT);
  pinMode(BLUEPin, OUTPUT);
  pinMode(GREENPin, OUTPUT);
  
  
  
  Serial.begin(9600);
  Serial.println('setup complete');
}

void loop()
{
  rgbStrober.interrupt();
}
