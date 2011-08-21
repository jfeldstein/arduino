#include <RGBHueCycle.h>

int FlexPin = A0;
int RedPin = 9;

boolean isFlashing = false;
boolean isFlexed = false;
boolean lastIsFlexed = false;
float *colorsHSV;
float flashV;
float flashS;
int flashStep;
const int FLASHING_UP = 1;
const int FLASHING_GLOW = 2;
const int FLASHING_DOWN = 3;
int glowTimer = 200;

RGBHueCycle rgbHueCycle(15, 0, 0);

void setup() {
  // initialize the LED pins as outputs:
  pinMode(RedPin+0, OUTPUT);
  pinMode(RedPin+1, OUTPUT);
  pinMode(RedPin+2, OUTPUT);
  
  Serial.begin(9600); 
}

void loop(){
  int flex = analogRead(FlexPin);
  
  isFlexed = (flex < 330);
  
  if(isFlexed && !lastIsFlexed)
  {
    // (Re)start pulse
    flashStep = FLASHING_UP;
    
    // If new flash, store newest colors to flash back to
    if(!isFlashing)
    {
      isFlashing = true;
      colorsHSV = rgbHueCycle.getHSV();
      flashS = colorsHSV[1];
      flashV = colorsHSV[2];
    }
  }
  
  if(isFlashing)
  {
//    Serial.print(flashS);
//    Serial.print(' ');
//    Serial.print(flashV);
//    Serial.print(' ');
//    Serial.print(flashStep);
//    Serial.println(' ');
//    Serial.print(colorsHSV[1]);
//    Serial.print(' ');
//    Serial.print(colorsHSV[2]);
//    Serial.print(' ');
//    Serial.print(flashStep);
//    Serial.println(' ');
//    Serial.println(' ');
    
    switch(flashStep)
    {
      case FLASHING_UP:
        if(flashS > 0) flashS -= flashUpDelta(flashS);
        if(flashV < 1) flashV += flashUpDelta(flashV);
        
        if(flashS < 0) flashS = 0;
        if(flashV > 1) flashV = 1;
        
        writeRGBVal(rgbHueCycle.HSV_to_RGB(colorsHSV[0], flashS, flashV));
        
        if(flashV == 1 && flashS == 0)
        {
          flashStep = FLASHING_GLOW;
          flashV = 0;
        }
        break;
      case FLASHING_GLOW:
        if(flashV++ >= glowTimer)
        {
          flashStep = FLASHING_DOWN;
          flashV = 1;
          flashS = 0;
        }   
        for( int k=0; k<3; k++)
        {
          digitalWrite(RedPin+k, HIGH);
        }
        break;
      case FLASHING_DOWN:
        // Flash down
        if(flashS < colorsHSV[1]) flashS -= flashDownDelta(flashS); // flashDownDelta returns a negative number
        if(flashV > colorsHSV[2]) flashV += flashDownDelta(flashV);
        
        if(flashS > colorsHSV[1]) flashS = colorsHSV[1];
        if(flashV < colorsHSV[2]) flashV = colorsHSV[2];
        
        writeRGBVal(rgbHueCycle.HSV_to_RGB(colorsHSV[0], flashS, flashV));
        
        if(flashS == colorsHSV[1] && flashV == colorsHSV[2])
        {
          isFlashing = false;
          flashStep = 0;
        }
        break;
    }
    delay(10);
  }
  
  if(!isFlashing)
  {
    writeRGB(rgbHueCycle.interrupt());
  }
  
  lastIsFlexed = isFlexed;
}

float flashUpDelta(float v)
{
  return +0.001;
}

float flashDownDelta(float v)
{
  return -0.001;
}

void writeRGBVal(long rgbval)
{
  long rgb[3];
  
  rgb[0] = (rgbval & 0x00FF0000) >> 16; // there must be better ways
  rgb[1] = (rgbval & 0x0000FF00) >> 8;
  rgb[2] = rgbval & 0x000000FF;
  
  writeRGB(rgb);
}

void writeRGB(long* rgb)
{
  if(rgb[0] == 0 && rgb[1] == 0 && rgb[2] == 0)
  {
    Serial.print(flashStep);
    Serial.println(' ');
    Serial.print(flashS);
    Serial.print(' ');
    Serial.print(colorsHSV[1]);
    Serial.println(' ');
    Serial.print(flashV);
    Serial.print(' ');
    Serial.print(colorsHSV[2]);
    Serial.println(' ');
    Serial.println(' ');
  }
  
  for( int k=0; k<3; k++)
  {
    analogWrite(RedPin+k, rgb[k]);
  }
}
